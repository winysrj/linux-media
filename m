Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:52123 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbcAZOMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:12:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jemma Denson <jdenson@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] [media] b2c2: flexcop: avoid unused function warnings
Date: Tue, 26 Jan 2016 15:09:58 +0100
Message-Id: <1453817424-3080054-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The flexcop driver has two functions that are normally used, except
when multiple frontend drivers are disabled:

drivers/media/common/b2c2/flexcop-fe-tuner.c:42:12: warning: 'flexcop_set_voltage' defined but not used [-Wunused-function]
drivers/media/common/b2c2/flexcop-fe-tuner.c:71:12: warning: 'flexcop_sleep' defined but not used [-Wunused-function]

This avoids the build warning by updating the #ifdef for flexcop_set_voltage
to the exact condition under which it is used. For flexcop_sleep, the
condition is rather complex, so I resort to marking it as __maybe_unused,
so the compiler can silently drop it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/common/b2c2/flexcop-fe-tuner.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
index 9c59f4306883..f5956402fc69 100644
--- a/drivers/media/common/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/common/b2c2/flexcop-fe-tuner.c
@@ -38,7 +38,7 @@ static int flexcop_fe_request_firmware(struct dvb_frontend *fe,
 #endif
 
 /* lnb control */
-#if FE_SUPPORTED(MT312) || FE_SUPPORTED(STV0299)
+#if (FE_SUPPORTED(MT312) || FE_SUPPORTED(STV0299)) && FE_SUPPORTED(PLL)
 static int flexcop_set_voltage(struct dvb_frontend *fe,
 			       enum fe_sec_voltage voltage)
 {
@@ -68,7 +68,7 @@ static int flexcop_set_voltage(struct dvb_frontend *fe,
 #endif
 
 #if FE_SUPPORTED(S5H1420) || FE_SUPPORTED(STV0299) || FE_SUPPORTED(MT312)
-static int flexcop_sleep(struct dvb_frontend* fe)
+static int __maybe_unused flexcop_sleep(struct dvb_frontend* fe)
 {
 	struct flexcop_device *fc = fe->dvb->priv;
 	if (fc->fe_sleep)
-- 
2.7.0

