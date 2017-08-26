Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35174 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754709AbdHZKV0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:21:26 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, hverkuil@xs4all.nl,
        corbet@lwn.net, kyungmin.park@samsung.com, kamil@wypas.org,
        a.hajda@samsung.com, bparrot@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 07/10] [media] via-camera: make video_device const
Date: Sat, 26 Aug 2017 15:50:09 +0530
Message-Id: <1503742812-16139-8-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
References: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/via-camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index e16f70a..805d4a8 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1259,7 +1259,7 @@ static int viacam_resume(void *priv)
  * Setup stuff.
  */
 
-static struct video_device viacam_v4l_template = {
+static const struct video_device viacam_v4l_template = {
 	.name		= "via-camera",
 	.minor		= -1,
 	.tvnorms	= V4L2_STD_NTSC_M,
-- 
1.9.1
