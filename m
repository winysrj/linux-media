Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34967 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751183AbZFFTMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2009 15:12:38 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Andy Walls <awalls@radix.net>
Subject: Re: [PATCH v2] tuner-simple, tveeprom: Add support for the FQ1216LME MK3
Date: Sat, 6 Jun 2009 21:13:17 +0200
Cc: linux-media@vger.kernel.org,
	hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Dmitri Belimov <d.belimov@gmail.com>, Ant <ant@symons.net.au>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
References: <200905210909.43333.martin.dauskardt@gmx.de> <1244238732.4440.15.camel@palomino.walls.org> <1244253581.3140.28.camel@palomino.walls.org>
In-Reply-To: <1244253581.3140.28.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906062113.17640.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, 6. Juni 2009 03:59:41 schrieb Andy Walls:
> Hi,
> 
> This is version 2 of the patch that:
> 
> 1. adds explicit support for the FQ1216LME MK3
> 
> 2. points the tveeprom module to the FQ1216LME MK3 entry for EEPROMs
> claiming FQ1216LME MK3 and MK5.
> 
> 3. refactors some code in simple_post_tune() because
> I needed to set the Auxillary Byte, as did TUNER_LG_TDVS_H06XF, so I
> could set the TUA6030 TOP to external AGC per the datasheet.
> 
> 
> The patch no longer twiddles the CP bit nor polls the FL bit for the
> FQ1216LME.  That will be something for another patch.
> 
> 
> Any other comments?
> 
Hi Andy,

I have tested this with a current v4l-dvb hg and kernel 2.6.29 with my PVR 150 
(FQ1216LME MK5). 
It works like using tuner type 38, but unfortunately it does not solve the 
problem of ocassionally loosing audio. This happens even on the video inputs!

I need to do further testings with older drivers/kernels to verify if this may 
be an issue of the new i2c stuff. Testing is very difficult, because 
sometimes it works for an hour and more, maybe depending on the temperature 
or the moon phase.

The problem reminds me a little bit on this:
http://www.gossamer-threads.com/lists/ivtv/users/39029

This is what dmesg says:

[ 1864.639391] ivtv: Start initialization, version 1.4.1
[ 1864.639484] ivtv0: Initializing card 0
[ 1864.639489] ivtv0: Autodetected Hauppauge card (cx23416 based)
[ 1864.641281] ivtv 0000:01:09.0: PCI INT A -> Link[APC4] -> GSI 19 (level, 
low) -> IRQ 19
[ 1864.694693] tveeprom 0-0050: Hauppauge model 26709, rev F0C1, serial# 
9585403
[ 1864.694697] tveeprom 0-0050: tuner model is Philips FQ1216LME MK5 (idx 121, 
type 80)
[ 1864.694700] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) (eeprom 0x74)
[ 1864.694703] tveeprom 0-0050: audio processor is CX25843 (idx 37)
[ 1864.694705] tveeprom 0-0050: decoder processor is CX25843 (idx 30)
[ 1864.694707] tveeprom 0-0050: has no radio
[ 1864.694709] ivtv0: Autodetected Hauppauge WinTV PVR-150
[ 1864.704531] cx25840 0-0044: cx25843-24 found @ 0x88 (ivtv i2c driver #0)
[ 1864.723533] tuner 0-0043: chip found @ 0x86 (ivtv i2c driver #0)
[ 1864.723613] tda9887 0-0043: creating new instance
[ 1864.723615] tda9887 0-0043: tda988[5/6/7] found
[ 1864.730824] tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
[ 1864.741408] wm8775 0-001b: chip found @ 0x36 (ivtv i2c driver #0)
[ 1864.749596] tuner-simple 0-0061: creating new instance
[ 1864.749599] tuner-simple 0-0061: type set to 80 (Philips FQ1216LME MK3 
PAL/SECAM w/active loopthrough)
[ 1864.752114] IRQ 19/ivtv0: IRQF_DISABLED is not guaranteed on shared IRQs
[ 1864.753099] ivtv0: Registered device video0 for encoder MPG (4096 kB)
[ 1864.756347] ivtv0: Registered device video32 for encoder YUV (2048 kB)
[ 1864.760023] ivtv0: Registered device vbi1 for encoder VBI (1024 kB)
[ 1864.764195] ivtv0: Registered device video24 for encoder PCM (320 kB)
[ 1864.764199] ivtv0: Initialized card: Hauppauge WinTV PVR-150
[ 1864.770863] ivtv: End initialization
[ 1864.797718] usbcore: registered new interface driver pvrusb2
[ 1864.797727] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 
Encoder/Tuner
[ 1864.797729] pvrusb2: Debug mask is 31 (0x1f)
[ 1864.843601] saa7146: register extension 'budget_ci dvb'.
[ 1864.862564] saa7146: register extension 'budget dvb'.
[ 1864.891936] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip 
loaded successfully
[ 1865.423084] lirc_serial: auto-detected active low receiver
[ 1865.423089] lirc_dev: lirc_register_driver: sample_rate: 0
[ 1865.424882] lirc_serial $Revision: 5.100 $ registered
[ 1871.259020] ivtv 0000:01:09.0: firmware: requesting v4l-cx2341x-enc.fw
[ 1871.298034] ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
[ 1871.498142] ivtv0: Encoder revision: 0x02060039
[ 1871.514028] cx25840 0-0044: firmware: requesting v4l-cx25840.fw
[ 1874.755988] cx25840 0-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
[ 4426.500017] Clocksource tsc unstable (delta = -62502716 ns)

Greets,
Martin
