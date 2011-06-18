Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1FRTL7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 15:11:59 -0400
Received: by iyb12 with SMTP id 12so1008472iyb.19
        for <linux-media@vger.kernel.org>; Sat, 18 Jun 2011 12:11:58 -0700 (PDT)
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Sat, 18 Jun 2011 19:11:37 +0000
Message-ID: <BANLkTikb1Row7_+-e30udc9e5KBjuwcaJg@mail.gmail.com>
Subject: V4L2_PIX_FMT_MPEG and S_FMT
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I am still in the process of porting a driver to v4l2 framework. This
device is capable of decoding MPEG-1 and MPEG-2 streams.
See http://dxr3.sourceforge.net/about.html for more details.
So I have programmed this:

static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
				struct v4l2_fmtdesc *fmt)
{
	if (fmt->index > 0)
		return -EINVAL;

	fmt->flags = V4L2_FMT_FLAG_COMPRESSED;
	fmt->pixelformat = V4L2_PIX_FMT_MPEG;
	strlcpy(fmt->description, "MPEG 1/2", sizeof(fmt->description));

	return 0;
}

There is nothing in struct v4l2_format which indicates MPEG1, MPEG2 or
MPEG4. As a result
of this, it is not possible to return -EINVAL if somebody wants to
decode/playback MPEG4 content.

Any ideas how to achieve it?

Thanks
--
Christian Gmeiner, MSc
