Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab2FNUi4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:56 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKctSw017497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 09/10] [media] saa7146: Move it to its own directory
Date: Thu, 14 Jun 2012 17:36:00 -0300
Message-Id: <1339706161-22713-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to better organize the directory tree, move the
saa7146 common driver to its own directory.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/Kconfig                       |   11 +----------
 drivers/media/common/Makefile                      |    7 +------
 drivers/media/common/saa7146/Kconfig               |    9 +++++++++
 drivers/media/common/saa7146/Makefile              |    5 +++++
 drivers/media/common/{ => saa7146}/saa7146_core.c  |    0
 drivers/media/common/{ => saa7146}/saa7146_fops.c  |    0
 drivers/media/common/{ => saa7146}/saa7146_hlp.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_i2c.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_vbi.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_video.c |    0
 10 files changed, 16 insertions(+), 16 deletions(-)
 create mode 100644 drivers/media/common/saa7146/Kconfig
 create mode 100644 drivers/media/common/saa7146/Makefile
 rename drivers/media/common/{ => saa7146}/saa7146_core.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_fops.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_hlp.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_i2c.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_vbi.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_video.c (100%)

diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index 4672f7d..157f191 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -1,11 +1,2 @@
-config VIDEO_SAA7146
-	tristate
-	depends on I2C && PCI
-
-config VIDEO_SAA7146_VV
-	tristate
-	depends on VIDEO_V4L2
-	select VIDEOBUF_DMA_SG
-	select VIDEO_SAA7146
-
 source "drivers/media/common/b2c2/Kconfig"
+source "drivers/media/common/saa7146/Kconfig"
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index a471242..f3afd83 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -1,6 +1 @@
-saa7146-objs    := saa7146_i2c.o saa7146_core.o
-saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
-
-obj-y += b2c2/
-obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
-obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
+obj-y += b2c2/ saa7146/
diff --git a/drivers/media/common/saa7146/Kconfig b/drivers/media/common/saa7146/Kconfig
new file mode 100644
index 0000000..769c6f8
--- /dev/null
+++ b/drivers/media/common/saa7146/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_SAA7146
+	tristate
+	depends on I2C && PCI
+
+config VIDEO_SAA7146_VV
+	tristate
+	depends on VIDEO_V4L2
+	select VIDEOBUF_DMA_SG
+	select VIDEO_SAA7146
diff --git a/drivers/media/common/saa7146/Makefile b/drivers/media/common/saa7146/Makefile
new file mode 100644
index 0000000..3219b00
--- /dev/null
+++ b/drivers/media/common/saa7146/Makefile
@@ -0,0 +1,5 @@
+saa7146-objs    := saa7146_i2c.o saa7146_core.o
+saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
+
+obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
+obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
similarity index 100%
rename from drivers/media/common/saa7146_core.c
rename to drivers/media/common/saa7146/saa7146_core.c
diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
similarity index 100%
rename from drivers/media/common/saa7146_fops.c
rename to drivers/media/common/saa7146/saa7146_fops.c
diff --git a/drivers/media/common/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
similarity index 100%
rename from drivers/media/common/saa7146_hlp.c
rename to drivers/media/common/saa7146/saa7146_hlp.c
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146/saa7146_i2c.c
similarity index 100%
rename from drivers/media/common/saa7146_i2c.c
rename to drivers/media/common/saa7146/saa7146_i2c.c
diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
similarity index 100%
rename from drivers/media/common/saa7146_vbi.c
rename to drivers/media/common/saa7146/saa7146_vbi.c
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
similarity index 100%
rename from drivers/media/common/saa7146_video.c
rename to drivers/media/common/saa7146/saa7146_video.c
-- 
1.7.10.2

