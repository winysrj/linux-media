Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58518 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760750AbbKTQkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:40:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv10 15/15] test
Date: Fri, 20 Nov 2015 17:34:18 +0100
Message-Id: <1448037258-36305-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ef03ae5..956604d 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -130,7 +130,7 @@ struct vb2_mem_ops {
  * @bytesused:	number of bytes occupied by data in the plane (payload)
  * @length:	size of this plane (NOT the payload) in bytes
  * @min_length:	minimum required size of this plane (NOT the payload) in bytes.
- *		@length is always greater or equal to @min_length.
+  *		@length is always greater or equal to @min_length.
  * @offset:	when memory in the associated struct vb2_buffer is
  *		VB2_MEMORY_MMAP, equals the offset from the start of
  *		the device memory for this plane (or is a "cookie" that
-- 
2.6.2

