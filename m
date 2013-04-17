Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab3DQAnI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:08 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h8D0021112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 29/31] [media] rtl2832: Fix IF calculus
Date: Tue, 16 Apr 2013 21:42:40 -0300
Message-Id: <1366159362-3773-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Spectrum is inverted. So, we need to invert it when calculating the
value for the IF register

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/rtl2832.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 2f5a2b5..facb848 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -396,7 +396,11 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 	pset_iffreq = if_freq % priv->cfg.xtal;
 	pset_iffreq *= 0x400000;
 	pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
+	pset_iffreq = -pset_iffreq;
 	pset_iffreq = pset_iffreq & 0x3fffff;
+	dev_dbg(&priv->i2c->dev, "%s: if_frequency=%d pset_iffreq=%08x\n",
+			__func__, if_freq, (unsigned)pset_iffreq);
+
 	ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
 	if (ret)
 		return ret;
-- 
1.8.1.4

