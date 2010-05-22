Return-path: <linux-media-owner@vger.kernel.org>
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:46324 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775Ab0EVRVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 13:21:34 -0400
Received: from iarmst.demon.co.uk ([62.49.16.35] helo=spike.localnet)
	by lon1-post-2.mail.demon.net with esmtp (Exim 4.69)
	id 1OFsOD-0001jg-bR
	for linux-media@vger.kernel.org; Sat, 22 May 2010 17:21:33 +0000
From: Ian Armstrong <mail01@iarmst.co.uk>
To: linux-media@vger.kernel.org
Subject: Re: VIDIOC_G_STD, VIDIOC_S_STD, VIDIO_C_ENUMSTD for outputs
Date: Sat, 22 May 2010 18:21:32 +0100
References: <AANLkTineD8GCtG1OD4WQahW7zS23IxQDx7XmnAsrVSqs@mail.gmail.com> <1274542506.2255.55.camel@localhost>
In-Reply-To: <1274542506.2255.55.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005221821.32711.mail01@iarmst.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 22 May 2010, Andy Walls wrote:
> On Sat, 2010-05-22 at 15:06 +0100, Andre Draszik wrote:
> > Hi,
> > 
> > As per the spec, the above ioctl codes are defined for inputs only -
> > it would be useful if there were similar codes for outputs.
> > 
> > I therefore propose to add the following:
> > 
> > VIDIOC_G_OUTPUT_STD
> > VIDIOC_S_OUTPUT_STD
> > VIDIOC_ENUM_OUTPUT_STD
> > 
> > which would behave similar to the above, but for output devices.
> > 
> > Thoughts?
> 
> Currently the ivtv driver, for the PVR-350's output, uses VIDIOC_S_STD.
> 
> >From what I see:
> ivtv/ioctl.c
> zoran/zoran_driver.c
> davinci/vpif_display.c
> 
> all use VIDIOC_S_STD for setting the output standard.
> 
> Note that the v4l2_subdev video_ops have a "s_std_output" method which
> is what you can grep for in the code to verify for yourself.
> 
> 
> Some thoughts:
> 
> 1. to me it appears that the ivtv driver looks like it ties the output
> standard to the input standard currently (probably due to some firmware
> limitation).  This need not be the case in general.

The ivtv limitation is the driver and not the firmware. The firmware itself 
seems quite happy with mixed standards & in some cases will automatically 
switch the output standard itself (resulting in a standards mismatch between 
the cx23415 & saa7127, breaking output). For the previous 2 months I've been 
running a patched version of the ivtv driver that separates the input & output 
format with no noticeable issues.

> 2. currently the ivtv driver uses sepearte device nodes for input device
> and an output device.  If bridge drivers maintain that paradigm, then
> separate ioctl()s for S_STD, G_STD, and ENUMSTD are likely not needed.

This is how my patched version works, talk to an input device for the input & 
an output device for the output. However, from my reading of the specs I do 
get the impression this is not the 'correct' way to do this and it should 
really be a separate ioctl. I don't know what other cards, if any, support 
mixed input & output standards or how they handle it.

-- 
Ian
