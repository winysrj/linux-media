Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50819 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1G0U3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 16:29:03 -0400
Date: Wed, 27 Jul 2011 22:28:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: James <angweiyang@gmail.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, michael.jones@matrix-vision.de,
	alexg@meprolight.com
Subject: Re: Parallel CMOS Image Sensor with UART Control Interface
In-Reply-To: <CAOy7-nNmeYy14Rm-NYBNqCoCkAs++rTUabiTZehWyBQ-k0M0og@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1107272227270.7435@axis700.grange>
References: <CAOy7-nMnE6_z4pAmw+Jc1riYSeCWwiNS2=_Ya==+7q5=bNrWuw@mail.gmail.com>
 <20110726194035.GF32629@valkosipuli.localdomain>
 <CAOy7-nNmeYy14Rm-NYBNqCoCkAs++rTUabiTZehWyBQ-k0M0og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Jul 2011, James wrote:

> On Wed, Jul 27, 2011 at 3:40 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Mon, Jul 25, 2011 at 04:43:21PM +0800, James wrote:
> >> Dear all,
> >>
> >> Does anyone came across a v4l2 Linux Device Driver for an Image Sensor
> >> that uses Parallel CMOS H/V and can only be control by UART interface
> >> instead of the common I2C or SPI interface?
> >>
> >> A similar sensor is the STMicroelectronics VL5510 Image Sensor
> >> although it support all 3 types of control interface.
> >> (http://www.st.com/internet/automotive/product/178477.jsp)
> >>
> >> Most or all the drivers found I found under drivers/media/video uses
> >> the I2C or SPI interface instead
> >>
> >> I'm new to writing driver and need a reference v4l2 driver for this
> >> type of image sensor to work with OMAP3530 ISP port on Gumstix's Overo
> >> board.
> >>
> >> I just need a very simple v4l2 driver that can extract the image from
> >> the sensor and control over it via the UART control interface.
> >>
> >> Any help is very much appreciated.
> >
> > Hi James,
> >
> > I think there has been a recent discussion on a similar topic under the
> > subject "RE: FW: OMAP 3 ISP". The way to do this would be to implement
> > platform subdevs in V4L2 core, which I think we don't have quite yet.
> >
> > Cc Laurent and Michael.
> >
> > --
> > Sakari Ailus
> > sakari.ailus@iki.fi
> >
> 
> Hi Sakari,
> 
> Thanks for pointing me to the discussion thread.
> 
> I found it from the archive at
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/32700/focus=32721
> 
> I read through the threads and see that I'm indeed in similar
> situation with Alex.
> 
> We both have sensor that output CMOS H/V image and only have
> UART/RS232 for control of the sensor operations via sending/reading
> packet of bytes. i.e. AGC, contrast, brightness etc..
> 
> Since the thread ended on 29-Jun, is there anymore update or information?

Probably obvious, but just to have it mentioned in this thread, such UART 
driver should certainly be implemented as a line discipline.

Thanks
Guennadi

> 
> As I've a MT9V032 camera with Gusmtix Overo, I was hoping to rely on
> the MT9V032 driver as a starting point and adapt it for the VL5510
> sensor using only the UART interface.
> 
> Thanks in adv.
> 
> -- 
> Regards,
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
