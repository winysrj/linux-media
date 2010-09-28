Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab0I1Szj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:55:39 -0400
Date: Tue, 28 Sep 2010 15:47:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/10] V4L/DVB: tda18271: Add debug message with frequency
 divisor
Message-ID: <20100928154700.59362453@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
index 195b30e..7ba3ba3 100644
--- a/drivers/media/common/tuners/tda18271-common.c
+++ b/drivers/media/common/tuners/tda18271-common.c
@@ -549,6 +549,13 @@ int tda18271_calc_main_pll(struct dvb_frontend *fe, u32 freq)
 	regs[R_MD1]   = 0x7f & (div >> 16);
 	regs[R_MD2]   = 0xff & (div >> 8);
 	regs[R_MD3]   = 0xff & div;
+
+	if (tda18271_debug & DBG_REG) {
+		tda_reg("MAIN_DIV_BYTE_1    = 0x%02x\n", 0xff & regs[R_MD1]);
+		tda_reg("MAIN_DIV_BYTE_2    = 0x%02x\n", 0xff & regs[R_MD2]);
+		tda_reg("MAIN_DIV_BYTE_3    = 0x%02x\n", 0xff & regs[R_MD3]);
+	}
+
 fail:
 	return ret;
 }
-- 
1.7.1


