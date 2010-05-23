Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1287 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab0EWLSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 07:18:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ian Armstrong <mail01@iarmst.co.uk>
Subject: Re: VIDIOC_G_STD, VIDIOC_S_STD, VIDIO_C_ENUMSTD for outputs
Date: Sun, 23 May 2010 13:20:13 +0200
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Andre Draszik <v4l2@andred.net>
References: <AANLkTineD8GCtG1OD4WQahW7zS23IxQDx7XmnAsrVSqs@mail.gmail.com> <1274542506.2255.55.camel@localhost> <201005221821.32711.mail01@iarmst.co.uk>
In-Reply-To: <201005221821.32711.mail01@iarmst.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231320.13560.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 22 May 2010 19:21:32 Ian Armstrong wrote:
> On Saturday 22 May 2010, Andy Walls wrote:
> > On Sat, 2010-05-22 at 15:06 +0100, Andre Draszik wrote:
> > > Hi,
> > > 
> > > As per the spec, the above ioctl codes are defined for inputs only -
> > > it would be useful if there were similar codes for outputs.
> > > 
> > > I therefore propose to add the following:
> > > 
> > > VIDIOC_G_OUTPUT_STD
> > > VIDIOC_S_OUTPUT_STD
> > > VIDIOC_ENUM_OUTPUT_STD
> > > 
> > > which would behave similar to the above, but for output devices.
> > > 
> > > Thoughts?
> > 
> > Currently the ivtv driver, for the PVR-350's output, uses VIDIOC_S_STD.
> > 
> > >From what I see:
> > ivtv/ioctl.c
> > zoran/zoran_driver.c
> > davinci/vpif_display.c
> > 
> > all use VIDIOC_S_STD for setting the output standard.
> > 
> > Note that the v4l2_subdev video_ops have a "s_std_output" method which
> > is what you can grep for in the code to verify for yourself.
> > 
> > 
> > Some thoughts:
> > 
> > 1. to me it appears that the ivtv driver looks like it ties the output
> > standard to the input standard currently (probably due to some firmware
> > limitation).  This need not be the case in general.
> 
> The ivtv limitation is the driver and not the firmware.

Correct.

> The firmware itself 
> seems quite happy with mixed standards & in some cases will automatically 
> switch the output standard itself (resulting in a standards mismatch between 
> the cx23415 & saa7127, breaking output). For the previous 2 months I've been 
> running a patched version of the ivtv driver that separates the input & output 
> format with no noticeable issues.
> 
> > 2. currently the ivtv driver uses sepearte device nodes for input device
> > and an output device.  If bridge drivers maintain that paradigm, then
> > separate ioctl()s for S_STD, G_STD, and ENUMSTD are likely not needed.
> 
> This is how my patched version works, talk to an input device for the input & 
> an output device for the output. However, from my reading of the specs I do 
> get the impression this is not the 'correct' way to do this and it should 
> really be a separate ioctl. I don't know what other cards, if any, support 
> mixed input & output standards or how they handle it.

I have considered implementing these output ioctls as well and as mentioned
s_std_output is actually implemented on the subdev level (it was really needed
there).

The reason it was never done for bridge drivers is twofold:

1) No one ever needed it. Why would you want to select one format for input
and another for output? Other than debugging this never happens for the sort
of drivers we have now. So selecting e.g. PAL and have it change both input
and output is actually what most people expect.

2) Do we really need to make new ioctls? Here it becomes hairy. According to
the V4L2 spec changing the std for one video device should change it for all
others as well. So if we follow that spec, then we should indeed introduce
new ioctls. But in practice all driver have separate device nodes for capture
and output. So perhaps we should change the spec and specify that it will
only change the std for those device nodes that are linked to the same input
or output.

This bring me to another related issue with the spec: strictly speaking the
spec allows you to capture VBI data from /dev/videoX or video data from
/dev/vbiX. But very few if any drivers actually support this. I personally
think this requirement makes no sense and should be dropped.

Anyway, the bottom line is that I would prefer to bring the spec in line
with what happens in practice. Then there is no need to add new ioctls.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
