Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54375 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3GPM6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 08:58:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: implement ov3640 driver using subdev-api with omap3-isp
Date: Tue, 16 Jul 2013 14:59:36 +0200
Message-ID: <3305303.jznjHFUBkl@avalon>
In-Reply-To: <loom.20130715T104602-373@post.gmane.org>
References: <loom.20130715T104602-373@post.gmane.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On Monday 15 July 2013 09:23:19 Tom wrote:
> Hello,
> 
> I am working with a gumstix overo board connected with a e-con-systems
> camera module using a ov3640 camera sensor.
> 
> Along with the board I got a camera driver
> (https://github.com/scottellis/econ-cam-driver)
> which can be used with linux
> kernel 2.6.34, but I want to use the camera
> along with the linux kernel 3.5.
> 
> So I tried to implement the driver into the kernel sources by referring to a
> existing drivers like /driver/media/video/ov9640.c and
> /driver/media/video/mt9v032.c.
> 
> The old driver has an isp implementation integrated and it registers itself
> once as a video device. So the application which is going to use the camera
> sensor just needs to open the right video device and by calling ioctl the
> corresponding functions will be called.
> 
> By going through the linux 3.5 kernel sources I found out that the omap3-isp
> registers itself as an video-device and should support sensors using the
> v4l2-subdev interface.
> 
> So am I right when I think that I just need to add the ov3640 subdev to the
> isp_v4l2_subdevs_group in the board-overo.c file and then just open the
> video device of the isp to use it via application (ioctl)?
> 
> I read an article which told me that I need to use the v4l2_subdev_pad_ops
> to interact from isp with the ov3640 subdev, but it does not work. I don't
> know what I am doing wrong.
> 
> Is there already an implemenation of the ov3640 using subdev-api which I
> couldn't find or can someone give me a hint what I need to do to get the
> sensor with the isp working?

As a matter of fact there's one. You can't be blamed for not finding it, as it 
was stored on my computer.

I've rebased the patches on top of the latest linuxtv master branch and pushed 
the patches to

	git://linuxtv.org/pinchartl/media.git sensors/ov3640

Two caveats:

- The rebased patches have been compile-tested only, I haven't had time to 
test them on the hardware. One particular point that might break is the use of 
the clock API as a replacement for the OMAP3 ISP .set_xclk() callback. Any 
problem that may arise from this shouldn't be too difficult to fix.

- The driver doesn't work in all resolutions and formats. This is really work 
in progress that I haven't had time to finish. The code should be relatively 
clean, but the lack of support from Omnivision killed the schedule (which I've 
planned too optimistically I have to confess).

Fixes would be very welcome. I'd like to push this driver to mainline at some 
point, I'd hate to waste the time I've spent on this.

-- 
Regards,

Laurent Pinchart

