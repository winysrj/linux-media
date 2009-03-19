Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46380 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZCSOKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 10:10:18 -0400
Received: by bwz17 with SMTP id 17so511217bwz.37
        for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 07:10:15 -0700 (PDT)
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci,
 and others drivers
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <44390.62.70.2.252.1237469872.squirrel@webmail.xs4all.nl>
References: <44390.62.70.2.252.1237469872.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 17:11:13 +0300
Message-Id: <1237471874.19717.47.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-03-19 at 14:37 +0100, Hans Verkuil wrote:
> > Hello, all
> > What do you think about such patch that makes selecting of radio drivers
> > in menuconfig more comfortable ?
> 
> I think splitting off the ISA drivers is certainly useful. I'm not sure
> whether you need to split the remainder into PCI and Others. I think
> that's overkill.
> 
> Regards,
> 
>         Hans

Yeah, i can inclose isa drivers by this construction:

config RADIO_ADAPTERS_ISA
       boolean "ISA radio adapters"
       ---help---
         Enable this if you have ISA-based radio adapter.

if RADIO_ADAPTERS_ISA

..isa driver..

endif # RADIO_ADAPTERS_ISA

and don't touch other drivers. That looks fine for me.

> > ---
> >
> > Patch divides/separates radio drivers in Kconfig in 3 groups - ISA, PCI
> > and others.
> >
> > Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
> >
> > --
> > diff -r 626c136ec221 linux/drivers/media/radio/Kconfig
> > --- a/linux/drivers/media/radio/Kconfig	Fri Mar 13 14:35:14 2009 -0700
> > +++ b/linux/drivers/media/radio/Kconfig	Thu Mar 19 15:20:12 2009 +0300
> > @@ -10,6 +10,13 @@
> >  	  Say Y here to enable selecting AM/FM radio adapters.
> >
> >  if RADIO_ADAPTERS && VIDEO_V4L2
> > +
> > +config RADIO_ADAPTERS_ISA
> > +	boolean "ISA radio adapters"
> > +	---help---
> > +	  Enable this if you have ISA-based radio adapter.
> > +
> > +if RADIO_ADAPTERS_ISA
> >
> >  config RADIO_CADET
> >  	tristate "ADS Cadet AM/FM Tuner"
> > @@ -150,50 +157,6 @@
> >  	  Say Y here to enable automatic probing for GemTek Radio card. The
> >  	  following ports will be probed: 0x20c, 0x30c, 0x24c, 0x34c, 0x248 and
> >  	  0x28c.
> > -
> > -config RADIO_GEMTEK_PCI
> > -	tristate "GemTek PCI Radio Card support"
> > -	depends on VIDEO_V4L2 && PCI
> > -	---help---
> > -	  Choose Y here if you have this PCI FM radio card.
> > -
> > -	  In order to control your radio card, you will need to use programs
> > -	  that are compatible with the Video for Linux API.  Information on
> > -	  this API and pointers to "v4l" programs may be found at
> > -	  <file:Documentation/video4linux/API.html>.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called radio-gemtek-pci.
> > -
> > -config RADIO_MAXIRADIO
> > -	tristate "Guillemot MAXI Radio FM 2000 radio"
> > -	depends on VIDEO_V4L2 && PCI
> > -	---help---
> > -	  Choose Y here if you have this radio card.  This card may also be
> > -	  found as Gemtek PCI FM.
> > -
> > -	  In order to control your radio card, you will need to use programs
> > -	  that are compatible with the Video For Linux API.  Information on
> > -	  this API and pointers to "v4l" programs may be found at
> > -	  <file:Documentation/video4linux/API.html>.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called radio-maxiradio.
> > -
> > -config RADIO_MAESTRO
> > -	tristate "Maestro on board radio"
> > -	depends on VIDEO_V4L2 && PCI
> > -	---help---
> > -	  Say Y here to directly support the on-board radio tuner on the
> > -	  Maestro 2 or 2E sound card.
> > -
> > -	  In order to control your radio card, you will need to use programs
> > -	  that are compatible with the Video For Linux API.  Information on
> > -	  this API and pointers to "v4l" programs may be found at
> > -	  <file:Documentation/video4linux/API.html>.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called radio-maestro.
> >
> >  config RADIO_SF16FMI
> >  	tristate "SF16FMI Radio"
> > @@ -339,6 +302,68 @@
> >  	help
> >  	  Enter the I/O port of your Zoltrix radio card.
> >
> > +endif # RADIO_ADAPTERS_ISA
> > +
> > +config RADIO_ADAPTERS_PCI
> > +	boolean "PCI radio adapters"
> > +	---help---
> > +	  Enable this if you have PCI-based radio adapters.
> > +
> > +if RADIO_ADAPTERS_PCI
> > +
> > +config RADIO_GEMTEK_PCI
> > +	tristate "GemTek PCI Radio Card support"
> > +	depends on VIDEO_V4L2 && PCI
> > +	---help---
> > +	  Choose Y here if you have this PCI FM radio card.
> > +
> > +	  In order to control your radio card, you will need to use programs
> > +	  that are compatible with the Video for Linux API.  Information on
> > +	  this API and pointers to "v4l" programs may be found at
> > +	  <file:Documentation/video4linux/API.html>.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called radio-gemtek-pci.
> > +
> > +config RADIO_MAXIRADIO
> > +	tristate "Guillemot MAXI Radio FM 2000 radio"
> > +	depends on VIDEO_V4L2 && PCI
> > +	---help---
> > +	  Choose Y here if you have this radio card.  This card may also be
> > +	  found as Gemtek PCI FM.
> > +
> > +	  In order to control your radio card, you will need to use programs
> > +	  that are compatible with the Video For Linux API.  Information on
> > +	  this API and pointers to "v4l" programs may be found at
> > +	  <file:Documentation/video4linux/API.html>.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called radio-maxiradio.
> > +
> > +config RADIO_MAESTRO
> > +	tristate "Maestro on board radio"
> > +	depends on VIDEO_V4L2 && PCI
> > +	---help---
> > +	  Say Y here to directly support the on-board radio tuner on the
> > +	  Maestro 2 or 2E sound card.
> > +
> > +	  In order to control your radio card, you will need to use programs
> > +	  that are compatible with the Video For Linux API.  Information on
> > +	  this API and pointers to "v4l" programs may be found at
> > +	  <file:Documentation/video4linux/API.html>.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called radio-maestro.
> > +
> > +endif # RADIO_ADAPTERS_PCI
> > +
> > +config RADIO_ADAPTERS_OTHERS
> > +	boolean "USB, I2C and others radio adapter interfaces"
> > +	---help---
> > +	  Enable this if you have USB, I2C or others radio interfaces.
> > +
> > +if RADIO_ADAPTERS_OTHERS
> > +
> >  config USB_DSBR
> >  	tristate "D-Link/GemTek USB FM radio support"
> >  	depends on USB && VIDEO_V4L2
> > @@ -406,4 +431,6 @@
> >  	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
> >  	  here if TEA5764 reference frequency is connected in FREQIN.
> >
> > +endif # RADIO_ADAPTERS_OTHERS
> > +
> >  endif # RADIO_ADAPTERS
> >
> >
> >
> > --
> > Best regards, Klimov Alexey
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
-- 
Best regards, Klimov Alexey

