Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma03.mx.aol.com ([64.12.206.41]:34337 "EHLO
	imr-ma03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3A0VwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 16:52:08 -0500
Message-ID: <5105A0C9.6070007@netscape.net>
Date: Sun, 27 Jan 2013 18:48:57 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com>
In-Reply-To: <20130127141633.5f751e5d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

El 27/01/13 13:16, Mauro Carvalho Chehab escribió:
> Em Sun, 27 Jan 2013 12:27:21 -0300
> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
>
>> Hi all
>>
>> I'm trying to run the digital part of the card MyGica X8507 and I need
>> help on some issues.
>>
>>
>>
>> Need data sheet of IC MB86A20S and no where to get it. Fujitsu People of
>> Germany told me: "This is a very old product and not supported any
>> more". Does anyone know where to get it?
> I never found any public datasheet for this device.

Congratulations for driver you have made

>
>> linux-puon:/home/alfredo # modprobe cx23885 i2c_scan=1
>>
>> ...
>>
>> [ 7011.618381] cx23885[0]: scan bus 0:
>>
>> [ 7011.620759] cx23885[0]: i2c scan: found device @ 0x20 [???]
>>
>> [ 7011.625653] cx23885[0]: i2c scan: found device @ 0x66 [???]
>>
>> [ 7011.629702] cx23885[0]: i2c scan: found device @ 0xa0 [eeprom]
>>
>> [ 7011.629983] cx23885[0]: i2c scan: found device @ 0xa4 [???]
>>
>> [ 7011.630267] cx23885[0]: i2c scan: found device @ 0xa8 [???]
>>
>> [ 7011.630548] cx23885[0]: i2c scan: found device @ 0xac [???]
>>
>> [ 7011.636438] cx23885[0]: scan bus 1:
>>
>> [ 7011.650108] cx23885[0]: i2c scan: found device @ 0xc2
>> [tuner/mt2131/tda8275/xc5000/xc3028]
>>
>> [ 7011.654460] cx23885[0]: scan bus 2:
>>
>> [ 7011.656434] cx23885[0]: i2c scan: found device @ 0x66 [???]
>>
>> [ 7011.657087] cx23885[0]: i2c scan: found device @ 0x88 [cx25837]
>>
>> [ 7011.657393] cx23885[0]: i2c scan: found device @ 0x98 [flatiron]
>>
>> ...
>>
>>
>> In the bus 0 is demodulator mb86a20s 0x20 (0x10) and in the bus 1 the
>> tuner (xc5000). I understand that would have to be cancel the mb86a20s
>> i2c_gate_ctrl similarly as in the IC zl10353. If this is possible, is
>> not yet implemented in the controller of mb86a20s. The IC cx23885 is
>> always who controls the tuner i2c bus.
> Well, if you don't add an i2c_gate_ctrl() callback, the mb86a20s won't
> be calling it. So, IMO, the cleanest approach would simply to do:
>
> 	fe->dvb.frontend->ops.i2c_gate_ctrl = NULL;
>
> after tuner attach, if the tuner or the bridge driver implements an i2c gate.
> I don't think xc5000 does. The mb86a20s also has its own i2c gate and gpio
> ports that might be used to control an external gate, but support for it is
> currently not implemented, as no known device uses it.

If in this way, it does not work:

     case CX23885_BOARD_MYGICA_X8507:
         i2c_bus = &dev->i2c_bus[0];
         i2c_bus2 = &dev->i2c_bus[1];
         fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
             &mygica_x8507_mb86a20s_config,
             &i2c_bus->i2c_adap);
         if (fe0->dvb.frontend != NULL) {
             dvb_attach(xc5000_attach,
                 fe0->dvb.frontend,
                 &i2c_bus2->i2c_adap,
                 &mygica_x8507_xc5000_config);
         fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
fe0->dvb.frontend->ops.tuner_ops.init(fe0->dvb.frontend);

I get:

...dmesg
...
[  964.105688] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01
[  964.105696] mb86a20s: mb86a20s_set_frontend:
[  964.105700] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters



> So, all you need is to attach both mb86a20s and xc5000 on it, and set the
> proper GPIO's.

I think I'm doing well

     case CX23885_BOARD_MYGICA_X8506:
     case CX23885_BOARD_MYGICA_X8507:
     case CX23885_BOARD_MAGICPRO_PROHDTVE2:
         /* Select Digital TV */
         cx23885_gpio_set(dev, GPIO_0);
         break;

X8508 and X8507 is the same card, just change the digital part.

The driver for windows says:

X8507 means X8502
_________________________________________________________________________________________
[X8502.AddReg]

HKR,"DriverData","TunerModel",0x00010001, 0x03,0x00,0x00,0x00

;Enable TS capture and BDA filter registration
HKR,"DriverData","Enable_BDA",0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x02, 0x00, 0x00, 0x00
HKR,"DriverData","DemodI2CAddress",0x00010001, 0x1E, 0x00, 0x00, 0x00
; this registry keys for the FixNMI option which takes care of the BSODs 
in the
; ICH6/7 chipsets
HKR,"DriverData","FixNMIBit",0x00010001, 0x00,0x00,0x00,0x00
;IR Support
HKR,"DriverData","EnableIR",0x00010001, 0x01, 0x00, 0x00, 0x00
;NEC standard
HKR,"DriverData","IRStandard",0x00010001, 0x01, 0x00, 0x00, 0x00
; GPIO Pin values
HKR,"DriverData","mode_select_gpio_bit", 0x00010001, 0x00, 0x00, 0x00, 0x00
HKR,"DriverData","tuner_reset_gpio_bit", 0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","demod_reset_gpio_bit", 0x00010001, 0x02, 0x00, 0x00, 0x00
HKR,"DriverData","tuner_sif_fm_gpio_bit",0x00010001, 0x03, 0x00, 0x00, 0x00
HKR,"DriverData","comp_select_gpio_bit", 0x00010001, 0xff, 0x00, 0x00, 0x00
HKR,"DriverData","comp_select_panel",    0x00010001, 0xff, 0x00, 0x00, 0x00

;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
HKR,"DriverData","DemodTransferMode",0x00010001, 0x01, 0x00, 0x00, 0x00

;BoardType Sonora353 = 0x03
HKR,"DriverData","BoardType",0x00010001, 0x13, 0x00, 0x00, 0x00
HKR,"DriverData","VideoStandard",0x00010001, 0x10,0x00,0x00,0x00
___________________________________________________________________________________

[X8506.AddReg]

HKR,"DriverData","TunerModel",0x00010001, 0x03,0x00,0x00,0x00

;Enable TS capture and BDA filter registration
HKR,"DriverData","Enable_BDA",0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","DemodI2CAddress",0x00010001, 0x1E, 0x00, 0x00, 0x00
; this registry keys for the FixNMI option which takes care of the BSODs 
in the
; ICH6/7 chipsets
HKR,"DriverData","FixNMIBit",0x00010001, 0x00,0x00,0x00,0x00
;IR Support
HKR,"DriverData","EnableIR",0x00010001, 0x01, 0x00, 0x00, 0x00
;NEC standard
HKR,"DriverData","IRStandard",0x00010001, 0x01, 0x00, 0x00, 0x00
; GPIO Pin values
HKR,"DriverData","mode_select_gpio_bit", 0x00010001, 0x00, 0x00, 0x00, 0x00
HKR,"DriverData","tuner_reset_gpio_bit", 0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","demod_reset_gpio_bit", 0x00010001, 0x02, 0x00, 0x00, 0x00
HKR,"DriverData","tuner_sif_fm_gpio_bit",0x00010001, 0x03, 0x00, 0x00, 0x00
HKR,"DriverData","comp_select_gpio_bit", 0x00010001, 0xff, 0x00, 0x00, 0x00
HKR,"DriverData","comp_select_panel",    0x00010001, 0xff, 0x00, 0x00, 0x00

;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
HKR,"DriverData","DemodTransferMode",0x00010001, 0x01, 0x00, 0x00, 0x00

;BoardType Sonora353 = 0x03
HKR,"DriverData","BoardType",0x00010001, 0x0e, 0x00, 0x00, 0x00
HKR,"DriverData","VideoStandard",0x00010001, 0x10,0x00,0x00,0x00
______________________________________________________________________________________


there is only change in:

HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x01, 0x00, 0x00, 0x00

and

HKR,"DriverData","BoardType",0x00010001, 0x0e, 0x00, 0x00, 0x00

>
> It will call fe->ops.tuner_ops.set_params(fe) inside the set_frontend() fops
> logic, in order to tune the device, but this is the same thing as
> zl10353_set_parameters does.

I expected something like this:

 From zl10353, page 12:

3.1.2
  Tuner
The ZL10353 has a General Purpose Port that can be configured to provide 
a secondary 2-wire bus. See register
GPP_CTL address 0x8C.
Master control mode is selected by setting register SCAN_CTL (0x62) [b3] 
= 1.

 From V4L driver, zl10353.c

static int zl10353_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
{
     struct zl10353_state *state = fe->demodulator_priv;
     u8 val = 0x0a;

     if (state->config.disable_i2c_gate_ctrl) {
         /* No tuner attached to the internal I2C bus */
         /* If set enable I2C bridge, the main I2C bus stopped hardly */
         return 0;
     }

     if (enable)
         val |= 0x10;

     return zl10353_single_write(fe, 0x62, val);


Maybe I'm misunderstanding the code.


When I do notknow the pins of integrated circuits I can not measure the 
state of the GPIO.
>
>> Please, could you tell me if I'm reasoning correctly?
>>
>>
>> Using RegSpy I see the bus 0 alternately accesses to addresses 0x20 and
>> 0x66under Windows 7. In Windows XP only accessed to 0x20 and when the pc
>> starts to 0xa0.
>>
>> Bus 2 (internal) always accesse to 0x88
>>
>> The bus 0 and 2 (internal) access to the address 0x66 (according
>> modprobe cx23885 i2c_scan), What's there?
> Maybe a remote controller? Do you have a high-resolution picture of the
> board?

Do not know if I can be the remote, but only does so under windows7 bus 
0 accesses the address 0x66.
Under Windows XP does not access the bus 0 to address 0x66.

I have no photos in high resolution, but I can get a camera if it helps 
you to help me.


Here are photos in low resolution:

http://www.linuxtv.org/wiki/index.php/Geniatech/MyGica_X8507_PCI-Express_Hybrid_Card

Thank you very much

Alfredo

