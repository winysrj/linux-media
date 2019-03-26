Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C924C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 09:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECCAC20856
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 09:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfCZJ1e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:27:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:10352 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfCZJ1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 05:27:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 02:27:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="158461950"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2019 02:27:32 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 5B40F200E2;
        Tue, 26 Mar 2019 11:27:31 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1h8iMK-0002qz-Sg; Tue, 26 Mar 2019 11:27:05 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/1] soc_camera: Remove leftover files, add TODO
Date:   Tue, 26 Mar 2019 11:27:04 +0200
Message-Id: <20190326092704.10930-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove a few files left over from the mt9t031 driver. While at it, add a
TODO file for the SoC camera framework as a whole.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/mt9t031/Kconfig  | 5 -----
 drivers/staging/media/mt9t031/Makefile | 1 -
 drivers/staging/media/mt9t031/TODO     | 5 -----
 drivers/staging/media/soc_camera/TODO  | 4 ++++
 4 files changed, 4 insertions(+), 11 deletions(-)
 delete mode 100644 drivers/staging/media/mt9t031/Kconfig
 delete mode 100644 drivers/staging/media/mt9t031/Makefile
 delete mode 100644 drivers/staging/media/mt9t031/TODO
 create mode 100644 drivers/staging/media/soc_camera/TODO

diff --git a/drivers/staging/media/mt9t031/Kconfig b/drivers/staging/media/mt9t031/Kconfig
deleted file mode 100644
index 9a58aaf72edd6..0000000000000
--- a/drivers/staging/media/mt9t031/Kconfig
+++ /dev/null
@@ -1,5 +0,0 @@
-config SOC_CAMERA_MT9T031
-	tristate "mt9t031 support (DEPRECATED)"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports MT9T031 cameras from Micron.
diff --git a/drivers/staging/media/mt9t031/Makefile b/drivers/staging/media/mt9t031/Makefile
deleted file mode 100644
index bfd24c442b338..0000000000000
--- a/drivers/staging/media/mt9t031/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_SOC_CAMERA_MT9T031)		+= mt9t031.o
diff --git a/drivers/staging/media/mt9t031/TODO b/drivers/staging/media/mt9t031/TODO
deleted file mode 100644
index 15580a4f950c5..0000000000000
--- a/drivers/staging/media/mt9t031/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-This sensor driver needs to be converted to a regular
-v4l2 subdev driver. The soc_camera framework is deprecated and
-will be removed in the future. Unless someone does this work this
-sensor driver will be deleted when the soc_camera framework is
-deleted.
diff --git a/drivers/staging/media/soc_camera/TODO b/drivers/staging/media/soc_camera/TODO
new file mode 100644
index 0000000000000..932af6443b671
--- /dev/null
+++ b/drivers/staging/media/soc_camera/TODO
@@ -0,0 +1,4 @@
+The SoC camera framework is obsolete and scheduled for removal in the near
+future. Developers are encouraged to convert the drivers to use the
+regular V4L2 API if these drivers are still needed (and if someone has the
+hardware).
-- 
2.11.0

