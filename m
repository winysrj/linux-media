Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2215 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab2IUKHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 06:07:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: s5p-tv/mixer_video.c weirdness
Date: Fri, 21 Sep 2012 12:07:46 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211207.46679.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek, Sylwester,

I've been investigating how multiplanar is used in various drivers, and I
came across this driver that is a bit weird.

querycap sets both single and multiple planar output caps:

        cap->capabilities = V4L2_CAP_STREAMING |
                V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE;

This suggests that both the single and multiplanar APIs are supported.

But mxr_ioctl_ops only implements these:

        /* format handling */
        .vidioc_enum_fmt_vid_out = mxr_enum_fmt,
        .vidioc_s_fmt_vid_out_mplane = mxr_s_fmt,
        .vidioc_g_fmt_vid_out_mplane = mxr_g_fmt,

Mixing single planar enum_fmt with multiplanar s/g_fmt makes little sense.

I suspect everything should be multiplanar.

BTW, I recommend running v4l2-compliance over your s5p drivers. I saw several
things it would fail on.

Regards,

	Hans
