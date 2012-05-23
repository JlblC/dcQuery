my ($gath_name,$car_name) = ('сбор','перевозка');
my @gathfleets = $Empire->fleets()->getFleetsByName($gath_name);
foreach (@gathfleets)
  {
    my @units=$_->getUnitsByClass(23);
    my @carriers=grep _('name') eq $car_name ,$Empire->fleets()->getFleetsByLocation(_('x,y'));
    $_=$carriers[0];
    next unless $_;
    $units[0]->transferToAnotherFleet(_('id'));
    $Empire->writeVariable('ReturnFor'._('id'),_('x:y'));
    $_->jump(_($Empire->planets()->getNearestMy(_('x,y')),'x,y'));
  }
my @carfleets = grep !_('turns_till_arrival'), $Empire->fleets()->getFleetsByName($car_name);
foreach (@carfleets)
  {
    my $box=($_->getUnitsByClass(23))[0];
    next unless $box;
    $box->transferToAnotherFleet(0);
    $box->unpack;
    $_->jump(split(/:/,_('ReturnFor'))); 
  }
