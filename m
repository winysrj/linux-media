Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3527 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaHDK12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 06:27:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.17 1/2] videobuf2-core.h: fix comment
Date: Mon,  4 Aug 2014 12:27:11 +0200
Message-Id: <1407148032-41607-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407148032-41607-1-git-send-email-hverkuil@xs4all.nl>
References: <1407148032-41607-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The comment for start_streaming that tells the developer with which vb2 state
buffers should be returned to vb2 gave the wrong state. Very confusing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index fc910a6..80fa725 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -295,7 +295,7 @@ struct vb2_buffer {
  *			can return an error if hardware fails, in that case all
  *			buffers that have been already given by the @buf_queue
  *			callback are to be returned by the driver by calling
- *			@vb2_buffer_done(VB2_BUF_STATE_DEQUEUED).
+ *			@vb2_buffer_done(VB2_BUF_STATE_QUEUED).
  *			If you need a minimum number of buffers before you can
  *			start streaming, then set @min_buffers_needed in the
  *			vb2_queue structure. If that is non-zero then
-- 
2.0.1

