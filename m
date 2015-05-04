Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:36510 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbEDIHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 04:07:44 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 4/4] media/vivid: Code cleanout
Date: Mon,  4 May 2015 10:07:32 +0200
Message-Id: <1430726852-11715-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove code duplication by merging two cases in a switch.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 2e5129a6bc2f..8cac0bdefd9a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -294,6 +294,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	}
 
 	switch (fourcc) {
+	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_RGB332:
 		tpg->twopixelsize[0] = 2;
 		break;
@@ -333,9 +334,6 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_YUV32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
-	case V4L2_PIX_FMT_GREY:
-		tpg->twopixelsize[0] = 2;
-		break;
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV12M:
-- 
2.1.4

