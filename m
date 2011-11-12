Return-path: <linux-media-owner@vger.kernel.org>
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:60449 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab1KLLs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 06:48:56 -0500
From: Ian Armstrong <mail01@iarmst.co.uk>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Use of V4L2_FBUF_FLAG_OVERLAY
Date: Sat, 12 Nov 2011 11:27:52 +0000
Cc: Hans Verkuil <hverkuil@xs4all.nl>
References: <201111071424.17938.hverkuil@xs4all.nl>
In-Reply-To: <201111071424.17938.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111121127.52607.mail01@iarmst.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 07 November 2011, Hans Verkuil wrote:
> During the recent V4L-DVB workshop we discussed the usage of the
> V4L2_FBUF_FLAG_OVERLAY flag.
> 

> In the case of ivtv the behavior is as follows (from the original commit
> message):
> 
>     The existing yuv code limits output to the display area occupied by the
>     framebuffer. This patch allows the yuv output to be 'detached' via
>     V4L2_FBUF_FLAG_OVERLAY.
> 
>     By default, the yuv output window will be restricted to the framebuffer
>     dimensions and the output position is relative to the top left corner
>     of the framebuffer. This matches the behaviour of previous versions.
> 
>     If V4L2_FBUF_FLAG_OVERLAY is cleared, the yuv output will no longer be
>     linked to the framebuffer. The maximum dimensions are either 720x576 or
>     720x480 depending on the current broadcast standard, with the output
>     position relative to the top left corner of the display. The framebuffer
>     itself can be resized, moved and panned without affecting the yuv 
>     output.
> 
> So, the definition for FLAG_OVERLAY for output overlays would be:
> 
> 'If FLAG_OVERLAY is set, then the video output overlay window is relative
> to the top-left corner of the framebuffer and restricted to the size of
> the framebuffer. If it is cleared, then the video output overlay window is
> relative to the video output display.'
> 
> Ian, does this make sense?
 
Makes sense to me, but I understand how the hardware & driver works.

With the PVR350 there is no hardware restriction that limits yuv output to the 
framebuffer area. They are effectively two separate overlays that are shown on 
the video output display. The framebuffer does not have to occupy the entire 
display area, but can be reduced to cover just a small part. There are times 
when it may be beneficial to reduce the framebuffer size (faster redraws) 
without reducing yuv output (require full-screen video). Likewise, larger 
virtual resolution framebuffers also have their uses.

V4L2_FBUF_FLAG_OVERLAY was the closest thing to an existing flag that could 
toggle the mode of operation. With it set, things like XVideo work as 
expected, with the yuv window positioned correctly within the framebuffer 
area. When V4L2_FBUF_FLAG_OVERLAY is cleared, the framebuffer & yuv output 
detach to become two separate 'windows' on the display.

-- 
Ian
