Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2992 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0FZSti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 14:49:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Correct way to do s_ctrl ioctl taking into account subdev framework?
Date: Sat, 26 Jun 2010 20:51:52 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com>
In-Reply-To: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006262051.52754.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Saturday 26 June 2010 20:37:51 Devin Heitmueller wrote:
> First, a bit of background:
> 
> A bug in the em28xx implementation of s_ctrl() was present where it
> would always return 1, even in success cases, regardless of what the
> subdev servicing the request said (in this case the video decoder).
> It was using v4l2_device_call_all(), and disregarding the return value
> from any of the subdevs.
> 
> This prompted me to change the code so that it started using
> v4l2_device_call_until_err(), figuring that subdevs that did not
> support it would simply return -ENOIOCTLCMD.  However, as Mauro
> correctly pointed out, subdevs that do implement s_ctrl, but not the
> desired control will return -EINVAL, which would cause the bridge to
> stop sending the command to other subdevs and return an error.
> 
> I looked at various other bridges, and don't see any consistent
> approach for this case.  Some of the bridges always return zero
> (regardless of what happened during the call).  Some of them look at
> the content of the resulting struct for some value that suggests it
> was changed.  Others feed the call to different classes of subdevice
> depending on what the actual control being set was.
> 
> So what's the "right" approach?  I'm willing to conform to whatever
> the recommendation is here, since it will obviously be an improvement
> over always returning 1 (even always returning zero would be better
> since at least applications wouldn't treat it as a failure).
> 
> Hans?

The correct approach is to wait until the control framework is merged. This
depends on Laurent implementing it first in UVC so we can be sure that the
framework can handle the special UVC requirements.

There really is no good way at the moment to handle cases like this, or at
least not without a lot of work.

The plan is to have the framework merged in time for 2.6.36. My last patch
series for the framework already converts a bunch of subdevs to use it. Your
best bet is to take the patch series and convert any remaining subdevs used
by em28xx and em28xx itself. I'd be happy to add those patches to my patch
series, so that when I get the go ahead the em28xx driver will be fixed
automatically.

It would be useful for me anyway to have someone else use it: it's a good
check whether my documentation is complete.

I don't see any point in attempting to fix this in another way, it's just
plain broken at the moment.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
