Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45200 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbaJZSgN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 14:36:13 -0400
Message-ID: <1414345274.6342.13.camel@palomino.walls.org>
Subject: Re: VBI on PVR-500 stopped working between kernels 3.6 and 3.13
From: Andy Walls <awalls@md.metrocast.net>
To: Christopher.Neufeld@cneufeld.ca
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Date: Sun, 26 Oct 2014 13:41:14 -0400
In-Reply-To: <201410261210.s9QCAQBD012612@cneufeld.ca>
References: <201410252315.s9PNF6eB002672@cneufeld.ca>
	 <544C8BAC.1070001@xs4all.nl> <201410261210.s9QCAQBD012612@cneufeld.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Sun, 2014-10-26 at 08:10 -0400, Christopher Neufeld wrote:
> Hello Hans,
> 
> On Sun, 26 Oct 2014 06:50:36 +0100, Hans Verkuil <hverkuil@xs4all.nl> said:
> 
> >> The script that I use to set up captions invokes this command:
> >> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc --set-ctrl=stream_vbi_format=1
> >> 
> >> This now errors out.  Part of that is a parsing bug in v4l2-ctl, it wants
> >> to see more text after the 'cc'.  I can change it to 
> >> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc=1 --set-ctrl=stream_vbi_format=1
> 
> > This is a v4l2-ctl bug. I'll fix that asap. But using cc=1 is a valid workaround.
> 
> >> 
> >> with this change, it no longer complains about the command line, but it
> >> errors out in the ioctls.  This behaviour is seen with three versions of
> >> v4l2-ctl: the old one packaged with the old kernel, the new one packaged
> >> with the newer kernel, and the git-head, compiled against the headers of
> >> the new kernel.

Can you verify that 

	v4l2-ctl -d <DEV> --get-fmt-sliced-vbi --get-ctrl=stream_vbi_format

also fails, and that

	v4l2-ctl --list-devices
	v4l2-ctl -d /dev/vbi<N> --set-fmt-sliced-vbi=cc=1 --set-ctrl=stream_vbi_format=1
	v4l2-ctl -d /dev/vbi<N> --get-fmt-sliced-vbi --get-ctrl=stream_vbi_format

both succeed on the corresponding vbi node?

Looking at the v3.16 kernel code that I'm compiling right now, it looks
like extra checks put in the v4l2-core don't allow setting sliced VBI
formats using video device nodes:

http://git.linuxtv.org/cgit.cgi/v4l-utils.git/tree/utils/v4l2-ctl/v4l2-ctl-vbi.cpp#n209
http://git.linuxtv.org/cgit.cgi/media_tree.git/tree/drivers/media/v4l2-core/v4l2-ioctl.c#n959
http://git.linuxtv.org/cgit.cgi/media_tree.git/tree/drivers/media/v4l2-core/v4l2-ioctl.c#n1192
http://git.linuxtv.org/cgit.cgi/media_tree.git/tree/drivers/media/v4l2-core/v4l2-ioctl.c#n1265

I have to actually install and test, but this is my current guess.

If you can use the /dev/vbiN node as a work-around, please do.

Regards,
Andy

> > Are you calling this when MythTV is already running? If nobody else is using
> > the PVR-500, does it work?
> 
> When my script is running, MythTV is not using that unit of the PVR-500.  I
> use the "recording groups" feature to ensure that that unit is made
> unavailable for recordings whenever high-definition recordings are being
> made.  The details of what I'm doing can be found here:
> https://www.mythtv.org/wiki/Captions_With_HD_PVR
> 
> I would not expect this command to succeed if the unit were in use, in fact
> the script detects that as an error case and loops until the device is
> free.  The v4l2-ctl command that I use has historically returned an error
> if somebody had the unit's video device open for reading.  Now, though, it
> errors even when the unit is unused.
> 
> For my script, it is necessary that the MythTV backend be running, the
> script is invoked by the backend, but when it is invoked, nobody is using
> that unit of the PVR-500 (and, in practice, the other unit is almost never
> used, as it's quite rare that I make standard-definition recordings).
> 
> My script is not used when MythTV directly makes a standard-definition
> recording from the PVR-500.  In that case, the program presumably issues
> its own ioctl equivalents of the v4l2-ctl command, and those are not
> working, because the recordings produced do not have VBI data, while those
> recorded before the kernel upgrade do.
> 
> > I won't be able to test this myself until next weekend at the earliest.
> 
> Captions are mostly for my wife's benefit, and I checked, most of her
> upcoming shows are being recorded from OTA broadcasts, which provide ATSC
> captions independently of the PVR-500, so I can wait for a week or two.
> 
> 
> Thank you for looking into this.
> 


