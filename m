Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab3DQAmv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:51 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gp3c021033
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:51 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 19/31] [media] r820t: use usleep_range()
Date: Tue, 16 Apr 2013 21:42:30 -0300
Message-Id: <1366159362-3773-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using msleep(), use sleep_range(), as it provides
a closer sleep time.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index e9367d8..279be4f 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -657,7 +657,7 @@ static int r820t_set_pll(struct r820t_priv *priv, u32 freq)
 		 * FIXME: Rafael chips R620D, R828D and R828 seems to
 		 * need 20 ms for analog TV
 		 */
-		msleep(10);
+		usleep_range(10000, 11000);
 
 		/* Check if PLL has locked */
 		rc = r820t_read(priv, 0x00, data, 3);
@@ -1007,7 +1007,7 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 		rc = r820t_write_reg_mask(priv, 0x1d, 0x00, 0x38);
 		if (rc < 0)
 			return rc;
-		msleep(1);
+		usleep_range(1000, 2000);
 	}
 	priv->int_freq = if_khz * 1000;
 
@@ -1049,7 +1049,7 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 			if (rc < 0)
 				return rc;
 
-			msleep(1);
+			usleep_range(1000, 2000);
 
 			/* Stop Trigger */
 			rc = r820t_write_reg_mask(priv, 0x0b, 0x00, 0x10);
@@ -1347,7 +1347,7 @@ static int r820t_xtal_check(struct r820t_priv *priv)
 		if (rc < 0)
 			return rc;
 
-		msleep(5);
+		usleep_range(5000, 6000);
 
 		rc = r820t_read(priv, 0x00, data, sizeof(data));
 		if (rc < 0)
-- 
1.8.1.4

