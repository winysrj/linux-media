Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1923 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1KGNY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 08:24:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: Use of V4L2_FBUF_FLAG_OVERLAY
Date: Mon, 7 Nov 2011 14:24:17 +0100
MIME-Version: 1.0
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ian Armstrong <mail01@iarmst.co.uk>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111071424.17938.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the recent V4L-DVB workshop we discussed the usage of the
V4L2_FBUF_FLAG_OVERLAY flag.

There are currently two drivers that use it: bttv uses it for the capture
overlay, and ivtv uses it for the output overlay (OSD).

In the case of bttv the behavior seems to be as follows:

If this flag is set by VIDIOC_S_FBUF, then the internal data structures are
setup so that the captured video covers the full framebuffer.

If this flag is cleared, then the current overlay geometry is kept. If you
want to update that, then you have to call S_FMT.

I am not really sure how to express this in the spec. The best I can come
up with is this:

'If FLAG_OVERLAY is set, then the video capture overlay is initially scaled
to cover the full framebuffer area. Otherwise the old S_FMT values are used.'

The problem with this is that it doesn't add any useful functionality, and
that the other drivers that implement capture overlay do not support it.

Even if the application sets this flag, then it won't know whether it was
effective. If we want to fully support this flag, then those other drivers
either need to clear it (thus telling the application that this flag wasn't
supported), or actually implement this functionality. Just clearing the
flag is of course the easiest course of action.

Mauro, does this make sense? What is your opinion?


In the case of ivtv the behavior is as follows (from the original commit
message):

    The existing yuv code limits output to the display area occupied by the
    framebuffer. This patch allows the yuv output to be 'detached' via
    V4L2_FBUF_FLAG_OVERLAY.
    
    By default, the yuv output window will be restricted to the framebuffer
    dimensions and the output position is relative to the top left corner of the
    framebuffer. This matches the behaviour of previous versions.
    
    If V4L2_FBUF_FLAG_OVERLAY is cleared, the yuv output will no longer be linked
    to the framebuffer. The maximum dimensions are either 720x576 or 720x480
    depending on the current broadcast standard, with the output position
    relative to the top left corner of the display. The framebuffer itself can be
    resized, moved and panned without affecting the yuv output.

So, the definition for FLAG_OVERLAY for output overlays would be:

'If FLAG_OVERLAY is set, then the video output overlay window is relative to
the top-left corner of the framebuffer and restricted to the size of the
framebuffer. If it is cleared, then the video output overlay window is relative
to the video output display.'

Ian, does this make sense?

Does anyone else have any comments regarding this flag?

	Hans
