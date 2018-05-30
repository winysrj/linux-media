Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43246 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937222AbeE3HE2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 03:04:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod <vkoul@kernel.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: camera control interface
Date: Wed, 30 May 2018 10:04:29 +0300
Message-ID: <2593976.2pOKjEb3EO@avalon>
In-Reply-To: <20180529082932.GH5666@vkoul-mobl>
References: <20180529082932.GH5666@vkoul-mobl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vinod,

On Tuesday, 29 May 2018 11:29:32 EEST Vinod wrote:
> Hi folks,
> 
> I am writing a driver for camera control inteface which is an i2c
> controller. So looking up the code I think it can be a v4l subdev,
> right? Can it be an independent i2c master and not v4l subdev?

What do you mean by "camera control interface" here ? A hardware device 
handling communication with camera sensors ? I assume the communication bus is 
I2C ? Is that "camera control interface" plain I2C or does it have additional 
features ?

If we're talking about an I2C controller a V4L2 subdev is not only unneeded, 
but it wouldn't help. You need an I2C master.

> Second the control sports GPIOs. It can support  a set of
> synchronization primitives so it's possible to drive I2C clients and
> GPIOs with hardware controlled timing to allow for sync control of
> sensors hooked and also for fancy strobe. How would we represent these
> gpios in v4l2 and allow the control, any ideas on that.

Even if your main use case it related to camera, synchronization of I2C and 
GPIO doesn't seem to be a V4L2 feature to me. It sounds that you need to 
implement that int he I2C and GPIO subsystems.

-- 
Regards,

Laurent Pinchart
