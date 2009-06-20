Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:34773 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZFTOH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 10:07:56 -0400
Date: Sat, 20 Jun 2009 17:01:28 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv8  7/9] FMTx: si4713: Add files to handle si4713 i2c
 device
Message-ID: <20090620140128.GA32540@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1245333351-28157-1-git-send-email-eduardo.valentin@nokia.com>
 <1245333351-28157-7-git-send-email-eduardo.valentin@nokia.com>
 <1245333351-28157-8-git-send-email-eduardo.valentin@nokia.com>
 <200906201527.09666.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906201527.09666.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Jun 20, 2009 at 03:27:09PM +0200, ext Hans Verkuil wrote:
> On Thursday 18 June 2009 15:55:49 Eduardo Valentin wrote:
> > This patch adds files to control si4713 devices.
> > Internal functions to control device properties
> > and initialization procedures are into these files.
> > Also, a v4l2 subdev interface is also exported.
> > This way other drivers can use this as v4l2 i2c subdevice.
> >
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > ---
> >  linux/drivers/media/radio/si4713-i2c.c | 2015
> > ++++++++++++++++++++++++++++++++ linux/drivers/media/radio/si4713-i2c.h |
> >  226 ++++
> >  linux/include/media/si4713.h           |   40 +
> >  3 files changed, 2281 insertions(+), 0 deletions(-)
> >  create mode 100644 linux/drivers/media/radio/si4713-i2c.c
> >  create mode 100644 linux/drivers/media/radio/si4713-i2c.h
> >  create mode 100644 linux/include/media/si4713.h
> >
> 
> <snip>
> 
> > diff --git a/linux/include/media/si4713.h b/linux/include/media/si4713.h
> > new file mode 100644
> > index 0000000..d0960e2
> > --- /dev/null
> > +++ b/linux/include/media/si4713.h
> > @@ -0,0 +1,40 @@
> > +/*
> > + * include/media/si4713.h
> > + *
> > + * Board related data definitions for Si4713 i2c device driver.
> > + *
> > + * Copyright (c) 2009 Nokia Corporation
> > + * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> > License + * version 2. This program is licensed "as is" without any
> > warranty of any + * kind, whether express or implied.
> > + *
> > + */
> > +
> > +#ifndef SI4713_H
> > +#define SI4713_H
> > +
> > +/* The SI4713 I2C sensor chip has a fixed slave address of 0xc6 or 0x22.
> > */ +#define SI4713_I2C_ADDR_BUSEN_HIGH	0x63
> > +#define SI4713_I2C_ADDR_BUSEN_LOW	0x11
> > +
> > +/*
> > + * Platform dependent definition
> > + */
> > +struct si4713_platform_data {
> > +	/* Set power state, zero is off, non-zero is on. */
> > +	int (*set_power)(int power);
> > +};
> > +
> > +/*
> > + * structure to query for RSSI.
> > + */
> > +struct si4713_rssi {
> > +	unsigned int frequency;
> > +	int rssi;
> > +};
> 
> I propose to change this struct a bit:
> 
> struct si4713_rssi {
> 	__u32 index;		/* modulator index */
> 	__u32 frequency;	/* frequency */
> 	__s32 rssi;		/* result */
> 	__u32 reserved[4];	/* drivers and apps must init this to 0 */
> };
> 
> The idea is that in the future this might become a regular ioctl and in that 
> case it would be nice if we can just copy this struct to videodev2.h and 
> rename it. In that case the si4713 has to support both private and public 
> ioctls, but since the struct pointer passed to ioctl is the same for the 
> private and public ioctls it is very easy to implement that.
> 
> The rssi field needs to be documented better in this header: what is the 
> meaning of the returned value and what is the unit? Does it have to be a 
> signed value, or should it be unsigned instead?
> 

Re-thinking this struct as something that can be moved to videode2.h, then
I agree with you. I'll resend then with the proposed structure and more
description about it.

> > +#define SI4713_IO_MEASURE_RSSI	_IOWR('V', BASE_VIDIOC_PRIVATE + 0, \
> > +						struct si4713_rssi)
> 
> This needs to be documented as well: what exactly does it do? It is 
> important to have that information in this header for future reference.
> 
> Can you also rename it to SI4713_IOC_MEASURE_RSSI? 'IOC' seems to be 
> preferred above 'IO'.

Yes, no problem.

> 
> Regards,
> 
> 	Hans
> 
> > +
> > +#endif /* ifndef SI4713_H*/
> 
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
