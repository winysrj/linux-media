Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35393 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbbCHHyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 03:54:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] vivid: BT.2020 R'G'B' is limited range
Date: Sun,  8 Mar 2015 08:53:33 +0100
Message-Id: <1425801213-14230-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
References: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 34493f4..acb73b6 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1265,6 +1265,10 @@ static void tpg_recalc(struct tpg_data *tpg)
 						V4L2_QUANTIZATION_LIM_RANGE;
 					break;
 				}
+			} else if (tpg->colorspace == V4L2_COLORSPACE_BT2020) {
+				/* R'G'B' BT.2020 is limited range */
+				tpg->real_quantization =
+					V4L2_QUANTIZATION_LIM_RANGE;
 			}
 		}
 		tpg_precalculate_colors(tpg);
-- 
2.1.4

