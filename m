Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:51698 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0BBHQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 02:16:52 -0500
Received: by pxi12 with SMTP id 12so5440085pxi.33
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 23:16:52 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH v2 09/10] modify the Kconfig and Makefile for tlg2300
Date: Tue,  2 Feb 2010 15:07:55 +0800
Message-Id: <1265094475-13059-10-git-send-email-shijie8@gmail.com>
In-Reply-To: <1265094475-13059-9-git-send-email-shijie8@gmail.com>
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
 <1265094475-13059-2-git-send-email-shijie8@gmail.com>
 <1265094475-13059-3-git-send-email-shijie8@gmail.com>
 <1265094475-13059-4-git-send-email-shijie8@gmail.com>
 <1265094475-13059-5-git-send-email-shijie8@gmail.com>
 <1265094475-13059-6-git-send-email-shijie8@gmail.com>
 <1265094475-13059-7-git-send-email-shijie8@gmail.com>
 <1265094475-13059-8-git-send-email-shijie8@gmail.com>
 <1265094475-13059-9-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add the items for tlg2300 in the two files.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/video/Kconfig  |    2 ++
 drivers/media/video/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 2f83be7..9bd88b4 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -944,6 +944,8 @@ source "drivers/media/video/hdpvr/Kconfig"
 
 source "drivers/media/video/em28xx/Kconfig"
 
+source "drivers/media/video/tlg2300/Kconfig"
+
 source "drivers/media/video/cx231xx/Kconfig"
 
 source "drivers/media/video/usbvision/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2af68ee..5163289 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_VIDEO_MEYE) += meye.o
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_CX88) += cx88/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
+obj-$(CONFIG_VIDEO_TLG2300) += tlg2300/
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
-- 
1.6.5.2

