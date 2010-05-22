Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:30182 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742Ab0EVPfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 11:35:05 -0400
Subject: Re: VIDIOC_G_STD, VIDIOC_S_STD, VIDIO_C_ENUMSTD for outputs
From: Andy Walls <awalls@md.metrocast.net>
To: Andre Draszik <v4l2@andred.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTineD8GCtG1OD4WQahW7zS23IxQDx7XmnAsrVSqs@mail.gmail.com>
References: <AANLkTineD8GCtG1OD4WQahW7zS23IxQDx7XmnAsrVSqs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 May 2010 11:35:06 -0400
Message-ID: <1274542506.2255.55.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-05-22 at 15:06 +0100, Andre Draszik wrote:
> Hi,
> 
> As per the spec, the above ioctl codes are defined for inputs only -
> it would be useful if there were similar codes for outputs.
> 
> I therefore propose to add the following:
> 
> VIDIOC_G_OUTPUT_STD
> VIDIOC_S_OUTPUT_STD
> VIDIOC_ENUM_OUTPUT_STD
> 
> which would behave similar to the above, but for output devices.
> 
> Thoughts?

Currently the ivtv driver, for the PVR-350's output, uses VIDIOC_S_STD.

>From what I see:

ivtv/ioctl.c
zoran/zoran_driver.c
davinci/vpif_display.c

all use VIDIOC_S_STD for setting the output standard.

Note that the v4l2_subdev video_ops have a "s_std_output" method which
is what you can grep for in the code to verify for yourself.


Some thoughts:

1. to me it appears that the ivtv driver looks like it ties the output
standard to the input standard currently (probably due to some firmware
limitation).  This need not be the case in general.

2. currently the ivtv driver uses sepearte device nodes for input device
and an output device.  If bridge drivers maintain that paradigm, then
separate ioctl()s for S_STD, G_STD, and ENUMSTD are likely not needed.

3. ENUMSTD is currently handled by the v4l2 core in v4l2-ioctl.c with no
hook for bridge drivers.  The bridge drivers were all getting it wrong
in some way or another for enumerating stanadrds on the input.

4. What's the harm in letting S_STD fail for an unsupported standard on
an output?  An application usually doesn't have much choice but to fail,
if the hardware doesn't support the user's desired standard.
ENUMSTD_OUTPUT for outputs seems superfulous.  If you had an
ENUM_STD_OUTPUT ioctl() to call, an application will either find the
desired standard in the list and know S_STD should succeed, or it won't
an will assume S_STD will fail.  From an application writing
perspective, it seems like less work for the application to just detect
when S_STD fails.


Regards,
Andy

