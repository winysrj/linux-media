Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab2HUXk2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 19:40:28 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7LNeSBN008633
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 19:40:28 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Makefile: Add missing soc_camera/ directory
Date: Tue, 21 Aug 2012 20:40:19 -0300
Message-Id: <1345592419-6447-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/built-in.o: In function `imx074_s_power':
imx074.c:(.text+0x1de93d0): undefined reference to `soc_camera_power_on'
imx074.c:(.text+0x1de93f3): undefined reference to `soc_camera_power_off'
drivers/built-in.o: In function `mt9m001_s_mbus_config':

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 4afb1af..9212777 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -40,6 +40,8 @@ obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
+
 obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
-- 
1.7.11.4

