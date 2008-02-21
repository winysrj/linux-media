Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1LDncvW006266
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 08:49:38 -0500
Received: from sandbox.cz (sandbox.cz [87.236.197.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1LDn7xj026911
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 08:49:08 -0500
Date: Thu, 21 Feb 2008 14:48:52 +0100 (CET)
From: Adam Pribyl <pribyl@lowlevel.cz>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
In-Reply-To: <37219a840802182044k5a24bcbbm3646560c595df564@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802211403330.9665@sandbox.cz>
References: <20080127173132.551401d9@tux.abusar.org.br>
	<20080128165403.1f7137e0@gaivota>
	<20080128182634.345bd4e8@tux.abusar.org.br>
	<20080128184534.7af7a41b@gaivota>
	<20080128192230.59921445@tux.abusar.org.br>
	<20080129004104.17e20224@gaivota>
	<20080129021904.1d3047d1@tux.abusar.org.br>
	<20080129025020.60fa33de@gaivota>
	<20080129050103.2fae9d61@tux.abusar.org.br>
	<20080129122547.63214371@gaivota>
	<37219a840802182044k5a24bcbbm3646560c595df564@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: 
Subject: Re: [EXPERIMENTAL] cx88+xc3028 - tests are required - was: Re: When
 xc3028/xc2028 will be supported?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I tried latest hg version on LifeView NOT PCI Hybrid! LV3H and fw version 
27 from linuxtv web. It is now loading the firmware but the result is like 
that:

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
cx88[0]: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT [card=63,autodetected]
cx88[0]: TV tuner type 71, Radio tuner type 0
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
tuner' 1-0061: chip found @ 0xc2 (cx88[0])
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: xc2028/3028 firmware name not set!
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
cx88[0]/0: found at 0000:00:10.0, rev: 5, irq: 10, latency: 64, mmio: 
0xdc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 
firmware, ver 2.7
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
cx2388x alsa driver version 0.0.6 loaded
xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
xc2028 1-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
cx88[0]: Calling XC2028/3028 callback
cx88[0]/2: cx2388x 8802 Driver Manager
cx88[0]/2: found at 0000:00:10.2, rev: 5, irq: 10, latency: 64, mmio: 0xde000000
Vortex: init.... <6>cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT [card=63]
cx88[0]/2: cx2388x based DVB/ATSC card
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]/2: xc3028 attached
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...

...
cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*
...
cx88[0]/1: IRQ loop detected, disabling interrupts
cx88[0]: irq aud [0x1101] dn_risci1* dnf_of dn_sync*
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 
0000000000000000.
cx88[0]: Calling XC2028/3028 callback
MTS (4), id 00000000000000f7:
xc2028 1-0061: Loading firmware for type=MTS (4), id 0000000100000007.
xc2028 1-0061: Device is Xceive 0 version 0.0, firmware version 0.0
xc2028 1-0061: Incorrect readback of firmware version.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 
0000000000000000.
cx88[0]: Calling XC2028/3028 callback
i2c-adapter i2c-1: sendbytes: error - bailout.
xc2028 1-0061: i2c output error: rc = -14 (should be 4)
xc2028 1-0061: -14 returned from send
xc2028 1-0061: Error -22 while loading base firmware
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 
0000000000000000.
...

In windows driver there is no cx88*.sys, there is just av88base.sys md5 
dcc17e434bd3863e458dc19eac3359ea

Adam Pribyl

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
