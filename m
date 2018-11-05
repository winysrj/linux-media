Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49761 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730109AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 10/15] media: coda: never set infinite timeperframe
Date: Mon,  5 Nov 2018 16:25:08 +0100
Message-Id: <20181105152513.26345-10-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance complains if G_PARM returns 0 in the denominator.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 32998da39cac..c4d48069606c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1112,10 +1112,10 @@ static void coda_approximate_timeperframe(struct v4l2_fract *timeperframe)
 		return;
 	}
 
-	/* Upper bound is 65536/1, map everything above to infinity */
+	/* Upper bound is 65536/1 */
 	if (s.denominator == 0 || s.numerator / s.denominator > 65536) {
-		timeperframe->numerator = 1;
-		timeperframe->denominator = 0;
+		timeperframe->numerator = 65536;
+		timeperframe->denominator = 1;
 		return;
 	}
 
-- 
2.19.1
