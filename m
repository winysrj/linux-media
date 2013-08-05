Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53141 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab3HERwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 13:52:38 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v6 03/10] media: vb2: Clarify queue_setup() and buf_prepare() usage documentation
Date: Mon,  5 Aug 2013 19:53:22 +0200
Message-Id: <1375725209-2674-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Explain how the two operations must handle formats and validate buffer
sizes when used with VIDIOC_CREATE_BUFS.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d88a098..6781258 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -219,8 +219,9 @@ struct vb2_buffer {
  *			configured format and *num_buffers is the total number
  *			of buffers, that are being allocated. When called from
  *			VIDIOC_CREATE_BUFS, fmt != NULL and it describes the
- *			target frame format. In this case *num_buffers are being
- *			allocated additionally to q->num_buffers.
+ *			target frame format (if the format isn't valid the
+ *			callback must return -EINVAL). In this case *num_buffers
+ *			are being allocated additionally to q->num_buffers.
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
  *			buffer to arrive; required to avoid a deadlock in
@@ -236,8 +237,10 @@ struct vb2_buffer {
  * @buf_prepare:	called every time the buffer is queued from userspace
  *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
  *			perform any initialization required before each hardware
- *			operation in this callback; if an error is returned, the
- *			buffer will not be queued in driver; optional
+ *			operation in this callback; drivers that support
+ *			VIDIOC_CREATE_BUFS must also validate the buffer size;
+ *			if an error is returned, the buffer will not be queued
+ *			in driver; optional
  * @buf_finish:		called before every dequeue of the buffer back to
  *			userspace; drivers may perform any operations required
  *			before userspace accesses the buffer; optional
-- 
1.8.1.5

