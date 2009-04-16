Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48466 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757057AbZDPT6n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 15:58:43 -0400
Date: Thu, 16 Apr 2009 21:58:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	kernel@pengutronix.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	dongsoo45.kim@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>
Subject: Re: [RFC] Making Samsung S3C64XX camera interface driver in SoC
 camera  subsystem
In-Reply-To: <5e9665e10904151712o5fa3076dr85ad12fc7f04914d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904162147370.4947@axis700.grange>
References: <5e9665e10904151712o5fa3076dr85ad12fc7f04914d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> Hello,
> 
> I'm planing to make a new camera interface driver for S3C64XX from Samsung.
> Even if it already has a driver, it seems to be re-designed for some
> reasons. If you are interested in, take a look at following repository
> (http://git.kernel.org/?p=linux/kernel/git/eyryu_ap/samsung-ap-2.6.24.git;a=summary)
> drivers/media/video/s3c_* files
> 
> Before beginning to implement a new driver for that, I need to clarify
> some of features about how to implement in driver.
> 
> Please take a look at the diagram on page 610 of following user manual
> of s3c6400.
> http://www.ebv.com/fileadmin/products/Products/Samsung/S3C6400/S3C6400X_UserManual_rev1-0_2008-02_661558um.pdf
> 
> It seems to have a couple of path for camera data named codec and
> preview, and they could be used at the same time.
> It means that it has no problem making those two paths into
> independent device nodes like /dev/video0 and /dev/video1
> 
> But there is a limit of size using both of paths at the same time. I
> mean, If you are using preview path and camera sensor is running with
> 1280*720 resolution (which seems to be the max resolution could be
> handled by preview path), codec path can't use resolution bigger than
> 1280*720 at the same time because camera sensor can't produce
> different resolution at a time.
> 
> And also we should face a big problem when we are making dual camera
> system with s3c64xx. Dual camera with single camera interface has some
> restriction using clock and data path, because they have to be shared
> between both of cameras.
> I suppose to handle them with VIDIOC_S_INPUT and G_INPUT. And with
> those, we can handle dual camera with single camera interface in a
> decent way.
> 
> But the thing is that there should be a problem using dual camera with
> preview and codec path of s3c64xx. Even if we have each preview, and
> codec device node and can't open them concurrently when user is
> attempting to open each camera sensor like "camera A with preview node
> and camera B with codec node". Because both of those camera sensors
> are sharing same data path and clock source, and s3c64xx camera
> interface only can handle one camera at a time.
> 
> So, what I am concerned is how to make it a elegant driver which has
> two device nodes handling multiple sensors as input devices.
> Sounds complicated but I'm asking you to help me with any opinion
> about designing this driver. Any opinion about these issues will be
> greatly helpful to me.

Ok, now I understand your comments to my soc-camera thread better. Now, 
what about making one (or more) video devices with V4L2_CAP_VIDEO_CAPTURE 
type and one with V4L2_CAP_VIDEO_OUTPUT? Then you can use your capture 
type devices to switch between cameras and to configure input, and your 
output device to configure preview? Then you can use soc-camera to control 
your capture devices (if you want to of course) and implement an output 
device directly. It should be a much simpler device, because it will not 
be communicating with the cameras and only modify various preview 
parameters.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
