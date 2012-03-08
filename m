Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33623 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2CHTlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 14:41:18 -0500
Received: by wejx9 with SMTP id x9so572276wej.19
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2012 11:41:16 -0800 (PST)
Message-ID: <1331235668.6783.1.camel@tvbox>
Subject: [PATCH] lmedm04 - support for m88rs2000 missing kconfig option.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Thu, 08 Mar 2012 19:41:08 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 6154292..63bf456 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -386,6 +386,7 @@ config DVB_USB_LME2510
 	select DVB_IX2505V if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_PLL if !DVB_FE_CUSTOMISE
+	select DVB_M88RS2000 if !DVB_FE_CUSTOMISE
 	help
 	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .
 
-- 
1.7.9


