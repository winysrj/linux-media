Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab3DQAmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:52 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gqQY003914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 17/31] [media] r820t: split the function that read cached regs
Date: Tue, 16 Apr 2013 21:42:28 -0300
Message-Id: <1366159362-3773-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll need to retrieve cached registers, make this
function explicit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index d5686e8..ef100ab 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -402,15 +402,25 @@ static int r820t_write_reg(struct r820t_priv *priv, u8 reg, u8 val)
 	return r820t_write(priv, reg, &val, 1);
 }
 
-static int r820t_write_reg_mask(struct r820t_priv *priv, u8 reg, u8 val,
-				u8 bit_mask)
+static int r820t_read_cache_reg(struct r820t_priv *priv, int reg)
 {
-	int r = reg - REG_SHADOW_START;
+	reg -= REG_SHADOW_START;
 
-	if (r >= 0 && r < NUM_REGS)
-		val = (priv->regs[r] & ~bit_mask) | (val & bit_mask);
+	if (reg >= 0 && reg < NUM_REGS)
+		return priv->regs[reg];
 	else
 		return -EINVAL;
+}
+
+static int r820t_write_reg_mask(struct r820t_priv *priv, u8 reg, u8 val,
+				u8 bit_mask)
+{
+	int rc = r820t_read_cache_reg(priv, reg);
+
+	if (rc < 0)
+		return rc;
+
+	val = (rc & ~bit_mask) | (val & bit_mask);
 
 	return r820t_write(priv, reg, &val, 1);
 }
-- 
1.8.1.4

