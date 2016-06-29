Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55710 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbcF2NVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:04 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 15/15] include: lirc: add set length and frequency ioctl options
Date: Wed, 29 Jun 2016 22:20:44 +0900
Message-id: <1467206444-9935-16-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Lirc framework works mainly with receivers, but there is
nothing that prevents us from using it for transmitters as well.

For that we need to have more control on the device frequency to
set (which is a new concept fro LIRC) and we also need to provide
to userspace, as feedback, the values of the used frequency and
length.

Add the LIRC_SET_LENGTH, LIRC_GET_FREQUENCY and
LIRC_SET_FREQUENCY ioctl commands in order to allow the above
mentioned operations.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 include/uapi/linux/lirc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 4b3ab29..94a0d8c 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -106,6 +106,7 @@
 
 /* code length in bits, currently only for LIRC_MODE_LIRCCODE */
 #define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
+#define LIRC_SET_LENGTH                _IOW('i', 0x00000010, __u32)
 
 #define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
 #define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
@@ -165,4 +166,7 @@
 
 #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
 
+#define LIRC_GET_FREQUENCY             _IOR('i', 0x00000024, __u32)
+#define LIRC_SET_FREQUENCY             _IOW('i', 0x00000025, __u32)
+
 #endif
-- 
2.8.1

