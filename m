Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4115 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0EIIan (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 04:30:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Confusing mediabus formats
Date: Sun, 9 May 2010 10:32:07 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005091032.07893.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I'm preparing a patch series that replaces enum/g/try/s_fmt with
enum/g/try/s/_mbus_fmt in all subdevs. While doing that I stumbled on a
confusing definition of the YUV mediabus formats. Currently we have these:

        V4L2_MBUS_FMT_YUYV8_2X8_LE,
        V4L2_MBUS_FMT_YVYU8_2X8_LE,
        V4L2_MBUS_FMT_YUYV8_2X8_BE,
        V4L2_MBUS_FMT_YVYU8_2X8_BE,

The meaning of "2X8" is defined as: 'one pixel is transferred in
two 8-bit samples'.

This is confusing since you cannot really say that a Y and U pair constitutes
one pixel. And is it Y or U/V which constitutes the 'most-significant bits' in
such a 16-bit number?

In my particular case I have to translate a V4L2_PIX_FMT_UYVY to a suitable
mediabus format. I think it would map to V4L2_MBUS_FMT_YUYV8_2X8_LE, but
frankly I'm not sure.

My suggestion is to rename these mediabus formats to:

        V4L2_MBUS_FMT_YUYV8_1X8,
        V4L2_MBUS_FMT_YVYU8_1X8,
        V4L2_MBUS_FMT_UYVY8_1X8,
        V4L2_MBUS_FMT_VYUY8_1X8,

Here it is immediately clear what is going on. This scheme is also used with
the Bayer formats, so it would be consistent with that as well.

However, does V4L2_MBUS_FMT_YUYV8_2X8_LE map to V4L2_MBUS_FMT_YUYV8_1X8 or to
V4L2_MBUS_FMT_UYVY8_1X8? I still don't know.

What do you think?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
