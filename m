Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:57740 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab3CKPbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 11:31:42 -0400
Message-ID: <1363015899.3137.91.camel@x61.thuisdomein>
Subject: [PATCH] [media] ts2020: use customise option correctly
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 16:31:39 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Kconfig entry for "TS2020 based tuners" defaults to modular if
DVB_FE_CUSTOMISE is set. But that Kconfig symbol was replaced with
MEDIA_SUBDRV_AUTOSELECT as of v3.7. So use the new symbol. And negate
the logic, so we are in line with all the similar entries in this file.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

 drivers/media/dvb-frontends/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 6f809a7..0e2ec6f 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -210,7 +210,7 @@ config DVB_SI21XX
 config DVB_TS2020
 	tristate "Montage Tehnology TS2020 based tuners"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-S/S2 silicon tuner. Say Y when you want to support this tuner.
 
-- 
1.7.11.7

