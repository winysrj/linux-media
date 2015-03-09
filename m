Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020AbbCIPqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:46:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/29] vivid-tpg: don't add offset when switching to monochrome
Date: Mon,  9 Mar 2015 16:44:29 +0100
Message-Id: <1425915891-1017-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The grayscale values are still full range sRGB, so don't add the
limited range offset.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index e2af384..c1476a2 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -530,7 +530,7 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 	if (tpg->qual == TPG_QUAL_GRAY) {
 		/* Rec. 709 Luma function */
 		/* (0.2126, 0.7152, 0.0722) * (255 * 256) */
-		r = g = b = ((13879 * r + 46688 * g + 4713 * b) >> 16) + (16 << 4);
+		r = g = b = (13879 * r + 46688 * g + 4713 * b) >> 16;
 	}
 
 	/*
-- 
2.1.4

