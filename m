Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab3DQAnH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:07 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h7XU003953
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 23/31] [media] r820t: Allow disabling IMR callibration
Date: Tue, 16 Apr 2013 21:42:34 -0300
Message-Id: <1366159362-3773-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rtl-sdr library disabled IMR callibration. While I'm not sure
yet why, it could be a good idea to add a modprobe parameter here,
to allow to also disable it. There are two rationale behind it:
- It helps to compare USB dumps between rtl-sdr and the Kernel module;
- If rtl-sdr disabled it, perhaps there's a good reason (e. g. it
  might not be actually working, or it might be causing some trouble).
For both cases, it seems useful to add a modprobe parameter to allow
testing the device with both configurations.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 0125de8..2e6a690 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -56,6 +56,11 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable verbose debug messages");
 
+static int no_imr_cal;
+module_param(no_imr_cal, int, 0444);
+MODULE_PARM_DESC(no_imr_cal, "Disable IMR calibration at module init");
+
+
 /*
  * enums and structures
  */
@@ -87,7 +92,8 @@ struct r820t_priv {
 	u32				int_freq;
 	u8				fil_cal_code;
 	bool				imr_done;
-
+	bool				has_lock;
+	bool				init_done;
 	struct r820t_sect_type		imr_data[NUM_IMR];
 
 	/* Store current mode */
@@ -95,8 +101,6 @@ struct r820t_priv {
 	enum v4l2_tuner_type		type;
 	v4l2_std_id			std;
 	u32				bw;	/* in MHz */
-
-	bool				has_lock;
 };
 
 struct r820t_freq_range {
@@ -1999,7 +2003,7 @@ static int r820t_imr_callibrate(struct r820t_priv *priv)
 	int rc, i;
 	int xtal_cap = 0;
 
-	if (priv->imr_done)
+	if (priv->init_done)
 		return 0;
 
 	/* Initialize registers */
@@ -2024,6 +2028,16 @@ static int r820t_imr_callibrate(struct r820t_priv *priv)
 		priv->xtal_cap_sel = xtal_cap;
 	}
 
+	/*
+	 * Disables IMR callibration. That emulates the same behaviour
+	 * as what is done by rtl-sdr userspace library. Useful for testing
+	 */
+	if (no_imr_cal) {
+		priv->init_done = true;
+
+		return 0;
+	}
+
 	/* Initialize registers */
 	rc = r820t_write(priv, 0x05,
 			 r820t_init_array, sizeof(r820t_init_array));
@@ -2050,6 +2064,7 @@ static int r820t_imr_callibrate(struct r820t_priv *priv)
 	if (rc < 0)
 		return rc;
 
+	priv->init_done = true;
 	priv->imr_done = true;
 
 	return 0;
-- 
1.8.1.4

