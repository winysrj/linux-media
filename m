Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38501 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757385AbcIGKjL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 06:39:11 -0400
Received: from [10.47.79.81] (unknown [173.38.220.42])
        by tschai.lan (Postfix) with ESMTPSA id E0BA218597A
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 12:39:05 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l-drivers/fourcc.rst: fix typo
Message-ID: <23edb640-5a92-2eff-23a5-ce88bab7e2d7@xs4all.nl>
Date: Wed, 7 Sep 2016 12:39:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linux4Linux -> Video4Linux

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/v4l-drivers/fourcc.rst 
b/Documentation/media/v4l-drivers/fourcc.rst
index f7c8cef..9c82106 100644
--- a/Documentation/media/v4l-drivers/fourcc.rst
+++ b/Documentation/media/v4l-drivers/fourcc.rst
@@ -1,4 +1,4 @@
-Guidelines for Linux4Linux pixel format 4CCs
+Guidelines for Video4Linux pixel format 4CCs
  ============================================

  Guidelines for Video4Linux 4CC codes defined using v4l2_fourcc() are
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c 
b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 9cfbb6e..f21cce1 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -109,7 +109,8 @@ static int __verify_length(struct vb2_buffer *vb, 
const struct v4l2_buffer *b)
  				return -EINVAL;
  		}
  	} else {
-		length = (b->memory == VB2_MEMORY_USERPTR)
+		length = (b->memory == VB2_MEMORY_USERPTR ||
+			  b->memory == VB2_MEMORY_DMABUF)
  			? b->length : vb->planes[0].length;

  		if (b->bytesused > length)
