Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab2J0UmA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:00 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKfxuO004746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/68] [media] rtl2832: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:22 -0200
Message-Id: <1351370486-29040-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/rtl2832.c:268:5: warning: no previous prototype for 'rtl2832_rd_demod_reg' [-Wmissing-prototypes]
drivers/media/dvb-frontends/rtl2832.c:308:5: warning: no previous prototype for 'rtl2832_wr_demod_reg' [-Wmissing-prototypes]
drivers/media/dvb-frontends/rtl2832.c:513:5: warning: no previous prototype for 'rtl2832_get_tune_settings' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/rtl2832.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 80c8e5f..7388769 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -265,7 +265,7 @@ static int rtl2832_rd_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val)
 	return rtl2832_rd_regs(priv, reg, page, val, 1);
 }
 
-int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val)
+static int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val)
 {
 	int ret;
 
@@ -305,7 +305,7 @@ err:
 
 }
 
-int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
+static int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
 {
 	int ret, i;
 	u8 len;
@@ -510,7 +510,7 @@ static int rtl2832_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-int rtl2832_get_tune_settings(struct dvb_frontend *fe,
+static int rtl2832_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
-- 
1.7.11.7

