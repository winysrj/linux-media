Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0UNOjRw026367
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 18:24:45 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0UNOR2m011598
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 18:24:27 -0500
From: "Curran, Dominic" <dcurran@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 30 Jan 2009 17:24:20 -0600
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B5012A594C43@dlee07.ent.ti.com>
In-Reply-To: <200901300954.09317.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: linux-omap <linux-omap@vger.kernel.org>,
	"greg.hofer@hp.com" <greg.hofer@hp.com>
Subject: RE: [OMAPZOOM][PATCH 3/6] IMX046: Add support for Sony imx046
 sensor.
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



> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Friday, January 30, 2009 2:54 AM
> To: video4linux-list@redhat.com
> Cc: Curran, Dominic; linux-omap; greg.hofer@hp.com
> Subject: Re: [OMAPZOOM][PATCH 3/6] IMX046: Add support for Sony imx046 sensor.
>
> Hi Dominic!
>
> First a small thing: please post to the new linux-media list in the future
> as this list is being phased out.

[DC]
OK, I have now subscribed to that list and will post to it when I resubmit.
Thanks.


> On Friday 30 January 2009 01:53:38 Dominic Curran wrote:
> > From: Dominic Curran <dcurran@ti.com>
> > Subject: [OMAPZOOM][PATCH 3/6] IMX046: Add support for Sony imx046
> > sensor.
> >
> > This patch adds the driver files for the Sony IMX046 8MP camera sensor.
> > Driver sets up the sensor to send frame data via the MIPI CSI2 i/f.
> > Sensor is setup to output the following base sizes:
> >  - 3280 x 2464 (8MP)
> >  - 3280 x 616  (2MP)
> >  - 820  x 616
> > Sensor's output image format is Bayer10 (GrR/BGb).
> >
> > Driver has V4L2 controls for:
> >  - Exposure
> >  - Analog Gain
> >
> > Signed-off-by: Greg Hofer <greg.hofer@hp.com>
> > Signed-off-by: Dominic Curran <dcurran@ti.com>
> > ---
> >  drivers/media/video/Kconfig  |    8
> >  drivers/media/video/Makefile |    1
> >  drivers/media/video/imx046.c | 1635
> > +++++++++++++++++++++++++++++++++++++++++++ drivers/media/video/imx046.h
> > |  326 ++++++++
> >  4 files changed, 1970 insertions(+)
> >  create mode 100644 drivers/media/video/imx046.c
> >  create mode 100644 drivers/media/video/imx046.h
> >
> > Index: omapzoom04/drivers/media/video/Kconfig
> > ===================================================================
> > --- omapzoom04.orig/drivers/media/video/Kconfig
> > +++ omapzoom04/drivers/media/video/Kconfig
> > @@ -334,6 +334,14 @@ config VIDEO_OV3640_CSI2
> >       This enables the use of the CSI2 serial bus for the ov3640
> >       camera.
> >
> > +config VIDEO_IMX046
> > +   tristate "Sony IMX046 sensor driver (8MP)"
> > +   depends on I2C && VIDEO_V4L2
> > +   ---help---
> > +     This is a Video4Linux2 sensor-level driver for the Sony
> > +     IMX046 camera.  It is currently working with the TI OMAP3
> > +          camera controller.
> > +
>
> Does this need an OMAP3 dependency? Or is it fully independent from omap?

[DC]
OK, I have removed the text concerning OMAP3.

Yes, the driver 'should' be independent of OMAP.




> >  config VIDEO_SAA7110
> >     tristate "Philips SAA7110 video decoder"
> >     depends on VIDEO_V4L1 && I2C
> > Index: omapzoom04/drivers/media/video/Makefile
> > ===================================================================
> > --- omapzoom04.orig/drivers/media/video/Makefile
> > +++ omapzoom04/drivers/media/video/Makefile
> > @@ -115,6 +115,7 @@ obj-$(CONFIG_VIDEO_OV9640)      += ov9640.o
> >  obj-$(CONFIG_VIDEO_MT9P012)        += mt9p012.o
> >  obj-$(CONFIG_VIDEO_DW9710) += dw9710.o
> >  obj-$(CONFIG_VIDEO_OV3640)     += ov3640.o
> > +obj-$(CONFIG_VIDEO_IMX046)     += imx046.o
> >
> >  obj-$(CONFIG_USB_DABUSB)        += dabusb.o
> >  obj-$(CONFIG_USB_OV511)         += ov511.o
> > Index: omapzoom04/drivers/media/video/imx046.c
> > ===================================================================
> > --- /dev/null
> > +++ omapzoom04/drivers/media/video/imx046.c
> > @@ -0,0 +1,1635 @@
> > +/*
> > + * drivers/media/video/imx046.c
> > + *
> > + * Sony imx046 sensor driver
> > + *
> > + *
> > + * Copyright (C) 2008 Hewlett Packard
> > + *
> > + * Leverage mt9p012.c
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> > License + * version 2. This program is licensed "as is" without any
> > warranty of any + * kind, whether express or implied.
> > + */
> > +
> > +#include <linux/i2c.h>
> > +#include <linux/delay.h>
> > +#include <media/v4l2-int-device.h>
>
> A general note on the usage of v4l2-int-device.h: this will be phased out
> soon in favor of v4l2-subdev (see
> Documentation/video4linux/v4l2-framework.txt, introduced in 2.6.29).
>
> You might want to discuss this with Vaibhav Hiremath regarding the timescale
> of this conversion and whether it is better to wait until omap has been
> converted before merging this driver. I'm willing to accept the driver
> using the v4l2-int-device interface as long as I get the assurance that it
> will be converted later.

[DC]
Yes I certainly would like for the driver to be accepted into the V4L2 tree.

However, my first goal is to:
 1) run by v4l2 list and get comments.
 2) get it accepted into omapzoom tree.

I believe omapzoom will move to 2.6.29 in near future.  At which stage I will patch this driver as appropriate for v4l2-framework and then resubmit to linux-media.

Thanks
dom


>
> Regards,
>
>       Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
