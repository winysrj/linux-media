Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56671 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1H3OTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 10:19:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: Getting started with OMAP3 ISP
Date: Tue, 30 Aug 2011 16:20:09 +0200
Cc: linux-media@vger.kernel.org
References: <4E56734A.3080001@mlbassoc.com> <4E5CEECC.6040804@mlbassoc.com> <4E5CF118.3050903@mlbassoc.com>
In-Reply-To: <4E5CF118.3050903@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301620.09365.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Tuesday 30 August 2011 16:18:00 Gary Thomas wrote:
> On 2011-08-30 08:08, Gary Thomas wrote:
> > On 2011-08-29 04:49, Laurent Pinchart wrote:
> >> On Thursday 25 August 2011 18:07:38 Gary Thomas wrote:
> >>> Background: I have working video capture drivers based on the
> >>> TI PSP codebase from 2.6.32. In particular, I managed to get
> >>> a driver for the TVP5150 (analogue BT656) working with that kernel.
> >>> 
> >>> Now I need to update to Linux 3.0, so I'm trying to get a driver
> >>> working with the rewritten ISP code. Sadly, I'm having a hard
> >>> time with this - probably just missing something basic.
> >>> 
> >>> I've tried to clone the TVP514x driver which says that it works
> >>> with the OMAP3 ISP code. I've updated it to use my decoder device,
> >>> but I can't even seem to get into that code from user land.
> >>> 
> >>> Here are the problems I've had so far:
> >>> * udev doesn't create any video devices although they have been
> >>> registered. I see a full set in /sys/class/video4linux
> >>> # ls /sys/class/video4linux/
> >>> v4l-subdev0 v4l-subdev3 v4l-subdev6 video1 video4
> >>> v4l-subdev1 v4l-subdev4 v4l-subdev7 video2 video5
> >>> v4l-subdev2 v4l-subdev5 video0 video3 video6
> >> 
> >> It looks like a udev issue. I don't think that's related to the kernel
> >> drivers.
> >> 
> >>> Indeed, if I create /dev/videoX by hand, I can get somewhere, but
> >>> I don't really understand how this is supposed to work. e.g.
> >>> # v4l2-dbg --info /dev/video3
> >>> Driver info:
> >>> Driver name : ispvideo
> >>> Card type : OMAP3 ISP CCP2 input
> >>> Bus info : media
> >>> Driver version: 1
> >>> Capabilities : 0x04000002
> >>> Video Output
> >>> Streaming
> >>> 
> >>> * If I try to grab video, the ISP layer gets a ton of warnings, but
> >>> I never see it call down into my driver, e.g. to check the current
> >>> format, etc. I have some of my own code from before which fails
> >>> miserably (not a big surprise given the hack level of those programs).
> >>> I tried something off-the-shelf which also fails pretty bad:
> >>> # ffmpeg -t 10 -f video4linux2 -s 720x480 -r 30 -i /dev/video2
> >>> junk.mp4
> >>> 
> >>> I've read through Documentation/video4linux/omap3isp.txt without
> >>> learning much about what might be wrong.
> >>> 
> >>> Can someone give me some ideas/guidance, please?
> >> 
> >> In a nutshell, you will first have to configure the OMAP3 ISP pipeline,
> >> and then capture video.
> >> 
> >> Configuring the pipeline is done through the media controller API and
> >> the V4L2 subdev pad-level API. To experiment with those you can use the
> >> media-ctl command line application available at
> >> http://git.ideasonboard.org/?p=media- ctl.git;a=summary. You can run it
> >> with --print-dot and pipe the result to dot -Tps to get a postscript
> >> graphical view of your device.
> >> 
> >> Here's a sample pipeline configuration to capture scaled-down YUV data
> >> from a sensor:
> >> 
> >> ./media-ctl -r -l '"mt9t001 3-005d":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> >> CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP
> >> resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
> >> ./media-ctl -f '"mt9t001 3-005d":0[SGRBG10 1024x768], "OMAP3 ISP
> >> CCDC":2[SGRBG10 1024x767], "OMAP3 ISP preview":1[YUYV 1006x759], "OMAP3
> >> ISP resizer":1[YUYV 800x600]'
> >> 
> >> After configuring your pipeline you will be able to capture video using
> >> the V4L2 API on the device node at the output of the pipeline.
> > 
> > Thanks for the info.
> > 
> > When I run 'media-ctl -p', I see the various nodes, etc, and they all
> > look good except that I get lots of messages like this:
> > - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
> > type V4L2 subdev subtype Unknown
> > pad0: Input v4l2_subdev_open: Failed to open subdev device node
> 
> Could this be related to my missing [udev] device nodes?

It could be. You need the /dev/video* and /dev/v4l-subdev* device nodes.

> I can see media-ctl get confused and try to open a nonsense device name. 
> Here's what I see when I run
>    # strace media-ctl -p | grep open
>    open("/dev/media0", O_RDWR)             = 3
>    open("", O_RDWR)                        = -1 ENOENT (No such file or
> directory) write(1, "\tpad0: Input v4l2_subdev_open: F"..., 66) = 66
> 
> > When I try to setup my pipeline using something similar to what you
> > provided, the first step runs and I can see that it does something (some
> > lines on the graph went from dotted to solid), but I still get errors:
> > # media-ctl -r -l '"tvp5150m1 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> > ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]' Resetting all links to
> > inactive
> > Setting up link 16:0 -> 5:0 [1]
> > Setting up link 5:1 -> 6:0 [1]
> > # media-ctl -f '"tvp5150m1 2-005c":0[SGRBG12 320x240], "OMAP3 ISP
> > CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]' Setting up
> > format SGRBG12 320x240 on pad tvp5150m1 2-005c/0
> > v4l2_subdev_open: Failed to open subdev device node
> > Unable to set format: No such file or directory (-2)
> > 
> > As far as I can tell, none if this is making any callbacks into my
> > driver.
> > 
> > Any ideas what I might be missing?
> > 
> > Thanks

-- 
Regards,

Laurent Pinchart
