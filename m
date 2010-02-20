Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1907 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0BTN6J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2010 08:58:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: More videobuf and streaming I/O questions
Date: Sat, 20 Feb 2010 15:00:21 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002201500.21118.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a few more questions regarding the streaming I/O API:

1) The spec mentions that the memory field should be set for VIDIOC_DQBUF.
But videobuf doesn't need it and it makes no sense to me either unless it
is for symmetry with VIDIOC_QBUF. Strictly speaking QBUF doesn't need it
either, but it is a good sanity check.

Can I remove the statement in the spec that memory should be set for DQBUF?
The alternative is to add a check against the memory field in videobuf, but
that's rather scary.

2) What to do with REQBUFS when called with a count of 0? Thinking it over I
agree that it shouldn't do an implicit STREAMOFF. But I do think that it is
useful to allow as a simple check whether the I/O method is supported.

So a count of 0 will either return an error if streaming is still in progress
or if the proposed I/O method is not supported, otherwise it will return 0
while leaving count to 0.

This allows one to use REQBUFS to test which I/O methods are supported by
the driver without having the driver allocating any buffers.

This will become more important with embedded systems where almost certainly
additional I/O methods will be introduced (in particular non-contiguous plane
support).

Currently a count of 0 will result in an error in videobuf.

Note that drivers do not generally check for valid values of the memory field
at the moment. So that is another thing we need to improve. But before I start
working on that, I first want to know exactly how REQBUFS should work.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
