Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41031 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1GZTkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 15:40:40 -0400
Date: Tue, 26 Jul 2011 22:40:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: James <angweiyang@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	michael.jones@matrix-vision.de
Subject: Re: Parallel CMOS Image Sensor with UART Control Interface
Message-ID: <20110726194035.GF32629@valkosipuli.localdomain>
References: <CAOy7-nMnE6_z4pAmw+Jc1riYSeCWwiNS2=_Ya==+7q5=bNrWuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOy7-nMnE6_z4pAmw+Jc1riYSeCWwiNS2=_Ya==+7q5=bNrWuw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 25, 2011 at 04:43:21PM +0800, James wrote:
> Dear all,
> 
> Does anyone came across a v4l2 Linux Device Driver for an Image Sensor
> that uses Parallel CMOS H/V and can only be control by UART interface
> instead of the common I2C or SPI interface?
> 
> A similar sensor is the STMicroelectronics VL5510 Image Sensor
> although it support all 3 types of control interface.
> (http://www.st.com/internet/automotive/product/178477.jsp)
> 
> Most or all the drivers found I found under drivers/media/video uses
> the I2C or SPI interface instead
> 
> I'm new to writing driver and need a reference v4l2 driver for this
> type of image sensor to work with OMAP3530 ISP port on Gumstix's Overo
> board.
> 
> I just need a very simple v4l2 driver that can extract the image from
> the sensor and control over it via the UART control interface.
> 
> Any help is very much appreciated.

Hi James,

I think there has been a recent discussion on a similar topic under the
subject "RE: FW: OMAP 3 ISP". The way to do this would be to implement
platform subdevs in V4L2 core, which I think we don't have quite yet.

Cc Laurent and Michael.

-- 
Sakari Ailus
sakari.ailus@iki.fi
