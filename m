Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40019 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaJIBuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Oct 2014 21:50:19 -0400
Date: Wed, 8 Oct 2014 22:50:11 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 8 (media/usb/gspca)
Message-ID: <20141008225011.2d034c1e@recife.lan>
In-Reply-To: <5435A44D.2050609@infradead.org>
References: <20141008174923.76786a03@canb.auug.org.au>
	<543570C3.9080207@infradead.org>
	<20141008153105.2fe82fca@recife.lan>
	<5435A44D.2050609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Oct 2014 13:53:33 -0700
Randy Dunlap <rdunlap@infradead.org> escreveu:

> On 10/08/14 11:31, Mauro Carvalho Chehab wrote:
> > Em Wed, 08 Oct 2014 10:13:39 -0700
> > Randy Dunlap <rdunlap@infradead.org> escreveu:
> > 
> >> On 10/07/14 23:49, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Please do not add any material intended for v3.19 to you linux-next
> >>> included trees until after v3.18-rc1 has been released.
> >>>
> >>> Changes since 20141007:
> >>>
> >>
> >> I saw these build errors in gspca when CONFIG_INPUT=m but the gspca
> >> sub-drivers are builtin:
> >>
> >> drivers/built-in.o: In function `gspca_dev_probe2':
> >> (.text+0x10ef43): undefined reference to `input_allocate_device'
> >> drivers/built-in.o: In function `gspca_dev_probe2':
> >> (.text+0x10efdd): undefined reference to `input_register_device'
> >> drivers/built-in.o: In function `gspca_dev_probe2':
> >> (.text+0x10f002): undefined reference to `input_free_device'
> >> drivers/built-in.o: In function `gspca_dev_probe2':
> >> (.text+0x10f0ac): undefined reference to `input_unregister_device'
> >> drivers/built-in.o: In function `gspca_disconnect':
> >> (.text+0x10f186): undefined reference to `input_unregister_device'
> >> drivers/built-in.o: In function `sd_int_pkt_scan':
> >> se401.c:(.text+0x11373d): undefined reference to `input_event'
> >> se401.c:(.text+0x11374e): undefined reference to `input_event'
> >> drivers/built-in.o: In function `sd_pkt_scan':
> >> t613.c:(.text+0x119f0e): undefined reference to `input_event'
> >> t613.c:(.text+0x119f1f): undefined reference to `input_event'
> >> drivers/built-in.o: In function `sd_stopN':
> >> t613.c:(.text+0x11a047): undefined reference to `input_event'
> >> drivers/built-in.o:t613.c:(.text+0x11a058): more undefined references to `input_event' follow
> >>
> >> These could be fixed in Kconfig by something like (for each sub-driver that tests
> >> CONFIG_INPUT):
> >>
> >> 	depends on INPUT || INPUT=n
> >>
> >> Do you have another preference for fixing this?
> > 
> > Hmm... The code at the gspca subdrivers looks like:
> > 
> > #if IS_ENABLED(CONFIG_INPUT)
> 
> For builtin only, that should be
> 
> #if IS_BUILTIN(CONFIG_INPUT)
> 
> > 		if (data[0] & 0x20) {
> > 			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
> > 			input_sync(gspca_dev->input_dev);
> > 			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
> > 			input_sync(gspca_dev->input_dev);
> > 		}
> > #endif
> > 
> > As we never got any report about such bug, and this is there for a long
> > time, I suspect that maybe the IS_ENABLED() macro had some changes on
> > its behavior. So, IMHO, we should first check if something changed there.
> 
> I don't see any changes in <linux/kconfig.h>.

Perhaps some changes at the Kbuild source code or scripts badly affected it.

> 
> > From gpsca's PoV, IMHO, it should be fine to disable the webcam buttons if
> > the webcam was compiled as builtin and the input subsystem is compiled as 
> > module. The core feature expected on a camera is to capture streams. 
> > Buttons are just a plus.
> > 
> > Also, most cams don't even have buttons. The gspca subdriver has support 
> > for buttons for the few models that have it.
> > 
> > So, IMHO, it should be ok to have GSPCA=y and INPUT=m, provided that 
> > the buttons will be disabled.
> 
> Then all of the sub-drivers that use IS_ENABLED(CONFIG_INPUT) should be
> changed to use IS_BUILTIN(CONFIG_INPUT).
> 
> But that is too restrictive IMO.  The input subsystem will work fine when
> CONFIG_INPUT=m and the GSPCA drivers are also loadable modules.

Agreed.

Maybe the solution would be something more complex like 
(for drivers/media/usb/gspca/zc3xx.c):

#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && !IS_BUILTIN(CONFIG_USB_GSPCA_ZC3XX))

Probably the best would be to write another macro that would evaluate
like the above.

> That's simple to express in Kconfig language but probly more messy in CPP.
> 
> 
> Thanks.
> 
> 
