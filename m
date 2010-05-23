Return-path: <linux-media-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:48312 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755082Ab0EWSda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 14:33:30 -0400
From: Ian Armstrong <mail01@iarmst.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: VIDIOC_G_STD, VIDIOC_S_STD, VIDIO_C_ENUMSTD for outputs
Date: Sun, 23 May 2010 19:33:27 +0100
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Andre Draszik <v4l2@andred.net>
References: <AANLkTineD8GCtG1OD4WQahW7zS23IxQDx7XmnAsrVSqs@mail.gmail.com> <201005221821.32711.mail01@iarmst.co.uk> <201005231320.13560.hverkuil@xs4all.nl>
In-Reply-To: <201005231320.13560.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231933.27307.mail01@iarmst.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 23 May 2010, Hans Verkuil wrote:
> On Saturday 22 May 2010 19:21:32 Ian Armstrong wrote:
> > On Saturday 22 May 2010, Andy Walls wrote:

> > > Some thoughts:
> > > 
> > > 1. to me it appears that the ivtv driver looks like it ties the output
> > > standard to the input standard currently (probably due to some firmware
> > > limitation).  This need not be the case in general.
> > 
> > The ivtv limitation is the driver and not the firmware.
> 
> Correct.
> 
> > The firmware itself
> > seems quite happy with mixed standards & in some cases will automatically
> > switch the output standard itself (resulting in a standards mismatch
> > between the cx23415 & saa7127, breaking output). For the previous 2
> > months I've been running a patched version of the ivtv driver that
> > separates the input & output format with no noticeable issues.
> > 
> > > 2. currently the ivtv driver uses sepearte device nodes for input
> > > device and an output device.  If bridge drivers maintain that
> > > paradigm, then separate ioctl()s for S_STD, G_STD, and ENUMSTD are
> > > likely not needed.
> > 
> > This is how my patched version works, talk to an input device for the
> > input & an output device for the output. However, from my reading of the
> > specs I do get the impression this is not the 'correct' way to do this
> > and it should really be a separate ioctl. I don't know what other cards,
> > if any, support mixed input & output standards or how they handle it.
> 
> I have considered implementing these output ioctls as well and as mentioned
> s_std_output is actually implemented on the subdev level (it was really
> needed there).
> 
> The reason it was never done for bridge drivers is twofold:
> 
> 1) No one ever needed it. Why would you want to select one format for input
> and another for output? Other than debugging this never happens for the
> sort of drivers we have now. So selecting e.g. PAL and have it change both
> input and output is actually what most people expect.

There's no denying that mixed standards is unusual, but is it a case of nobody 
ever wanted it, or did they just assume the hardware wasn't capable of it. The 
only reason I ever created a patch to support mixed standards in the ivtv 
driver is because it was a feature which I wanted to use.

In my case all captures are PAL, but I view a lot of NTSC material. I find 
that interlaced video looks best when displayed in its native format so I use 
a script to identify & change the output to match. Mixed standards allow 
MythTV to record a show in PAL while I'm watching an NTSC video on an NTSC  
output.

Another instance when mixed formats would be useful is when capturing a video 
which doesn't match your regions standard. If I'm trying to capture an NTSC 
video, it doesn't mean I want the output mode changed from my native PAL. Just 
because the card can output NTSC doesn't mean the display can handle it.

> 2) Do we really need to make new ioctls? Here it becomes hairy. According
> to the V4L2 spec changing the std for one video device should change it
> for all others as well. So if we follow that spec, then we should indeed
> introduce new ioctls. But in practice all driver have separate device
> nodes for capture and output. So perhaps we should change the spec and
> specify that it will only change the std for those device nodes that are
> linked to the same input or output.

I doubt it's really used outside of v4l2-ctl, but the ivtv driver allows 
output configuration to be changed via the capture device. In this instance a 
new ioctl would avoid a situation where the output can only be partially 
configured through the capture device. In reality I doubt any application 
actually configures the output via the capture device, but to reuse the ioctl 
& link it to a specific device node would create an inconsistency.

-- 
Ian
