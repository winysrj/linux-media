Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59269 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 05/15] media: coda: reduce minimum frame size to 48x16 pixels.
Date: Mon,  5 Nov 2018 16:25:03 +0100
Message-Id: <20181105152513.26345-5-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Three macroblocks seem to be the minimum resolution that can be encoded
and decoded by the CODA960 h.264 codec. Picture run commands fail for
smaller resolutions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c7a274c60ff9..01deb454e60b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -50,8 +50,8 @@
 
 #define CODA_ISRAM_SIZE	(2048 * 2)
 
-#define MIN_W 176
-#define MIN_H 144
+#define MIN_W 48
+#define MIN_H 16
 
 #define S_ALIGN		1 /* multiple of 2 */
 #define W_ALIGN		1 /* multiple of 2 */
-- 
2.19.1
