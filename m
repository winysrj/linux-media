Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59609 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752289AbeDHVTr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Apr 2018 17:19:47 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Cc: Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v2 2/7] media: rc: add ioctl to get the current timeout
Date: Sun,  8 Apr 2018 22:19:37 +0100
Message-Id: <d2f593f1e78429702036c0a7647c5057d979b7af.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the kernel now modifies the timeout, make it possible to retrieve
the current value.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-func.rst            |  1 +
 Documentation/media/uapi/rc/lirc-set-rec-timeout.rst | 14 +++++++++-----
 drivers/media/rc/lirc_dev.c                          |  7 +++++++
 include/uapi/linux/lirc.h                            |  6 ++++++
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/media/uapi/rc/lirc-func.rst
index ddb4620de294..9656423a3f28 100644
--- a/Documentation/media/uapi/rc/lirc-func.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -17,6 +17,7 @@ LIRC Function Reference
     lirc-get-rec-resolution
     lirc-set-send-duty-cycle
     lirc-get-timeout
+    lirc-get-rec-timeout
     lirc-set-rec-timeout
     lirc-set-rec-carrier
     lirc-set-rec-carrier-range
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
index b3e16bbdbc90..a833a6a4c25a 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
@@ -1,19 +1,23 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _lirc_set_rec_timeout:
+.. _lirc_get_rec_timeout:
 
-**************************
-ioctl LIRC_SET_REC_TIMEOUT
-**************************
+***************************************************
+ioctl LIRC_GET_REC_TIMEOUT and LIRC_SET_REC_TIMEOUT
+***************************************************
 
 Name
 ====
 
-LIRC_SET_REC_TIMEOUT - sets the integer value for IR inactivity timeout.
+LIRC_GET_REC_TIMEOUT/LIRC_SET_REC_TIMEOUT - Get/set the integer value for IR inactivity timeout.
 
 Synopsis
 ========
 
+.. c:function:: int ioctl( int fd, LIRC_GET_REC_TIMEOUT, __u32 *timeout )
+    :name: LIRC_GET_REC_TIMEOUT
+
 .. c:function:: int ioctl( int fd, LIRC_SET_REC_TIMEOUT, __u32 *timeout )
     :name: LIRC_SET_REC_TIMEOUT
 
@@ -30,7 +34,7 @@ Arguments
 Description
 ===========
 
-Sets the integer value for IR inactivity timeout.
+Get and set the integer value for IR inactivity timeout.
 
 If supported by the hardware, setting it to 0  disables all hardware timeouts
 and data should be reported as soon as possible. If the exact value
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 247e6fc3dc0c..6b4755e9fa25 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -575,6 +575,13 @@ static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 		}
 		break;
 
+	case LIRC_GET_REC_TIMEOUT:
+		if (!dev->timeout)
+			ret = -ENOTTY;
+		else
+			val = DIV_ROUND_UP(dev->timeout, 1000);
+		break;
+
 	case LIRC_SET_REC_TIMEOUT_REPORTS:
 		if (!dev->timeout)
 			ret = -ENOTTY;
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index f189931042a7..6b319581882f 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -133,6 +133,12 @@
 
 #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
 
+/*
+ * Return the recording timeout, which is either set by
+ * the ioctl LIRC_SET_REC_TIMEOUT or by the kernel after setting the protocols.
+ */
+#define LIRC_GET_REC_TIMEOUT	       _IOR('i', 0x00000024, __u32)
+
 /*
  * struct lirc_scancode - decoded scancode with protocol for use with
  *	LIRC_MODE_SCANCODE
-- 
2.14.3
