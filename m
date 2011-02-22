Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42498 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1BVGOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 01:14:42 -0500
Received: by wwa36 with SMTP id 36so6901493wwa.1
        for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 22:14:41 -0800 (PST)
Subject: [PATCH] Missing frontend config for LME DM04/QQBOX
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 06:14:34 +0000
Message-ID: <1298355274.25042.1.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Forgot to add the DVB_STV0299/DVB_PLL to config

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 3d48ba0..83043e8 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -356,5 +356,7 @@ config DVB_USB_LME2510
 	select DVB_TDA826X if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
 	select DVB_IX2505V if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+	select DVB_PLL if !DVB_FE_CUSTOMISE
 	help
 	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .
-- 
1.7.1

