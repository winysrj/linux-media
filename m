Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757983Ab2J0Ume (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:34 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/68] [media] tda10071: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:25 -0200
Message-Id: <1351370486-29040-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/tda10071.c:119:5: warning: no previous prototype for 'tda10071_rd_reg_mask' [-Wmissing-prototypes]
drivers/media/dvb-frontends/tda10071.c:99:5: warning: no previous prototype for 'tda10071_wr_reg_mask' [-Wmissing-prototypes]

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/tda10071.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index a83bf68..16a4bc5 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -96,7 +96,8 @@ static int tda10071_rd_reg(struct tda10071_priv *priv, u8 reg, u8 *val)
 }
 
 /* write single register with mask */
-int tda10071_wr_reg_mask(struct tda10071_priv *priv, u8 reg, u8 val, u8 mask)
+static int tda10071_wr_reg_mask(struct tda10071_priv *priv,
+				u8 reg, u8 val, u8 mask)
 {
 	int ret;
 	u8 tmp;
@@ -116,7 +117,8 @@ int tda10071_wr_reg_mask(struct tda10071_priv *priv, u8 reg, u8 val, u8 mask)
 }
 
 /* read single register with mask */
-int tda10071_rd_reg_mask(struct tda10071_priv *priv, u8 reg, u8 *val, u8 mask)
+static int tda10071_rd_reg_mask(struct tda10071_priv *priv,
+				u8 reg, u8 *val, u8 mask)
 {
 	int ret, i;
 	u8 tmp;
-- 
1.7.11.7

