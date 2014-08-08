Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.195]:60438 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaHHHQj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Aug 2014 03:16:39 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCHv2 2/4] Add USB ID for TechnoTrend TT-connect CT2-4650 CI
Date: Fri,  8 Aug 2014 10:06:36 +0300
Message-Id: <1407481598-24598-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407481598-24598-1-git-send-email-olli.salonen@iki.fi>
References: <1407481598-24598-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 5135a09..b7a9b98 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -244,6 +244,7 @@
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
+#define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI		0x3012
 #define USB_PID_TECHNOTREND_TVSTICK_CT2_4400		0x3014
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
-- 
1.9.1

