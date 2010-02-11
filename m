Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59040 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875Ab0BKC5Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 21:57:25 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "David T.L. Wong" <davidtlwong@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Feb 2010 02:57:17 +0000
Message-ID: <1265857037.2227.8.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] cxusb: Select all required frontend and tuner modules
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cxusb uses the atbm8830 and lgs8gxx (not lgs8gl5) frontends and the
max2165 tuner, so it needs to select them.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org
---
 drivers/media/dvb/dvb-usb/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 1b24989..465295b 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -112,11 +112,13 @@ config DVB_USB_CXUSB
 	select DVB_MT352 if !DVB_FE_CUSTOMISE
 	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
-	select DVB_LGS8GL5 if !DVB_FE_CUSTOMISE
 	select DVB_TUNER_DIB0070 if !DVB_FE_CUSTOMISE
+	select DVB_ATBM8830 if !DVB_FE_CUSTOMISE
+	select DVB_LGS8GXX if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MAX2165 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Conexant USB2.0 hybrid reference design.
 	  Currently, only DVB and ATSC modes are supported, analog mode
-- 
1.6.6


