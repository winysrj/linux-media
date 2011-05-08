Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:39630 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1EHPvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 11:51:37 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH 2/6] cxd2820r: Remove temporary T2 API hack
Date: Sun,  8 May 2011 16:51:09 +0100
Message-Id: <1304869873-9974-3-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC417DA.5030107@redhat.com>
References: <4DC417DA.5030107@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Unimplemented delivery system and modes were #define'd to
arbitrary values for internal use. API now includes these values
so we can remove this hack.

Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
---
 drivers/media/dvb/frontends/cxd2820r_priv.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
index d4e2e0b..25adbee 100644
--- a/drivers/media/dvb/frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
@@ -40,18 +40,6 @@
 #undef warn
 #define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
 
-/*
- * FIXME: These are totally wrong and must be added properly to the API.
- * Only temporary solution in order to get driver compile.
- */
-#define SYS_DVBT2             SYS_DAB
-#define TRANSMISSION_MODE_1K  0
-#define TRANSMISSION_MODE_16K 0
-#define TRANSMISSION_MODE_32K 0
-#define GUARD_INTERVAL_1_128  0
-#define GUARD_INTERVAL_19_128 0
-#define GUARD_INTERVAL_19_256 0
-
 struct reg_val_mask {
 	u32 reg;
 	u8  val;
-- 
1.7.1

