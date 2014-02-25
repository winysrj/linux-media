Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3819 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaBYKEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 11/20] vb2: improve buf_prepare/finish comments
Date: Tue, 25 Feb 2014 11:04:16 +0100
Message-Id: <1393322665-29889-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Clarify in the buf_prepare/finish ops what the dma mapping status is of
the provided buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a0dedc1..169e111 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -274,12 +274,14 @@ struct vb2_buffer {
  *			operation in this callback; drivers that support
  *			VIDIOC_CREATE_BUFS must also validate the buffer size;
  *			if an error is returned, the buffer will not be queued
- *			in driver; optional.
+ *			in driver; any necessary DMA mapping action will have
+ *			been done before this is called; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
  *			userspace; drivers may perform any operations required
- *			before userspace accesses the buffer; optional. Note:
- *			this op can be called as well when vb2_is_streaming()
- *			returns false!
+ *			before userspace accesses the buffer; any necessary DMA
+ *			unmapping action will have been done before this is
+ *			called; optional. Note: this op can be called as well
+ *			when vb2_is_streaming() returns false!
  * @buf_cleanup:	called once before the buffer is freed; drivers may
  *			perform any additional cleanup; optional.
  * @start_streaming:	called once to enter 'streaming' state; the driver may
-- 
1.9.0

