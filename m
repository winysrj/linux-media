Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32907 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbdHJMxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 08:53:34 -0400
Date: Thu, 10 Aug 2017 18:23:26 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media:staging:atomisp:ap1302: Fix comment style
Message-ID: <20170810125326.GA2927@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fix comment style to avoid warning from
checkpatch.pl script

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index fd0f2ac..7a0c0d5 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -235,11 +235,14 @@ static u16
 ap1302_calculate_context_reg_addr(enum ap1302_contexts context, u16 offset)
 {
 	u16 reg_addr;
-	/* The register offset is defined according to preview/video registers.
-	   Preview and video context have the same register definition.
-	   But snapshot context does not have register S1_SENSOR_MODE.
-	   When setting snapshot registers, if the offset exceeds
-	   S1_SENSOR_MODE, the actual offset needs to minus 2. */
+	/*
+	 * The register offset is defined according to preview/video registers.
+	 * Preview and video context have the same register definition.
+	 * But snapshot context does not have register S1_SENSOR_MODE.
+	 * When setting snapshot registers, if the offset exceeds
+	 * S1_SENSOR_MODE, the actual offset needs to minus 2.
+	 *
+	 */
 	if (context == CONTEXT_SNAPSHOT) {
 		if (offset == CNTX_S1_SENSOR_MODE)
 			return 0;
-- 
2.1.4
