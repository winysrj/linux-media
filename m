Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511CX0016403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 45/47] [media] mt2063: Add it to the building system
Date: Wed,  4 Jan 2012 23:00:56 -0200
Message-Id: <1325725258-27934-46-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/Kconfig  |    7 +++++++
 drivers/media/common/tuners/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 996302a..ab8856d 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -116,6 +116,13 @@ config MEDIA_TUNER_MT2060
 	help
 	  A driver for the silicon IF tuner MT2060 from Microtune.
 
+config MEDIA_TUNER_MT2063
+	tristate "Microtune MT2063 silicon IF tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  A driver for the silicon IF tuner MT2063 from Microtune.
+
 config MEDIA_TUNER_MT2266
 	tristate "Microtune MT2266 silicon tuner"
 	depends on VIDEO_MEDIA && I2C
diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index 196c12a..8295854 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MEDIA_TUNER_TDA18271) += tda18271.o
 obj-$(CONFIG_MEDIA_TUNER_XC5000) += xc5000.o
 obj-$(CONFIG_MEDIA_TUNER_XC4000) += xc4000.o
 obj-$(CONFIG_MEDIA_TUNER_MT2060) += mt2060.o
+obj-$(CONFIG_MEDIA_TUNER_MT2063) += mt2063.o
 obj-$(CONFIG_MEDIA_TUNER_MT2266) += mt2266.o
 obj-$(CONFIG_MEDIA_TUNER_QT1010) += qt1010.o
 obj-$(CONFIG_MEDIA_TUNER_MT2131) += mt2131.o
-- 
1.7.7.5

