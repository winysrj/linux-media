Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753186AbeE3H3D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 03:29:03 -0400
Date: Wed, 30 May 2018 12:58:58 +0530
From: Vinod <vkoul@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: camera control interface
Message-ID: <20180530072858.GP5666@vkoul-mobl>
References: <20180529082932.GH5666@vkoul-mobl>
 <2593976.2pOKjEb3EO@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2593976.2pOKjEb3EO@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Laurent,

On 30-05-18, 10:04, Laurent Pinchart wrote:
> > 
> > I am writing a driver for camera control inteface which is an i2c
> > controller. So looking up the code I think it can be a v4l subdev,
> > right? Can it be an independent i2c master and not v4l subdev?
> 
> What do you mean by "camera control interface" here ? A hardware device 
> handling communication with camera sensors ? I assume the communication bus is 
> I2C ? Is that "camera control interface" plain I2C or does it have additional 
> features ?
> 
> If we're talking about an I2C controller a V4L2 subdev is not only unneeded, 
> but it wouldn't help. You need an I2C master.

Sorry if I wasn't quite right in description, the control interface is
indeed i2c master and gpio. The camera sensors are i2c slaves connected to
this i2c master and gpio for sensors are connected to this as well.

> > Second the control sports GPIOs. It can support  a set of
> > synchronization primitives so it's possible to drive I2C clients and
> > GPIOs with hardware controlled timing to allow for sync control of
> > sensors hooked and also for fancy strobe. How would we represent these
> > gpios in v4l2 and allow the control, any ideas on that.
> 
> Even if your main use case it related to camera, synchronization of I2C and 
> GPIO doesn't seem to be a V4L2 feature to me. It sounds that you need to 
> implement that int he I2C and GPIO subsystems.

Well if a user wants to capture multiple cameras and synchronise,
wouldn't that need sync of i2c and gpio. I understand it may not be
supported but the question is would it be a nice feature for v4l, if so
how to go about it?

Thanks
-- 
~Vinod
