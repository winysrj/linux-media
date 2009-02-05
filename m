Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61776 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZBEEZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2009 23:25:58 -0500
Subject: Question of V4L2 API spec for sliced VBI VIDIOC_S_FMT
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Content-Type: text/plain
Date: Wed, 04 Feb 2009 23:25:58 -0500
Message-Id: <1233807958.4422.21.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 spec has some funny languague in the VIDIOC_S_FMT, and
VIDIOC_TRY_FMT documentation and section 4.8.3 on setting or trying
sliced VBI formats.

For VIDIOC_TRY_FMT for sliced vbi, the ioctl() is only supposed to fail
if the v4l2_format->type is for sliced vbi capture or sliced vbi output
and it is not supported.  Otherwise the ioctl() is to successfully
return the sanitized v4l2_format->fmt.sliced.service_set and
v4l2_format->fmt.sliced.service_lines, even if the sanitization returns
them all as 0, implying no support for what was requested.  I'm OK with
all that so far.

For the VIDIOC_S_FMT for sliced vbi, the driver is supposed to return
-EBUSY if the operation can happen right now (that's fine), or -EINVAL
if the passed in parameters are "ambiguous".  What does ambiguous mean
here?  Specifically, does that include a VIDIOC_S_FMT where the
v4l2_format->fmt.sliced.service_set and
v4l2_format->fmt.sliced.service_lines all come back as zero when
sanitized as with VIDIOC_TRY_FMT?

I ask, becasue the cx18 driver, with VBI ioctl() code of ivtv origin,
returns -EINVAL in this case, but that doesn't seem right to me.
There's nothing ambiguous about a well formed request for a service set
combination that isn't supported at all by the hardware.  It's a valid
request, as affirmed by VIDIOC_TRY_FMT, even if it is a useless request
as far as VIDIOC_S_FMT and actually capturing VBI data is concerned.

I suspect there might be some history or rationale I don't know about
which would be fine.  I'd just like to clean up the ambiguous
"ambiguous" in the V4L2 spec in that case.

Regards,
Andy

