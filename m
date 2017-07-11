Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38368 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753338AbdGKJnx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 05:43:53 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] fc001[23]: make const gain table arrays static
Date: Tue, 11 Jul 2017 10:43:49 +0100
Message-Id: <20170711094349.13263-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the gain tables on the stack but make them static const.
Makes the object code smaller:

Before:
   text	   data	    bss	    dec	    hex	filename
   7801	   1408	      0	   9209	   23f9	drivers/media/tuners/fc0012.o
   8483	    936	      0	   9419	   24cb	drivers/media/tuners/fc0013.o

After:
   text	   data	    bss	    dec	    hex	filename
   7696	   1464	      0	   9160	   23c8	drivers/media/tuners/fc0012.o
   8362	   1024	      0	   9386	   24aa	drivers/media/tuners/fc0013.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/tuners/fc0012.c | 2 +-
 drivers/media/tuners/fc0013.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index dcc323ffbde7..625ac6f51c39 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -351,7 +351,7 @@ static int fc0012_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	int ret;
 	unsigned char tmp;
 	int int_temp, lna_gain, int_lna, tot_agc_gain, power;
-	const int fc0012_lna_gain_table[] = {
+	static const int fc0012_lna_gain_table[] = {
 		/* low gain */
 		-63, -58, -99, -73,
 		-63, -65, -54, -60,
diff --git a/drivers/media/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
index 91dfa770a5cc..e606118d1a9b 100644
--- a/drivers/media/tuners/fc0013.c
+++ b/drivers/media/tuners/fc0013.c
@@ -511,7 +511,7 @@ static int fc0013_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	int ret;
 	unsigned char tmp;
 	int int_temp, lna_gain, int_lna, tot_agc_gain, power;
-	const int fc0013_lna_gain_table[] = {
+	static const int fc0013_lna_gain_table[] = {
 		/* low gain */
 		-63, -58, -99, -73,
 		-63, -65, -54, -60,
-- 
2.11.0
