Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1437 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2IJPPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:15:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC API] Capture Overlay API ambiguities
Date: Mon, 10 Sep 2012 17:14:54 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101714.54365.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

While working on making bttv compliant with the V4L2 API I managed to resolve
all v4l2-compliance errors except for two:

                fail: v4l2-test-formats.cpp(339): !fmt.width || !fmt.height
        test VIDIOC_G_FBUF: FAIL
                fail: v4l2-test-formats.cpp(607): Video Overlay is valid, but no S_FMT was implemented
        test VIDIOC_S_FMT: FAIL

After some analysis it turns out to be an ambiguity in VIDIOC_G_FBUF and
VIDIOC_G_FMT for overlays.

The first relates to what VIDIOC_G_FBUF should return if there is no framebuffer
set? I.e. if VIDIOC_S_FBUF was never called?

Should G_FBUF return an error, or provide non-zero but dummy struct v4l2_pix_format
values and only leave base to NULL, or should the whole v4l2_framebuffer structure
be zeroed (except for the capability field)?

bttv just zeroes everything.

Currently v4l2-compliance assumes that there is at least a dummy fmt setup. But
I think that is unreasonably for destructive capture overlays.

I would prefer to zero everything except for the capability field.

Returning an error is not an option IMHO: even if there is no framebuffer defined,
the capability field is still useful information to have.

The second error is related to the first: what should happen if you try to set
a capture overlay format with S_FMT and no framebuffer is defined? The driver
cannot really validate the given format without knowing what the framebuffer
is like.

Currently I am returning some dummy values for G_FMT and TRY_FMT in that case,
but for S_FMT I cannot do even that.

While normally the G/S/TRY_FMT ioctls should never return an error, I think
that in this particular case we should allow an error code. I am proposing
ENODATA because, well, there is no data w.r.t. the framebuffer.

The current bttv driver returns EINVAL for these cases, but that's too generic
I think.

So in the case of destructive capture overlays the G/S/TRY_FMT ioctls should
return ENODATA if no framebuffer was configured.

Comments?

Regards,

	Hans
