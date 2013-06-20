Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3787 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422788Ab3FTU21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 16:28:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [REVIEW PATCH 3/3] omap_vout: fix compiler warning
Date: Thu, 20 Jun 2013 22:28:16 +0200
Message-Id: <1371760096-19256-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371760096-19256-1-git-send-email-hverkuil@xs4all.nl>
References: <1371760096-19256-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media-git/drivers/media/platform/omap/omap_vout.c: In function ‘omapvid_init’:
media-git/drivers/media/platform/omap/omap_vout.c:382:17: warning: ‘mode’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  vout->dss_mode = video_mode_to_dss_mode(vout);
                 ^
media-git/drivers/media/platform/omap/omap_vout.c:332:23: note: ‘mode’ was declared here
  enum omap_color_mode mode;
                       ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>
---
 drivers/media/platform/omap/omap_vout.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index d338b19..dfd0a21 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -335,8 +335,6 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
 	ovl = ovid->overlays[0];
 
 	switch (pix->pixelformat) {
-	case 0:
-		break;
 	case V4L2_PIX_FMT_YUYV:
 		mode = OMAP_DSS_COLOR_YUV2;
 		break;
@@ -358,6 +356,7 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
 		break;
 	default:
 		mode = -EINVAL;
+		break;
 	}
 	return mode;
 }
-- 
1.8.3.1

