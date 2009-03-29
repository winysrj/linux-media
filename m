Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:47591 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZC2KWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 06:22:01 -0400
Date: Sun, 29 Mar 2009 03:21:58 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: Check format for
 S_PARM and G_PARM
In-Reply-To: <200903291106.19466.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903290256360.28292@shell2.speakeasy.net>
References: <E1LnqiQ-00077f-80@mail.linuxtv.org> <200903291106.19466.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Mar 2009, Hans Verkuil wrote:
> On Sunday 29 March 2009 10:50:02 Patch from Trent Piepho wrote:
> > From: Trent Piepho  <xyzzy@speakeasy.org>
> > v4l2-ioctl:  Check format for S_PARM and G_PARM
> >
> >
> > Return EINVAL if VIDIOC_S/G_PARM is called for a buffer type that the
> > driver doesn't define a ->vidioc_try_fmt_XXX() method for.  Several other
> > ioctls, like QUERYBUF, QBUF, and DQBUF, etc.  do this too.  It saves each
> > driver from having to check if the buffer type is one that it supports.
>
> Hi Trent,
>
> I wonder whether this change is correct. Looking at the spec I see that
> g/s_parm only supports VIDEO_CAPTURE, VIDEO_OUTPUT and PRIVATE or up.
>
> So what should happen if the type is VIDEO_OVERLAY? I think the g/s_parm
> implementation in v4l2-ioctl.c should first exclude the unsupported types
> before calling check_fmt.

This change doesn't actually enable g/s_parm for VIDEO_OVERLAY (or
VBI_CAPTURE).  It's the later bttv and saa7146 changes that do that.  I
considered this when I made those changes, as mentioned in those patch
descriptions, but decided it was better to allow it.

In those drivers g_parm only returns the frame rate, which seems just as
valid for VIDEO_OVERLAY as it does for VIDEO_CAPTURE.  Why should the
driver not be allowed to return the frame rate for video overlay?  Why
should setting the overlay frame rate not be allowed?  Those seems like
perfectly reasonable operations to me.

The spec doesn't explicitly say that only VIDEO_CAPTURE, VIDEO_OUTPUT and
PRIVATE are supported.  It says the "capture" field of the parm union is
used when type is VIDEO_CAPTURE, the "output" field is used for
VIDEO_OUTPUT, and "raw_data" is used for PRIVATE or higher.  You're right
in that it doesn't say what you're supposed to use for VIDEO_OVERLAY,
VBI_CAPTURE or any other buffer types.  But it doesn't say they're not
allowed either.  IMHO, it's likely the spec authors' intent wasn't to not
allow g_parm with VIDEO_OVERLAY, but rather that they just didn't think of
that case.

Thinking about it now, I think what makes the most sense is to use
"capture" for VIDEO_OVERLAY, VBI_CAPTURE, and SLICED_VBI_CAPTURE.  And use
"output" for VBI_OUTPUT, SLICED_VBI_OUTPUT and VIDEO_OUTPUT_OVERLAY.

> I also wonder whether check_fmt shouldn't check for the presence of the
> s_fmt callbacks instead of try_fmt since try_fmt is an optional ioctl.

I noticed that too.  saa7146 doesn't have a try_fmt call for vbi_capture
but is apparently supposed to support it.  I sent a message about that
earlier.
