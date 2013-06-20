Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030360Ab3FTOLi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 10:11:38 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5KEBb43017042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 10:11:37 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] s5p makefiles: don't override other selections on obj-[ym]
Date: Thu, 20 Jun 2013 11:11:27 -0300
Message-Id: <1371737488-14395-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1371737488-14395-1-git-send-email-mchehab@redhat.com>
References: <1371737488-14395-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The $obj-m/$obj-y vars should be adding new modules to build, not
overriding it. So, it should never use
	$obj-y := foo.o
instead, it should use:
	$obj-y += foo.o

Failing to do that is very bad, as it will suppress needed modules.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/s5p-jpeg/Makefile | 2 +-
 drivers/media/platform/s5p-mfc/Makefile  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/Makefile b/drivers/media/platform/s5p-jpeg/Makefile
index ddc2900..d18cb5e 100644
--- a/drivers/media/platform/s5p-jpeg/Makefile
+++ b/drivers/media/platform/s5p-jpeg/Makefile
@@ -1,2 +1,2 @@
 s5p-jpeg-objs := jpeg-core.o
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) := s5p-jpeg.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) += s5p-jpeg.o
diff --git a/drivers/media/platform/s5p-mfc/Makefile b/drivers/media/platform/s5p-mfc/Makefile
index 379008c..15f59b3 100644
--- a/drivers/media/platform/s5p-mfc/Makefile
+++ b/drivers/media/platform/s5p-mfc/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) += s5p-mfc.o
 s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o
 s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
 s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_pm.o
-- 
1.8.1.4

