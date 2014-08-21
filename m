Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2395 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHUUTw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/12] via-camera: fix sparse warning
Date: Thu, 21 Aug 2014 22:19:26 +0200
Message-Id: <1408652376-39525-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/platform/via-camera.c:445:34: warning: incorrect type in assignment (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/via-camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index b4f9d03..01da980 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -89,7 +89,7 @@ struct via_camera {
 	 * live in frame buffer memory, so we don't call them "DMA".
 	 */
 	unsigned int cb_offsets[3];	/* offsets into fb mem */
-	u8 *cb_addrs[3];		/* Kernel-space addresses */
+	u8 __iomem *cb_addrs[3];		/* Kernel-space addresses */
 	int n_cap_bufs;			/* How many are we using? */
 	int next_buf;
 	struct videobuf_queue vb_queue;
-- 
2.1.0.rc1

