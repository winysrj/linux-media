Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:57099 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966053AbdIYUSm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 16:18:42 -0400
To: linux-media@vger.kernel.org, Daniele Nicolodi <daniele@grinta.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] bt8xx: Use common error handling code in two
 functions
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <7ad78087-fdd4-b76b-d770-81b9a55aaabd@users.sourceforge.net>
Date: Mon, 25 Sep 2017 22:18:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 25 Sep 2017 22:10:17 +0200

Adjust jump targets so that a bit of exception handling can be better
reused at the end of these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/bt8xx/dst.c    | 19 +++++++++++--------
 drivers/media/pci/bt8xx/dst_ca.c | 30 +++++++++++++++---------------
 2 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 7166d2279465..1290419aca0b 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -134,17 +134,20 @@ EXPORT_SYMBOL(rdc_reset_state);
 static int rdc_8820_reset(struct dst_state *state)
 {
 	dprintk(3, "Resetting DST\n");
-	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY) < 0) {
-		pr_err("dst_gpio_outb ERROR !\n");
-		return -1;
-	}
+	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY)
+	    < 0)
+		goto report_failure;
+
 	udelay(1000);
-	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, RDC_8820_RESET, DELAY) < 0) {
-		pr_err("dst_gpio_outb ERROR !\n");
-		return -1;
-	}
+	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET,
+			  RDC_8820_RESET, DELAY) < 0)
+		goto report_failure;
 
 	return 0;
+
+report_failure:
+	pr_err("dst_gpio_outb ERROR !\n");
+	return -1;
 }
 
 static int dst_pio_enable(struct dst_state *state)
diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 90f4263452d3..5ea0a9c9a590 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -97,33 +97,33 @@ static int dst_ci_command(struct dst_state* state, u8 * data, u8 *ca_string, u8
 
 	if (write_dst(state, data, len)) {
 		dprintk(verbose, DST_CA_INFO, 1, " Write not successful, trying to recover");
-		dst_error_recovery(state);
-		goto error;
+		goto error_recovery;
 	}
 	if ((dst_pio_disable(state)) < 0) {
 		dprintk(verbose, DST_CA_ERROR, 1, " DST PIO disable failed.");
-		goto error;
-	}
-	if (read_dst(state, &reply, GET_ACK) < 0) {
-		dprintk(verbose, DST_CA_INFO, 1, " Read not successful, trying to recover");
-		dst_error_recovery(state);
-		goto error;
+		goto unlock;
 	}
+	if (read_dst(state, &reply, GET_ACK) < 0)
+		goto report_read_failure;
+
 	if (read) {
 		if (! dst_wait_dst_ready(state, LONG_DELAY)) {
 			dprintk(verbose, DST_CA_NOTICE, 1, " 8820 not ready");
-			goto error;
-		}
-		if (read_dst(state, ca_string, 128) < 0) {	/*	Try to make this dynamic	*/
-			dprintk(verbose, DST_CA_INFO, 1, " Read not successful, trying to recover");
-			dst_error_recovery(state);
-			goto error;
+			goto unlock;
 		}
+		/* Try to make this dynamic */
+		if (read_dst(state, ca_string, 128) < 0)
+			goto report_read_failure;
 	}
 	mutex_unlock(&state->dst_mutex);
 	return 0;
 
-error:
+report_read_failure:
+	dprintk(verbose, DST_CA_INFO, 1,
+		" Read not successful, trying to recover");
+error_recovery:
+	dst_error_recovery(state);
+unlock:
 	mutex_unlock(&state->dst_mutex);
 	return -EIO;
 }
-- 
2.14.1
