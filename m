Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43510 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752842AbeE3Hbt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 03:31:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod <vkoul@kernel.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: camera control interface
Date: Wed, 30 May 2018 10:31:51 +0300
Message-ID: <2441685.2FbY4xYTJB@avalon>
In-Reply-To: <20180530072858.GP5666@vkoul-mobl>
References: <20180529082932.GH5666@vkoul-mobl> <2593976.2pOKjEb3EO@avalon> <20180530072858.GP5666@vkoul-mobl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vinod,

On Wednesday, 30 May 2018 10:28:58 EEST Vinod wrote:
> On 30-05-18, 10:04, Laurent Pinchart wrote:
> >> I am writing a driver for camera control inteface which is an i2c
> >> controller. So looking up the code I think it can be a v4l subdev,
> >> right? Can it be an independent i2c master and not v4l subdev?
> > 
> > What do you mean by "camera control interface" here ? A hardware device
> > handling communication with camera sensors ? I assume the communication
> > bus is I2C ? Is that "camera control interface" plain I2C or does it have
> > additional features ?
> > 
> > If we're talking about an I2C controller a V4L2 subdev is not only
> > unneeded, but it wouldn't help. You need an I2C master.
> 
> Sorry if I wasn't quite right in description, the control interface is
> indeed i2c master and gpio. The camera sensors are i2c slaves connected to
> this i2c master and gpio for sensors are connected to this as well.

No worries. This clarifies the context.

> >> Second the control sports GPIOs. It can support  a set of
> >> synchronization primitives so it's possible to drive I2C clients and
> >> GPIOs with hardware controlled timing to allow for sync control of
> >> sensors hooked and also for fancy strobe. How would we represent these
> >> gpios in v4l2 and allow the control, any ideas on that.
> > 
> > Even if your main use case it related to camera, synchronization of I2C
> > and GPIO doesn't seem to be a V4L2 feature to me. It sounds that you need
> > to implement that int he I2C and GPIO subsystems.
> 
> Well if a user wants to capture multiple cameras and synchronise,
> wouldn't that need sync of i2c and gpio. I understand it may not be
> supported but the question is would it be a nice feature for v4l, if so
> how to go about it?

You need two parts to implement this in my opinion. First, you need a 
synchronized I2C + GPIO mechanism on which to base the implementation. That's 
not V4L2-specific and should I believe be handled in the I2C and GPIO 
subsystems. Then, you need to expose the concept of camera synchronization in 
V4L2. That part will likely require API extensions, both inside the kernel and 
towards userspace.

-- 
Regards,

Laurent Pinchart
