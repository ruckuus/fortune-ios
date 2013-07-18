<?php

$fortune = array(
	'id' => 1,
	'text' => 'How many engineer does it take to change a light bulb? <br/> Nine.'
);

header('Content-Type: application/json');
echo json_encode($fortune);
