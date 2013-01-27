Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3A0QQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 11:16:38 -0500
Date: Sun, 27 Jan 2013 14:16:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
Message-ID: <20130127141633.5f751e5d@redhat.com>
In-Reply-To: <51054759.7050202@netscape.net>
References: <51054759.7050202@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Jan 2013 12:27:21 -0300
Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:

> Hi all
> 
> I'm trying to run the digital part of the card MyGica X8507 and I need 
> help on some issues.
> 
> 
> 
> Need data sheet of IC MB86A20S and no where to get it. Fujitsu People of 
> Germany told me: "This is a very old product and not supported any 
> more". Does anyone know where to get it?

I never found any public datasheet for this device.

> 
> linux-puon:/home/alfredo # modprobe cx23885 i2c_scan=1
> 
> ...
> 
> [ 7011.618381] cx23885[0]: scan bus 0:
> 
> [ 7011.620759] cx23885[0]: i2c scan: found device @ 0x20 [???]
> 
> [ 7011.625653] cx23885[0]: i2c scan: found device @ 0x66 [???]
> 
> [ 7011.629702] cx23885[0]: i2c scan: found device @ 0xa0 [eeprom]
> 
> [ 7011.629983] cx23885[0]: i2c scan: found device @ 0xa4 [???]
> 
> [ 7011.630267] cx23885[0]: i2c scan: found device @ 0xa8 [???]
> 
> [ 7011.630548] cx23885[0]: i2c scan: found device @ 0xac [???]
> 
> [ 7011.636438] cx23885[0]: scan bus 1:
> 
> [ 7011.650108] cx23885[0]: i2c scan: found device @ 0xc2 
> [tuner/mt2131/tda8275/xc5000/xc3028]
> 
> [ 7011.654460] cx23885[0]: scan bus 2:
> 
> [ 7011.656434] cx23885[0]: i2c scan: found device @ 0x66 [???]
> 
> [ 7011.657087] cx23885[0]: i2c scan: found device @ 0x88 [cx25837]
> 
> [ 7011.657393] cx23885[0]: i2c scan: found device @ 0x98 [flatiron]
> 
> ...
> 
> 
> In the bus 0 is demodulator mb86a20s 0x20 (0x10) and in the bus 1 the 
> tuner (xc5000). I understand that would have to be cancel the mb86a20s 
> i2c_gate_ctrl similarly as in the IC zl10353. If this is possible, is 
> not yet implemented in the controller of mb86a20s. The IC cx23885 is 
> always who controls the tuner i2c bus.

Well, if you don't add an i2c_gate_ctrl() callback, the mb86a20s won't
be calling it. So, IMO, the cleanest approach would simply to do:

	fe->dvb.frontend->ops.i2c_gate_ctrl = NULL;

after tuner attach, if the tuner or the bridge driver implements an i2c gate.
I don't think xc5000 does. The mb86a20s also has its own i2c gate and gpio
ports that might be used to control an external gate, but support for it is
currently not implemented, as no known device uses it.

So, all you need is to attach both mb86a20s and xc5000 on it, and set the
proper GPIO's.

It will call fe->ops.tuner_ops.set_params(fe) inside the set_frontend() fops
logic, in order to tune the device, but this is the same thing as
zl10353_set_parameters does.

> 
> Please, could you tell me if I'm reasoning correctly?
> 
> 
> Using RegSpy I see the bus 0 alternately accesses to addresses 0x20 and 
> 0x66under Windows 7. In Windows XP only accessed to 0x20 and when the pc 
> starts to 0xa0.
> 
> Bus 2 (internal) always accesse to 0x88
> 
> The bus 0 and 2 (internal) access to the address 0x66 (according 
> modprobe cx23885 i2c_scan), What's there?

Maybe a remote controller? Do you have a high-resolution picture of the
board?

Regards,
Mauro
