Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58615 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbZKTDYy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 22:24:54 -0500
Received: by mail-yw0-f202.google.com with SMTP id 40so1937121ywh.33
        for <linux-media@vger.kernel.org>; Thu, 19 Nov 2009 19:25:00 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, root <root@localhost.localdomain>,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 01/11] modify video's Kconfig and Makefile for tlg2300
Date: Fri, 20 Nov 2009 11:24:43 +0800
Message-Id: <1258687493-4012-2-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: root <root@localhost.localdomain>

modify the two files for tlg2300.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/video/Kconfig  |    2 ++
 drivers/media/video/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index dcf9fa9..52352d8 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -837,6 +837,8 @@ source "drivers/media/video/hdpvr/Kconfig"
 
 source "drivers/media/video/em28xx/Kconfig"
 
+source "drivers/media/video/tlg2300/Kconfig"
+
 source "drivers/media/video/cx231xx/Kconfig"
 
 source "drivers/media/video/usbvision/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 9f2e321..f349ce4 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_VIDEO_MEYE) += meye.o
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_CX88) += cx88/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
+obj-$(CONFIG_VIDEO_TLG2300) += tlg2300/
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
-- 
1.6.0.6

