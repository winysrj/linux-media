Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53847 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730112AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 15/15] media: coda: debug output when setting visible size via crop selection
Date: Mon,  5 Nov 2018 16:25:13 +0100
Message-Id: <20181105152513.26345-15-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In addition to the S_FMT debug output, S_SELECTION (SEL_TGT_CROP) is
relevant to determine encoded size. Add debug output for it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 2a0e0d04c67a..bf4b21b7cdb3 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -961,6 +961,9 @@ static int coda_s_selection(struct file *file, void *fh,
 
 			q_data->rect = s->r;
 
+			coda_dbg(1, ctx, "Setting crop rectangle: %dx%d\n",
+				 s->r.width, s->r.height);
+
 			return 0;
 		}
 		/* else fall through */
-- 
2.19.1
