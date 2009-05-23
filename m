Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36535 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbZEWAeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 20:34:21 -0400
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
From: Andy Walls <awalls@radix.net>
To: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
Cc: Martin Dauskardt <martin.dauskardt@gmx.de>,
	linux-media@vger.kernel.org
In-Reply-To: <1242901704.3166.8.camel@palomino.walls.org>
References: <200905210909.43333.martin.dauskardt@gmx.de>
	 <1242901704.3166.8.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 22 May 2009 20:31:26 -0400
Message-Id: <1243038686.3164.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-05-21 at 06:28 -0400, Andy Walls wrote:
> On Thu, 2009-05-21 at 09:09 +0200, Martin Dauskardt wrote:
> > An owner of a PVR150 sent me the following dmesg:
> > 
> > [  133.929892] ivtv: Start initialization, version 1.4.1
> > [  133.929957] ivtv0: Initializing card 0
> > [  133.929958] ivtv0: Autodetected Hauppauge card (cx23416 based)
> > [  133.930478] ivtv 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > [  133.983973] tveeprom 3-0050: Hauppauge model 26709, rev F0C1, serial# 
> > 9585403
> > [  133.983975] tveeprom 3-0050: tuner model is Philips FQ1216LME MK5 (idx 121, 
> > type 4)
> > [  133.983977] tveeprom 3-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
> > PAL(D/D1/K) (eeprom 0x74)
> > [  133.983979] tveeprom 3-0050: audio processor is CX25843 (idx 37)
> > [  133.983981] tveeprom 3-0050: decoder processor is CX25843 (idx 30)
> > [  133.983982] tveeprom 3-0050: has no radio
> > [  133.983984] ivtv0: Autodetected Hauppauge WinTV PVR-150
> > [  133.983985] ivtv0: tveeprom cannot autodetect tuner!<6>cx25840 3-0044: 
> > cx25843-24 found @ 0x88 (ivtv i2c driver #0)
> > [  134.017173] tuner 3-0043: chip found @ 0x86 (ivtv i2c driver #0)
> > [  134.017227] tda9887 3-0043: creating new instance
> > [  134.017229] tda9887 3-0043: tda988[5/6/7] found
> > [  134.027029] tuner 3-0061: chip found @ 0xc2 (ivtv i2c driver #0)
> > [  134.034810] wm8775 3-001b: chip found @ 0x36 (ivtv i2c driver #0)
> > [  134.043300] ivtv0: Registered device video0 for encoder MPG (4096 kB)
> > [  134.043325] ivtv0: Registered device video32 for encoder YUV (2048 kB)
> > [  134.043349] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
> > [  134.043373] ivtv0: Registered device video24 for encoder PCM (320 kB)
> > [  134.043375] ivtv0: Initialized card: Hauppauge WinTV PVR-150
> > [  134.043389] ivtv: End initialization
> > [  134.059301] ivtvfb:  no cards found
> > [  135.718015] ivtv 0000:04:00.0: firmware: requesting v4l-cx2341x-enc.fw
> > [  135.737552] ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
> > [  135.937153] ivtv0: Encoder revision: 0x02060039
> > [  135.954204] cx25840 3-0044: firmware: requesting v4l-cx25840.fw
> > [  139.419227] cx25840 3-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
> > [  139.601289] tuner 3-0061: tuner type not set
> > [  139.641404] tuner 3-0061: tuner type not set
> > [  139.828975] tuner 3-0061: tuner type not set
> > 
> > I never saw this.
> 
> We just had an identical problem on the ivtv lists with an HVR-1600 and
> a TCL MNM05-04 tuner with the cx18 driver.
> 
> 
> > Detection of the tuner model is o.k., so why does 
> > autodetection fail?
> 
> tveeprom.c can identify it, but tveeprom.c doesn't know what parameters
> to tell the ivtv driver.  It returns TUNER_ABSENT instead.
> 
> 
> 
> >  What could be the problem?
> > 
> > I looked into tveeprom.c:
> > 
> > 	{ TUNER_ABSENT,        		"Philips FQ1216LME MK5"},
> 
> This is the problem.
> 
> 
> > Does this mean the tuner is not supported? Should we try "modprobe ivtv 
> > tuner=81" (this is the FQ1216LME MK3) ?
> 
> Yes.  If 81 is the the FQ1216LME MK3, then this will likely work.  Let
> me know how the reception is, and I can get the entry changed in
> tveeprom.c.

Martin,

I don't see tuner type 81 in the list in tuners.h.  I do see:


#define TUNER_PHILIPS_FQ1216ME          24      /* you must actively select B/G/D/K, I, L, L` */
#define TUNER_PHILIPS_FQ1216AME_MK4     56      /* Hauppauge PVR-150 PAL */

#define TUNER_PHILIPS_FM1216ME_MK3      38

#define TUNER_PHILIPS_FMD1216ME_MK3     63
#define TUNER_PHILIPS_FMD1216MEX_MK3    78
#define TUNER_PHILIPS_FM1216MK5         79

Could the user try one of those, starting with the FQ1216 tuner numbers
(24 and 56), to see if one of them works?  For the FQ1261LME MK3,
tveeprom has the FM1216ME_MK3 tuner number (38).


> 
> 
> > By the way: There is a small bug in ivtv-driver.c.
> >  I think instead of
> > 
> > 	if (tv.tuner_type == TUNER_ABSENT)
> > 		IVTV_ERR("tveeprom cannot autodetect tuner!");
> > 
> > it should be
> > 
> > 	if (tv.tuner_type == TUNER_ABSENT)
> > 		IVTV_ERR("tveeprom cannot autodetect tuner!\n");

I'll commit a fix for this.  I'm just waiting on which tuner # works
best for the user with the problem.

Regards,
Andy

> > Greets,
> > Martin


