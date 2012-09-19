Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3831 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2ISOi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 10:38:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 4/6] videobuf2-core: fill in length field for multiplanar buffers.
Date: Wed, 19 Sep 2012 16:37:38 +0200
Message-Id: <bbbf815b74d00312a07be07ad4f336a3792fd0d3.1348064901.git.hans.verkuil@cisco.com>
In-Reply-To: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
References: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

length should be set to num_planes in __fill_v4l2_buffer(). That way the
caller knows how many planes there are in the buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 929cc99..bbfe022 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -348,6 +348,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * Fill in plane-related data if userspace provided an array
 		 * for it. The memory and size is verified above.
 		 */
+		b->length = q->num_planes;
 		memcpy(b->m.planes, vb->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
 	} else {
-- 
1.7.10.4

