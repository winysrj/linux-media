Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab2AUQEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:46 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4kT3021391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 34/35] [media] az6007: Enable the driver at the building system
Date: Sat, 21 Jan 2012 14:04:36 -0200
Message-Id: <1327161877-16784-35-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-34-git-send-email-mchehab@redhat.com>
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
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
 <1327161877-16784-22-git-send-email-mchehab@redhat.com>
 <1327161877-16784-23-git-send-email-mchehab@redhat.com>
 <1327161877-16784-24-git-send-email-mchehab@redhat.com>
 <1327161877-16784-25-git-send-email-mchehab@redhat.com>
 <1327161877-16784-26-git-send-email-mchehab@redhat.com>
 <1327161877-16784-27-git-send-email-mchehab@redhat.com>
 <1327161877-16784-28-git-send-email-mchehab@redhat.com>
 <1327161877-16784-29-git-send-email-mchehab@redhat.com>
 <1327161877-16784-30-git-send-email-mchehab@redhat.com>
 <1327161877-16784-31-git-send-email-mchehab@redhat.com>
 <1327161877-16784-32-git-send-email-mchehab@redhat.com>
 <1327161877-16784-33-git-send-email-mchehab@redhat.com>
 <1327161877-16784-34-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the corresponding entries to allow building this driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/Kconfig  |    8 ++++++++
 drivers/media/dvb/dvb-usb/Makefile |    4 +++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 9f203c6..e894bad 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -361,6 +361,14 @@ config DVB_USB_EC168
 	help
 	  Say Y here to support the E3C EC168 DVB-T USB2.0 receiver.
 
+config DVB_USB_AZ6007
+	tristate "AzureWave 6007 and clones DVB-T/C USB2.0 support"
+	depends on DVB_USB
+	select DVB_DRXK if !DVB_FE_CUSTOMISE
+	select MEDIA_TUNER_MT2063 if !DVB_FE_CUSTOMISE
+	help
+	  Say Y here to support theAfatech AF9005 based DVB-T/DVB-C receivers.
+
 config DVB_USB_AZ6027
 	tristate "Azurewave DVB-S/S2 USB2.0 AZ6027 support"
 	depends on DVB_USB
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 26c8b9e..d9549cb 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -54,7 +54,6 @@ obj-$(CONFIG_DVB_USB_DIB0700) += dvb-usb-dib0700.o
 dvb-usb-opera-objs = opera1.o
 obj-$(CONFIG_DVB_USB_OPERA1) += dvb-usb-opera.o
 
-
 dvb-usb-af9005-objs = af9005.o af9005-fe.o
 obj-$(CONFIG_DVB_USB_AF9005) += dvb-usb-af9005.o
 
@@ -88,6 +87,9 @@ obj-$(CONFIG_DVB_USB_FRIIO) += dvb-usb-friio.o
 dvb-usb-ec168-objs = ec168.o
 obj-$(CONFIG_DVB_USB_EC168) += dvb-usb-ec168.o
 
+dvb-usb-az6007-objs = az6007.o
+obj-$(CONFIG_DVB_USB_AZ6007) += dvb-usb-az6007.o
+
 dvb-usb-az6027-objs = az6027.o
 obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
 
-- 
1.7.8

