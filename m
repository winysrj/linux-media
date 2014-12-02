Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51587 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbaLBPlM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 10:41:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 2/3] tlg2300: move to staging in preparation for removal
Date: Tue,  2 Dec 2014 16:40:32 +0100
Message-Id: <1417534833-46844-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
References: <1417534833-46844-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver hasn't been tested in a long, long time. The company that made
this chip has gone bust many years ago and hardware using this chip is next
to impossible to find.

This driver needs to be converted to newer media frameworks but due to the
lack of hardware that's going to be impossible. Since cheap alternatives are
easily available, there is little point in keeping this driver alive.

In other words, this driver is a prime candidate for removal. If someone is
interested in working on this driver to prevent its removal, then please
contact the linux-media mailinglist.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/usb/Kconfig                                 | 1 -
 drivers/media/usb/Makefile                                | 1 -
 drivers/staging/media/Kconfig                             | 2 ++
 drivers/staging/media/Makefile                            | 1 +
 drivers/{media/usb => staging/media}/tlg2300/Kconfig      | 6 +++++-
 drivers/{media/usb => staging/media}/tlg2300/Makefile     | 0
 drivers/{media/usb => staging/media}/tlg2300/pd-alsa.c    | 0
 drivers/{media/usb => staging/media}/tlg2300/pd-common.h  | 0
 drivers/{media/usb => staging/media}/tlg2300/pd-dvb.c     | 0
 drivers/{media/usb => staging/media}/tlg2300/pd-main.c    | 0
 drivers/{media/usb => staging/media}/tlg2300/pd-radio.c   | 0
 drivers/{media/usb => staging/media}/tlg2300/pd-video.c   | 0
 drivers/{media/usb => staging/media}/tlg2300/vendorcmds.h | 0
 13 files changed, 8 insertions(+), 3 deletions(-)
 rename drivers/{media/usb => staging/media}/tlg2300/Kconfig (63%)
 rename drivers/{media/usb => staging/media}/tlg2300/Makefile (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-alsa.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-common.h (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-dvb.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-main.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-radio.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/pd-video.c (100%)
 rename drivers/{media/usb => staging/media}/tlg2300/vendorcmds.h (100%)

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 056181f..7496f33 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -24,7 +24,6 @@ if MEDIA_ANALOG_TV_SUPPORT
 	comment "Analog TV USB devices"
 source "drivers/media/usb/pvrusb2/Kconfig"
 source "drivers/media/usb/hdpvr/Kconfig"
-source "drivers/media/usb/tlg2300/Kconfig"
 source "drivers/media/usb/usbvision/Kconfig"
 source "drivers/media/usb/stk1160/Kconfig"
 source "drivers/media/usb/go7007/Kconfig"
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 6f2eb7c..8874ba7 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
-obj-$(CONFIG_VIDEO_TLG2300) += tlg2300/
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
 obj-$(CONFIG_VIDEO_STK1160) += stk1160/
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 6dce44e..209b265 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -27,6 +27,8 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/dt3155v4l/Kconfig"
 
+source "drivers/staging/media/tlg2300/Kconfig"
+
 source "drivers/staging/media/mn88472/Kconfig"
 
 source "drivers/staging/media/mn88473/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 7b713e7..a0eec73 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -6,5 +6,6 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
 obj-$(CONFIG_DVB_MN88473)       += mn88473/
+obj-$(CONFIG_VIDEO_TLG2300)	+= tlg2300/
 obj-y                           += vino/
 
diff --git a/drivers/media/usb/tlg2300/Kconfig b/drivers/staging/media/tlg2300/Kconfig
similarity index 63%
rename from drivers/media/usb/tlg2300/Kconfig
rename to drivers/staging/media/tlg2300/Kconfig
index 645d915..81784c6 100644
--- a/drivers/media/usb/tlg2300/Kconfig
+++ b/drivers/staging/media/tlg2300/Kconfig
@@ -1,5 +1,5 @@
 config VIDEO_TLG2300
-	tristate "Telegent TLG2300 USB video capture support"
+	tristate "Telegent TLG2300 USB video capture support (Deprecated)"
 	depends on VIDEO_DEV && I2C && SND && DVB_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
@@ -12,5 +12,9 @@ config VIDEO_TLG2300
 	  This is a video4linux driver for Telegent tlg2300 based TV cards.
 	  The driver supports V4L2, DVB-T and radio.
 
+	  This driver is deprecated and will be removed soon. If you have
+	  hardware for this and you want to work on this driver, then contact
+	  the linux-media mailinglist.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called poseidon
diff --git a/drivers/media/usb/tlg2300/Makefile b/drivers/staging/media/tlg2300/Makefile
similarity index 100%
rename from drivers/media/usb/tlg2300/Makefile
rename to drivers/staging/media/tlg2300/Makefile
diff --git a/drivers/media/usb/tlg2300/pd-alsa.c b/drivers/staging/media/tlg2300/pd-alsa.c
similarity index 100%
rename from drivers/media/usb/tlg2300/pd-alsa.c
rename to drivers/staging/media/tlg2300/pd-alsa.c
diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/staging/media/tlg2300/pd-common.h
similarity index 100%
rename from drivers/media/usb/tlg2300/pd-common.h
rename to drivers/staging/media/tlg2300/pd-common.h
diff --git a/drivers/media/usb/tlg2300/pd-dvb.c b/drivers/staging/media/tlg2300/pd-dvb.c
similarity index 100%
rename from drivers/media/usb/tlg2300/pd-dvb.c
rename to drivers/staging/media/tlg2300/pd-dvb.c
diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/staging/media/tlg2300/pd-main.c
similarity index 100%
rename from drivers/media/usb/tlg2300/pd-main.c
rename to drivers/staging/media/tlg2300/pd-main.c
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/staging/media/tlg2300/pd-radio.c
similarity index 100%
rename from drivers/media/usb/tlg2300/pd-radio.c
rename to drivers/staging/media/tlg2300/pd-radio.c
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/staging/media/tlg2300/pd-video.c
similarity index 100%
rename from drivers/media/usb/tlg2300/pd-video.c
rename to drivers/staging/media/tlg2300/pd-video.c
diff --git a/drivers/media/usb/tlg2300/vendorcmds.h b/drivers/staging/media/tlg2300/vendorcmds.h
similarity index 100%
rename from drivers/media/usb/tlg2300/vendorcmds.h
rename to drivers/staging/media/tlg2300/vendorcmds.h
-- 
2.1.3

