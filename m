Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38538 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab0EOQpY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 12:45:24 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1273941831.2564.29.camel@localhost>
References: <1273941831.2564.29.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 15 May 2010 17:45:21 +0100
Message-ID: <1273941921.2564.30.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 1/4] V4L/DVB: dw2102: Select tda10023 frontend, not tda10021
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the Kconfig selections to match the code.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/dvb-usb/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index e5f91f1..cfcbf4f 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -264,7 +264,7 @@ config DVB_USB_DW2102
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
-	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
+	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select DVB_MT312 if !DVB_FE_CUSTOMISE
 	select DVB_ZL10039 if !DVB_FE_CUSTOMISE
 	select DVB_DS3000 if !DVB_FE_CUSTOMISE
-- 
1.7.1



