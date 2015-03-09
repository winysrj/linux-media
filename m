Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47178 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbbCIPpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:45:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/29] vivid: fix typo in plane size checks
Date: Mon,  9 Mar 2015 16:44:24 +0100
Message-Id: <1425915891-1017-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The plane size check was hardcoded to plane 0 instead of using the plane
index.

This failed when using the NV61M format which has a larger plane size for
the second plane compared to the first plane.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 550945a..49f79a0 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -188,9 +188,9 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 		size = tpg_g_bytesperline(&dev->tpg, p) * dev->fmt_cap_rect.height +
 			dev->fmt_cap->data_offset[p];
 
-		if (vb2_plane_size(vb, 0) < size) {
+		if (vb2_plane_size(vb, p) < size) {
 			dprintk(dev, 1, "%s data will not fit into plane %u (%lu < %lu)\n",
-					__func__, p, vb2_plane_size(vb, 0), size);
+					__func__, p, vb2_plane_size(vb, p), size);
 			return -EINVAL;
 		}
 
-- 
2.1.4

