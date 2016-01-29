Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34770 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbcA2RVZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 12:21:25 -0500
Received: from recife.lan (unknown [186.213.245.210])
	by lists.s-osg.org (Postfix) with ESMTPSA id 644F346257
	for <linux-media@vger.kernel.org>; Fri, 29 Jan 2016 09:21:24 -0800 (PST)
Date: Fri, 29 Jan 2016 15:21:20 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/13] Add media controller support to em28xx driver
Message-ID: <20160129152120.771eeaa6@recife.lan>
In-Reply-To: <20160129103740.560ba259@recife.lan>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
	<20160129103740.560ba259@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Jan 2016 10:37:40 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 29 Jan 2016 10:10:50 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
> > This series add MC support to the em28xx driver. Among the hybrid TV USB
> > drivers, this is the most complex one, as there are lots of different hardware
> > options that are compatible with this driver.
> > 
> > Yet, it is used with only two analog TV demod drivers (tvp5150 and saa7115)
> > and, optionally, one IF-PLL audio decoder (msp3400). It means that there aren't
> > many I2C drivers that need to be touched.
> > 
> > The PCI drivers are a way more complex, as they may have audio processors and 
> > may use a wide range of other I2C drivers. So, it is wise to implement MC support
> > at em28xx before those, as it helps to address some issues before extending
> > MC to the wild.
> > 
> > The two patches in this series are actually unrelated to MC. The first one is a cleanup
> > at em28xx, and the second patch fixes one KASAN error.
> > 
> > The next patches make the Media Controller aware of the existence of IF-PLL
> > drivers, commonly found on older designs. They also standardize the pad index
> > for tuners, IF-PLLs and demods.
> > 
> > Finally, MC support for tda9887, tvp5150, saa7115 and msp3400 is added, making
> > those drivers to properly report the MC function supported by the driver and
> > creating the source/sink pads for them.
> > 
> > The last patch finally add em28xx MC support.
> > 
> > I opted to not add any helper function for now at v4l2-mc.c, putting all needed code
> > at em28xx, because I didn't want to cause hard to find conflicts with Shuah's patches,
> > that are touching the routines at au0828. After having Shuah patches merged, I'll
> > work to move the generic code to v4l2-mc.c (yet to be created).
> > 
> > This series was tested on the following devices:
> > 
> > Hauppauge HVR-950 (2040:6513):
> > 	https://mchehab.fedorapeople.org/mc-next-gen/hvr_950.png
> > 
> > Haupauge WinTV USB2 (2040:4200):
> > 	https://mchehab.fedorapeople.org/mc-next-gen/wintv_usb2.png
> > 
> > KWorld USB ATSC TV Stick UB435-Q V3 (1b80:e34c):
> > 	https://mchehab.fedorapeople.org/mc-next-gen/kworld_435q.png
> > 
> > PCTV 261e (2013:0258):
> > 	https://mchehab.fedorapeople.org/mc-next-gen/pctv_261e.png
> > 
> > PCTV 290e (2013:024f):
> > 	https://mchehab.fedorapeople.org/mc-next-gen/pctv_290e.png
> > 
> > Pixelview PlayTV USB2 (eb1a:2821):
> > 	https://mchehab.fedorapeople.org/mc-next-gen/playtv_usb.png
> > 
> > 	(an extra patch was needed for it to detect the tuner - I'll send it in separate)  
> 
> Tested also on a pure S-Video/Composite capture card:
> 
> Terratec Grabster AV350 (0ccd:0084):
> 	https://mchehab.fedorapeople.org/mc-next-gen/terratec_av350.png
> 
> This board actually have also a Scart interface, but switching
> between Scart and Video is done via a manual switch. So, the
> driver is actually unable to detect if the input is coming from
> Composite/S-Video or from scart.

Tested also at:

Terratec Grabby (0ccd:0096):
	https://mchehab.fedorapeople.org/mc-next-gen/terratec_grabby.png

Silvercrest Webcam (eb1a:2820):
	https://mchehab.fedorapeople.org/mc-next-gen/silvercrest.png

Webcam support was added on [PATCH v2 13/13].

Terratec Cinergy HTC(0ccd:00b2):
	https://mchehab.fedorapeople.org/mc-next-gen/terratec_cinergy_htc.png

All patches needed for the above devices to work properly are at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=mc_em28xx

Regards,
Mauro
