Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35348 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751441AbdG0PjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 11:39:20 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-tpg-core.c: fix typo in bt2020_full matrix
Message-ID: <cdee9afa-6824-aaf5-e0e3-c724d00ee107@xs4all.nl>
Date: Thu, 27 Jul 2017 17:39:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My eye fell on this wrong coefficient in the bt2020_full matrix.
The bt2020 matrix (limited range) is OK.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 3dd22da7e17d..a772976cfe26 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -615,7 +615,7 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 	static const int bt2020_full[3][3] = {
 		{ COEFF(0.2627, 255),  COEFF(0.6780, 255),  COEFF(0.0593, 255)  },
 		{ COEFF(-0.1396, 255), COEFF(-0.3604, 255), COEFF(0.5, 255)     },
-		{ COEFF(0.5, 255),     COEFF(-0.4698, 255), COEFF(-0.0402, 255) },
+		{ COEFF(0.5, 255),     COEFF(-0.4598, 255), COEFF(-0.0402, 255) },
 	};
 	static const int bt2020c[4] = {
 		COEFF(1.0 / 1.9404, 224), COEFF(1.0 / 1.5816, 224),
