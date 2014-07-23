Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1949 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaGWGRT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 02:17:19 -0400
Message-ID: <53CF5362.2050003@xs4all.nl>
Date: Wed, 23 Jul 2014 08:17:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH for v3.17] vb2: fix videobuf2-core.h comments
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A lot of work was done in vb2 to regulate how drivers and the vb2 core handle
buffer ownership, but inexplicably the videobuf2-core.h comments were never
updated. Do so now. The same was true for the replacement of the -ENOBUFS
mechanism by the min_buffers_needed field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>


diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 1a262ae..fc910a6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -294,15 +294,19 @@ struct vb2_buffer {
  *			of already queued buffers in count parameter; driver
  *			can return an error if hardware fails, in that case all
  *			buffers that have been already given by the @buf_queue
- *			callback are invalidated.
- *			If there were not enough queued buffers to start
- *			streaming, then this callback returns -ENOBUFS, and the
- *			vb2 core will retry calling @start_streaming when a new
- *			buffer is queued.
+ *			callback are to be returned by the driver by calling
+ *			@vb2_buffer_done(VB2_BUF_STATE_DEQUEUED).
+ *			If you need a minimum number of buffers before you can
+ *			start streaming, then set @min_buffers_needed in the
+ *			vb2_queue structure. If that is non-zero then
+ *			start_streaming won't be called until at least that
+ *			many buffers have been queued up by userspace.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
  *			finish and give back all buffers it got from buf_queue()
- *			callback; may use vb2_wait_for_all_buffers() function
+ *			callback by calling @vb2_buffer_done() with either
+ *			VB2_BUF_STATE_DONE or VB2_BUF_STATE_ERROR; may use
+ *			vb2_wait_for_all_buffers() function
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
  *			the buffer back by calling vb2_buffer_done() function;
