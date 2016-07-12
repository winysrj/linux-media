Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299AbcGLMmg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/20] [media] lirc.h: remove several unused ioctls
Date: Tue, 12 Jul 2016 09:41:57 -0300
Message-Id: <d55f09abe24b4dfadab246b6f217da547361cdb6.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While reviewing the documentation gaps on LIRC, it was
noticed that several ioctls aren't used by any LIRC drivers
(nor at staging or mainstream).

It doesn't make sense to document them, as they're not used
anywhere. So, let's remove those from the lirc header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/uapi/linux/lirc.h | 39 ++-------------------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 4b3ab2966b5a..991ab4570b8e 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -90,20 +90,11 @@
 
 #define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
 #define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
-#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
-#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
-#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
-#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, __u32)
 #define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
 
 #define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
 #define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
 
-#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
-#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
-#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
-#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
-
 /* code length in bits, currently only for LIRC_MODE_LIRCCODE */
 #define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
 
@@ -113,7 +104,6 @@
 #define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
 #define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
 #define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
-#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)
 #define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
 
 /*
@@ -127,42 +117,17 @@
 #define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
 
 /*
- * pulses shorter than this are filtered out by hardware (software
- * emulation in lirc_dev?)
- */
-#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x0000001a, __u32)
-/*
- * spaces shorter than this are filtered out by hardware (software
- * emulation in lirc_dev?)
- */
-#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001b, __u32)
-/*
- * if filter cannot be set independently for pulse/space, this should
- * be used
- */
-#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001c, __u32)
-
-/*
  * if enabled from the next key press on the driver will send
  * LIRC_MODE2_FREQUENCY packets
  */
 #define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
 
 /*
- * to set a range use
- * LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE with the
- * lower bound first and later
- * LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper bound
+ * to set a range use LIRC_SET_REC_CARRIER_RANGE with the
+ * lower bound first and later LIRC_SET_REC_CARRIER with the upper bound
  */
-
-#define LIRC_SET_REC_DUTY_CYCLE_RANGE  _IOW('i', 0x0000001e, __u32)
 #define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
 
-#define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
-
-#define LIRC_SETUP_START               _IO('i', 0x00000021)
-#define LIRC_SETUP_END                 _IO('i', 0x00000022)
-
 #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
 
 #endif
-- 
2.7.4


