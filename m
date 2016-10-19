Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46688
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932188AbcJSPf7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 11:35:59 -0400
Date: Wed, 19 Oct 2016 13:35:52 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: <ps00de@yahoo.de>
Cc: <linux-media@vger.kernel.org>
Subject: Re: em28xx WinTV dualHD in Raspbian
Message-ID: <20161019133552.72880aed@vento.lan>
In-Reply-To: <003101d2298a$48b12400$da136c00$@yahoo.de>
References: <003101d2298a$48b12400$da136c00$@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 18 Oct 2016 23:55:04 +0200
<ps00de@yahoo.de> escreveu:

> Hi there,
> 
> I am running an updated raspbian image with kernel 4.4.23-v7+, matching
> linux-headers-4.4.23-v7+_4.4.23-v7+-2_armhf from here:
> https://www.niksula.hut.fi/~mhiienka/Rpi/linux-headers-rpi/ and
> dvb-demod-si2168-b40-01.fw (see linuxtv-wiki).
> 
> Before the last apt-get upgrade this works great, but now, it ends up in
> recognizing the device but not create /dev/dvb.
> 
> Log: 
> Oct 18 23:07:59 mediapi kernel: [ 7587.975803] usb 1-1.3: new high-speed USB
> device number 6 using dwc_otg
> Oct 18 23:07:59 mediapi kernel: [ 7588.076796] usb 1-1.3: New USB device
> found, idVendor=2040, idProduct=0265
> Oct 18 23:07:59 mediapi kernel: [ 7588.076817] usb 1-1.3: New USB device
> strings: Mfr=3, Product=1, SerialNumber=2
> Oct 18 23:07:59 mediapi kernel: [ 7588.076842] usb 1-1.3: Product: dualHD
> Oct 18 23:07:59 mediapi kernel: [ 7588.076853] usb 1-1.3: Manufacturer: HCW
> Oct 18 23:07:59 mediapi kernel: [ 7588.076864] usb 1-1.3: SerialNumber:
> 0011540068
> Oct 18 23:08:00 mediapi kernel: [ 7589.111483] media: Linux media interface:
> v0.10
> Oct 18 23:08:00 mediapi kernel: [ 7589.121622] Linux video capture
> interface: v2.00
> Oct 18 23:08:00 mediapi kernel: [ 7589.126137] em28xx: New device HCW dualHD
> @ 480 Mbps (2040:0265, interface 0, class 0)
> Oct 18 23:08:00 mediapi kernel: [ 7589.126157] em28xx: DVB interface 0
> found: isoc
> Oct 18 23:08:00 mediapi kernel: [ 7589.127012] em28xx: chip ID is em28174
> Oct 18 23:08:01 mediapi kernel: [ 7590.338459] em28174 #0: EEPROM ID = 26 00
> 01 00, EEPROM hash = 0x7ee3cbc8
> Oct 18 23:08:01 mediapi kernel: [ 7590.338482] em28174 #0: EEPROM info:
> Oct 18 23:08:01 mediapi kernel: [ 7590.338496] em28174 #0:     microcode
> start address = 0x0004, boot configuration = 0x01
> Oct 18 23:08:01 mediapi kernel: [ 7590.346046] em28174 #0:     AC97 audio (5
> sample rates)
> Oct 18 23:08:01 mediapi kernel: [ 7590.346064] em28174 #0:     500mA max
> power
> Oct 18 23:08:01 mediapi kernel: [ 7590.346079] em28174 #0:     Table at
> offset 0x27, strings=0x0e6a, 0x1888, 0x087e
> Oct 18 23:08:01 mediapi kernel: [ 7590.347683] em28174 #0: Identified as
> Hauppauge WinTV-dualHD DVB (card=99)
> Oct 18 23:08:01 mediapi kernel: [ 7590.355143] tveeprom 4-0050: Hauppauge
> model 204109, rev B2I6, serial# 11540068
> Oct 18 23:08:01 mediapi kernel: [ 7590.355170] tveeprom 4-0050: tuner model
> is SiLabs Si2157 (idx 186, type 4)
> Oct 18 23:08:01 mediapi kernel: [ 7590.355188] tveeprom 4-0050: TV standards
> PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom
> 0xfc)
> Oct 18 23:08:01 mediapi kernel: [ 7590.355204] tveeprom 4-0050: audio
> processor is None (idx 0)
> Oct 18 23:08:01 mediapi kernel: [ 7590.355219] tveeprom 4-0050: has no
> radio, has IR receiver, has no IR transmitter
> Oct 18 23:08:01 mediapi kernel: [ 7590.355233] em28174 #0: dvb set to isoc
> mode.
> Oct 18 23:08:01 mediapi rsyslogd-2007: action 'action 17' suspended, next
> retry is Tue Oct 18 23:08:31 2016 [try http://www.rsyslog.com/e/2007 ]
> Oct 18 23:08:01 mediapi kernel: [ 7590.357918] usbcore: registered new
> interface driver em28xx
> Oct 18 23:08:01 mediapi kernel: [ 7590.369200] em28xx_dvb: disagrees about
> version of symbol dvb_dmxdev_init
> Oct 18 23:08:01 mediapi kernel: [ 7590.369228] em28xx_dvb: Unknown symbol
> dvb_dmxdev_init (err -22)
> […] (multiple „disagrees“ and „unknown symbol“)
> ct 18 23:08:01 mediapi kernel: [ 7590.417607] em28174 #0: Registering input
> extension
> Oct 18 23:08:01 mediapi kernel: [ 7590.455841] Registered IR keymap
> rc-hauppauge
> Oct 18 23:08:01 mediapi kernel: [ 7590.456798] input: em28xx IR (em28174 #0)
> as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/rc/rc0/input0
> Oct 18 23:08:01 mediapi kernel: [ 7590.457059] rc rc0: em28xx IR (em28174
> #0) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/rc/rc0
> Oct 18 23:08:01 mediapi kernel: [ 7590.457715] em28174 #0: Input extension
> successfully initalized
> Oct 18 23:08:01 mediapi kernel: [ 7590.457734] em28xx: Registered (Em28xx
> Input Extension) extension
> 
> 
> Before it stopped working, I have executed the apt upgrade, installed the
> new kernel header and run 
> git clone git://linuxtv.org/media_build.git
> cd media_build 
> ./build
> sudo make install
> 
> No errors appeared.
> 
> What I am doing wrong? The last git clone was approx. in August.

Based on this log:

Oct 18 23:08:01 mediapi kernel: [ 7590.369200] em28xx_dvb: disagrees about version of symbol dvb_dmxdev_init
Oct 18 23:08:01 mediapi kernel: [ 7590.369228] em28xx_dvb: Unknown symbol dvb_dmxdev_init (err -22)

it seems you messed the modules install or you have the V4L2 stack
compiled builtin with a different version. 


Thanks,
Mauro
