Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 25/46] [media] af9005: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:57 -0300
Message-Id: <de01cc96986ff91825f539f65fc4b9e4c7038ca5.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-usb/af9005.c
index af176b6ce738..3f4361e48a32 100644
--- a/drivers/media/usb/dvb-usb/af9005.c
+++ b/drivers/media/usb/dvb-usb/af9005.c
@@ -30,7 +30,7 @@ MODULE_PARM_DESC(debug,
 		 "set debugging level (1=info,xfer=2,rc=4,reg=8,i2c=16,fw=32 (or-able))."
 		 DVB_USB_DEBUG_STATUS);
 /* enable obnoxious led */
-bool dvb_usb_af9005_led = 1;
+bool dvb_usb_af9005_led = true;
 module_param_named(led, dvb_usb_af9005_led, bool, 0644);
 MODULE_PARM_DESC(led, "enable led (default: 1).");
 
-- 
1.9.3

