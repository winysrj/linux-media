Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53526 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1G0I7V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 04:59:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Parallel CMOS Image Sensor with UART Control Interface
Date: Wed, 27 Jul 2011 10:59:18 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	michael.jones@matrix-vision.de, alexg@meprolight.com
References: <CAOy7-nMnE6_z4pAmw+Jc1riYSeCWwiNS2=_Ya==+7q5=bNrWuw@mail.gmail.com> <20110726194035.GF32629@valkosipuli.localdomain> <CAOy7-nNmeYy14Rm-NYBNqCoCkAs++rTUabiTZehWyBQ-k0M0og@mail.gmail.com>
In-Reply-To: <CAOy7-nNmeYy14Rm-NYBNqCoCkAs++rTUabiTZehWyBQ-k0M0og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271059.19184.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
