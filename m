Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:59082 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754399Ab1G0K4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 06:56:54 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	James <angweiyang@gmail.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"michael.jones@matrix-vision.de" <michael.jones@matrix-vision.de>
Date: Wed, 27 Jul 2011 13:53:57 +0300
Subject: RE: Parallel CMOS Image Sensor with UART Control Interface
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2A5D211E60@MEP-EXCH.meprolight.com>
In-Reply-To: <201107271059.19184.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I want to say that in the beginning I encountered the same problem, but with the support of Laurent and other guys, today on my system OMAP3 ISP successfully passes registration.
To my yet, I still cannot connect my video source because it's missing, but I successfully configure pipeline with use MC User space API.

Regards,

Alex Gershgorin




-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
Sent: Wednesday, July 27, 2011 11:59 AM
To: James
Cc: Sakari Ailus; linux-media@vger.kernel.org; michael.jones@matrix-vision.de; Alex Gershgorin
Subject: Re: Parallel CMOS Image Sensor with UART Control Interface

Hi James,

On Wednesday 27 July 2011 07:41:59 James wrote:
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
>
> Hi Sakari,
>
> Thanks for pointing me to the discussion thread.
>
> I found it from the archive at
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/3270
> 0/focus=32721
>
> I read through the threads and see that I'm indeed in similar
> situation with Alex.
>
> We both have sensor that output CMOS H/V image and only have
> UART/RS232 for control of the sensor operations via sending/reading
> packet of bytes. i.e. AGC, contrast, brightness etc..
>
> Since the thread ended on 29-Jun, is there anymore update or information?
>
> As I've a MT9V032 camera with Gusmtix Overo, I was hoping to rely on
> the MT9V032 driver as a starting point and adapt it for the VL5510
> sensor using only the UART interface.

As a quick hack, to start with, you can still use an I2C subdev driver. Just
remove all I2C-related code from the driver, and register a fake I2C device in
board code. That will let you at least develop the driver and test the UART
interface.

--
Regards,

Laurent Pinchart


__________ Information from ESET NOD32 Antivirus, version of virus signature database 6327 (20110726) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com



__________ Information from ESET NOD32 Antivirus, version of virus signature database 6328 (20110727) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

