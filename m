Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:38341 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab0BBHON (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 02:14:13 -0500
Received: by pzk28 with SMTP id 28so5089681pzk.4
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 23:14:12 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH v2 08/10] add Kconfig and Makefile for tlg2300
Date: Tue,  2 Feb 2010 15:07:54 +0800
Message-Id: <1265094475-13059-9-git-send-email-shijie8@gmail.com>
In-Reply-To: <1265094475-13059-8-git-send-email-shijie8@gmail.com>
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
 <1265094475-13059-2-git-send-email-shijie8@gmail.com>
 <1265094475-13059-3-git-send-email-shijie8@gmail.com>
 <1265094475-13059-4-git-send-email-shijie8@gmail.com>
 <1265094475-13059-5-git-send-email-shijie8@gmail.com>
 <1265094475-13059-6-git-send-email-shijie8@gmail.com>
 <1265094475-13059-7-git-send-email-shijie8@gmail.com>
 <1265094475-13059-8-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add Kconfig and Makefile for tlg2300 driver.

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
index 0000000..81bb7fd
--- /dev/null
+++ b/drivers/media/video/tlg2300/Makefile
@@ -0,0 +1,9 @@
+poseidon-objs := pd-video.o pd-alsa.o pd-dvb.o pd-radio.o pd-main.o
+
+obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
+
+EXTRA_CFLAGS += -Idrivers/media/video
+EXTRA_CFLAGS += -Idrivers/media/common/tuners
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+
-- 
1.6.5.2

