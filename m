Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab3DQAmt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:49 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gnjj017432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 13/31] [media] r820t: use the second table for 7MHz
Date: Tue, 16 Apr 2013 21:42:24 -0300
Message-Id: <1366159362-3773-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Realtek Kernel driver uses the second DVB-T 7MHz table instead
of the first one. Use it as well.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 79ab2b7..1880807e 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -915,6 +915,14 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 			flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
 			polyfil_cur = 0x60;	/* r25[6:5]:min */
 		} else if (bw == 7) {
+#if 0
+			/*
+			 * There are two 7 MHz tables defined on the original
+			 * driver, but just the second one seems to be visible
+			 * by rtl2832. Keep this one here commented, as it
+			 * might be needed in the future
+			 */
+
 			if_khz = 4070;
 			filt_cal_lo = 60000;
 			filt_gain = 0x10;	/* +3db, 6mhz on */
@@ -926,7 +934,8 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 			lt_att = 0x00;		/* r31[7], lt att enable */
 			flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
 			polyfil_cur = 0x60;	/* r25[6:5]:min */
-#if 0 /* 7 MHz type 2 - nor sure why/where this is used - Perhaps Australia? */
+#endif
+			/* 7 MHz, second table */
 			if_khz = 4570;
 			filt_cal_lo = 63000;
 			filt_gain = 0x10;	/* +3db, 6mhz on */
@@ -938,7 +947,6 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 			lt_att = 0x00;		/* r31[7], lt att enable */
 			flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
 			polyfil_cur = 0x60;	/* r25[6:5]:min */
-#endif
 		} else {
 			if_khz = 4570;
 			filt_cal_lo = 68500;
-- 
1.8.1.4

