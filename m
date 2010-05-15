Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab0EOQqU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 12:46:20 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1273941831.2564.29.camel@localhost>
References: <1273941831.2564.29.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 15 May 2010 17:46:16 +0100
Message-ID: <1273941976.2564.33.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 4/4] V4L/DVB: m920x: Select simple tuner
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the Kconfig selections to match the code.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/dvb-usb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 73a6e9d..553b48a 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -135,6 +135,7 @@ config DVB_USB_M920X
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the MSI Mega Sky 580 USB2.0 DVB-T receiver.
 	  Currently, only devices with a product id of
-- 
1.7.1


