Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32890 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754119AbdCIWvJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 17:51:09 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH v1 5/7] staging: gc2235: Remove multiple assignments
Date: Fri, 10 Mar 2017 04:20:27 +0530
Message-Id: <1489099829-1264-6-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
References: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove multiple assignments by factorizing them. Problem found using
checkpatch.pl

CHECK: multiple assignments should be avoided

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 198df22..165dcb3 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -259,7 +259,8 @@ static int gc2235_get_intg_factor(struct i2c_client *client,
 		return -EINVAL;
 
 	/* pixel clock calculattion */
-	buf->vt_pix_clk_freq_mhz = dev->vt_pix_clk_freq_mhz = 30000000;
+	buf->vt_pix_clk_freq_mhz = 30000000;
+	dev->vt_pix_clk_freq_mhz = 30000000;
 
 	/* get integration time */
 	buf->coarse_integration_time_min = GC2235_COARSE_INTG_TIME_MIN;
-- 
2.7.4
