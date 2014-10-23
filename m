Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4356 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaJWLWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 07:22:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 15/15] vb2: update the buf_prepare/finish documentation
Date: Thu, 23 Oct 2014 13:21:42 +0200
Message-Id: <1414063302-26903-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
References: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document how the new vb2_plane_begin/end_cpu_access() functions should
be used in buf_prepare/finish.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4632341..6a15eb8 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -282,21 +282,30 @@ struct vb2_buffer {
  *			perform any initialization required before each
  *			hardware operation in this callback; drivers can
  *			access/modify the buffer here as it is still synced for
- *			the CPU; drivers that support VIDIOC_CREATE_BUFS must
- *			also validate the buffer size; if an error is returned,
- *			the buffer will not be queued in driver; optional.
+ *			the CPU, provided you bracket the cpu access part with
+ *			@vb2_plane_begin_cpu_access and @vb2_plane_end_cpu_access;
+ *			when using videobuf2-vmalloc.h you can postpone the call
+ *			to @vb2_plane_end_cpu_access to @buf_finish; drivers
+ *			that support VIDIOC_CREATE_BUFS must also validate
+ *			the buffer size; if an error is returned, the buffer
+ *			will not be queued in driver; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
  *			userspace; the buffer is synced for the CPU, so drivers
- *			can access/modify the buffer contents; drivers may
- *			perform any operations required before userspace
- *			accesses the buffer; optional. The buffer state can be
- *			one of the following: DONE and ERROR occur while
- *			streaming is in progress, and the PREPARED state occurs
- *			when the queue has been canceled and all pending
- *			buffers are being returned to their default DEQUEUED
- *			state. Typically you only have to do something if the
- *			state is VB2_BUF_STATE_DONE, since in all other cases
- *			the buffer contents will be ignored anyway.
+ *			can access/modify the buffer contents provided you
+ *			bracket the cpu access part with
+ *			@vb2_plane_begin_cpu_access and @vb2_plane_end_cpu_access;
+ *			when using videobuf2-vmalloc.h you can call
+ *			@vb2_plane_end_cpu_access here to bracket a corresponding
+ *			@vb2_plane_begin_cpu_access call in @buf_prepare;
+ *			drivers may perform any operations required before
+ *			userspace accesses the buffer; optional. The buffer
+ *			state can be one of the following: DONE and ERROR
+ *			occur while streaming is in progress, and the PREPARED
+ *			state occurs when the queue has been canceled and all
+ *			pending buffers are being returned to their default
+ *			DEQUEUED state. Typically you only have to do something
+ *			if the state is VB2_BUF_STATE_DONE, since in all other
+ *			cases the buffer contents will be ignored anyway.
  * @buf_cleanup:	called once before the buffer is freed; drivers may
  *			perform any additional cleanup; optional.
  * @start_streaming:	called once to enter 'streaming' state; the driver may
-- 
2.1.1

