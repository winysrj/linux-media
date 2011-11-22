Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1KVF07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 00:26:59 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so8242144iag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 21:26:59 -0800 (PST)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: mingchen@quicinc.com, hverkuil@xs4all.nl,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v1 2/2] vb2: add support for app_offset field of the v4l2_plane struct
Date: Mon, 21 Nov 2011 21:26:37 -0800
Message-Id: <1321939597-6239-3-git-send-email-pawel@osciak.com>
In-Reply-To: <1321939597-6239-1-git-send-email-pawel@osciak.com>
References: <1321939597-6239-1-git-send-email-pawel@osciak.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The app_offset can only be set by userspace and will be passed by vb2 to
the driver.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 979e544..41cc8e9 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -830,6 +830,11 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 			}
 		}
 
+		/* App offset can only be set by userspace, for all types */
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			v4l2_planes[plane].app_offset =
+				b->m.planes[plane].app_offset;
+
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				v4l2_planes[plane].m.userptr =
-- 
1.7.7.3

