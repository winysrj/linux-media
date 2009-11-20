Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58615 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbZKTDZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 22:25:01 -0500
Received: by mail-yw0-f202.google.com with SMTP id 40so1937121ywh.33
        for <linux-media@vger.kernel.org>; Thu, 19 Nov 2009 19:25:07 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 04/11] add Kconfig and Makefile for tlg2300
Date: Fri, 20 Nov 2009 11:24:46 +0800
Message-Id: <1258687493-4012-5-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-4-git-send-email-shijie8@gmail.com>
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
 <1258687493-4012-2-git-send-email-shijie8@gmail.com>
 <1258687493-4012-3-git-send-email-shijie8@gmail.com>
 <1258687493-4012-4-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add Kconfig and Makefile for tlg2300.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/video/tlg2300/Kconfig  |   16 ++++++++++++++++
 drivers/media/video/tlg2300/Makefile |    9 +++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/tlg2300/Kconfig
 create mode 100644 drivers/media/video/tlg2300/Makefile

diff --git a/drivers/media/video/tlg2300/Kconfig b/drivers/media/video/tlg2300/Kconfig
new file mode 100644
index 0000000..2c29ec6
--- /dev/null
+++ b/drivers/media/video/tlg2300/Kconfig
@@ -0,0 +1,16 @@
+config VIDEO_TLG2300
+	tristate "Telegent TLG2300 USB video capture support"
+	depends on VIDEO_DEV && I2C && INPUT && SND && DVB_CORE
+	select VIDEO_TUNER
+	select VIDEO_TVEEPROM
+	select VIDEO_IR
+	select VIDEOBUF_VMALLOC
+	select SND_PCM
+	select VIDEOBUF_DVB
+
+	---help---
+	  This is a video4linux driver for Telegent tlg2300 based TV cards.
+	  The driver supports V4L2, DVB-T and radio.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called poseidon
diff --git a/drivers/media/video/tlg2300/Makefile b/drivers/media/video/tlg2300/Makefile
new file mode 100644
index 0000000..558c1ad
--- /dev/null
+++ b/drivers/media/video/tlg2300/Makefile
@@ -0,0 +1,9 @@
+poseidon-objs := pd-bufqueue.o pd-video.o pd-alsa.o pd-dvb.o pd-vbi.o pd-radio.o pd-main.o
+
+obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
+
+EXTRA_CFLAGS += -Idrivers/media/video
+EXTRA_CFLAGS += -Idrivers/media/common/tuners
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+
-- 
1.6.0.6

