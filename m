Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38554 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab0EOQqD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 12:46:03 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1273941831.2564.29.camel@localhost>
References: <1273941831.2564.29.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 15 May 2010 17:45:58 +0100
Message-ID: <1273941958.2564.32.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 3/4] V4L/DVB: dib0700: Select dib0090 frontend
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the Kconfig selections to match the code.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/dvb-usb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index cfcbf4f..73a6e9d 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -76,6 +76,7 @@ config DVB_USB_DIB0700
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT3305 if !DVB_FE_CUSTOMISE
 	select DVB_TUNER_DIB0070 if !DVB_FE_CUSTOMISE
+	select DVB_TUNER_DIB0090 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT2266 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
-- 
1.7.1



