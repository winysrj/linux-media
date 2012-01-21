Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4hf7023677
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/35] [media] az6007: move device PID's to the proper place
Date: Sat, 21 Jan 2012 14:04:12 -0200
Message-Id: <1327161877-16784-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-10-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c      |    4 ----
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    2 ++
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index f946b1b..780a480 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -27,10 +27,6 @@
 
 #define DVB_USB_LOG_PREFIX "az6007"
 
-/* HACK: Should be moved to the right place */
-#define USB_PID_AZUREWAVE_6007		0x0ccd
-#define USB_PID_TERRATEC_H7		0x10b4
-
 /* debug */
 int dvb_usb_az6007_debug;
 module_param_named(debug, dvb_usb_az6007_debug, int, 0644);
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index d390dda..b3e7be4 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -80,6 +80,7 @@
 #define USB_PID_ANSONIC_DVBT_USB			0x6000
 #define USB_PID_ANYSEE					0x861f
 #define USB_PID_AZUREWAVE_AD_TU700			0x3237
+#define USB_PID_AZUREWAVE_6007				0x0ccd
 #define USB_PID_AVERMEDIA_DVBT_USB_COLD			0x0001
 #define USB_PID_AVERMEDIA_DVBT_USB_WARM			0x0002
 #define USB_PID_AVERMEDIA_DVBT_USB2_COLD		0xa800
@@ -226,6 +227,7 @@
 #define USB_PID_TERRATEC_CINERGY_T_EXPRESS		0x0062
 #define USB_PID_TERRATEC_CINERGY_T_XXS			0x0078
 #define USB_PID_TERRATEC_CINERGY_T_XXS_2		0x00ab
+#define USB_PID_TERRATEC_H7				0x10b4
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
-- 
1.7.8

