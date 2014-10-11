Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2958 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaJKJW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Oct 2014 05:22:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 01/10] videobuf2-core.h: improve documentation
Date: Sat, 11 Oct 2014 11:22:28 +0200
Message-Id: <1413019357-12382-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1413019357-12382-1-git-send-email-hverkuil@xs4all.nl>
References: <1413019357-12382-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document that drivers can access/modify the buffer contents in buf_prepare
and buf_finish. That was not clearly stated before.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5a10d8d..029d099 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -270,22 +270,24 @@ struct vb2_buffer {
  *			queue setup from completing successfully; optional.
  * @buf_prepare:	called every time the buffer is queued from userspace
  *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
- *			perform any initialization required before each hardware
- *			operation in this callback; drivers that support
- *			VIDIOC_CREATE_BUFS must also validate the buffer size;
- *			if an error is returned, the buffer will not be queued
- *			in driver; optional.
+ *			perform any initialization required before each
+ *			hardware operation in this callback; drivers can
+ *			access/modify the buffer here as it is still synced for
+ *			the CPU; drivers that support VIDIOC_CREATE_BUFS must
+ *			also validate the buffer size; if an error is returned,
+ *			the buffer will not be queued in driver; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
- *			userspace; drivers may perform any operations required
- *			before userspace accesses the buffer; optional. The
- *			buffer state can be one of the following: DONE and
- *			ERROR occur while streaming is in progress, and the
- *			PREPARED state occurs when the queue has been canceled
- *			and all pending buffers are being returned to their
- *			default DEQUEUED state. Typically you only have to do
- *			something if the state is VB2_BUF_STATE_DONE, since in
- *			all other cases the buffer contents will be ignored
- *			anyway.
+ *			userspace; the buffer is synced for the CPU, so drivers
+ *			can access/modify the buffer contents; drivers may
+ *			perform any operations required before userspace
+ *			accesses the buffer; optional. The buffer state can be
+ *			one of the following: DONE and ERROR occur while
+ *			streaming is in progress, and the PREPARED state occurs
+ *			when the queue has been canceled and all pending
+ *			buffers are being returned to their default DEQUEUED
+ *			state. Typically you only have to do something if the
+ *			state is VB2_BUF_STATE_DONE, since in all other cases
+ *			the buffer contents will be ignored anyway.
  * @buf_cleanup:	called once before the buffer is freed; drivers may
  *			perform any additional cleanup; optional.
  * @start_streaming:	called once to enter 'streaming' state; the driver may
-- 
2.1.1

