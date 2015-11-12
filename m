Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35642 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbbKLSDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 13:03:09 -0500
Received: by lbbsy6 with SMTP id sy6so11321485lbb.2
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2015 10:03:07 -0800 (PST)
Received: from snorken.kolmodin.net (c-ab33e655.014-268-6c756c11.cust.bredbandsbolaget.se. [85.230.51.171])
        by smtp.googlemail.com with ESMTPSA id 102sm2477047lft.21.2015.11.12.10.03.06
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2015 10:03:06 -0800 (PST)
Date: Thu, 12 Nov 2015 19:03:00 +0100
From: Alec Leamas <leamas.alec@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Move internal header file lirc.h to uapi/ (#75751).
Message-ID: <20151112190300.415bc8c5@snorken.kolmodin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The file include/media/lirc.h describes a public interface and
should thus be a public header. See kernel bug
https://bugzilla.kernel.org/show_bug.cgi?id=75751 which has 
a manpage describing the interface + an acknowledgement that this 
info belongs to uapi.

---
 include/media/lirc.h      | 169 +---------------------------------------------
 include/uapi/linux/Kbuild |   1 +
 include/uapi/linux/lirc.h | 163 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+), 168 deletions(-)
 create mode 100644 include/uapi/linux/lirc.h

diff --git a/include/media/lirc.h b/include/media/lirc.h
index 4b3ab29..554988c 100644
--- a/include/media/lirc.h
+++ b/include/media/lirc.h
@@ -1,168 +1 @@
-/*
- * lirc.h - linux infrared remote control header file
- * last modified 2010/07/13 by Jarod Wilson
- */
-
-#ifndef _LINUX_LIRC_H
-#define _LINUX_LIRC_H
-
-#include <linux/types.h>
-#include <linux/ioctl.h>
-
-#define PULSE_BIT       0x01000000
-#define PULSE_MASK      0x00FFFFFF
-
-#define LIRC_MODE2_SPACE     0x00000000
-#define LIRC_MODE2_PULSE     0x01000000
-#define LIRC_MODE2_FREQUENCY 0x02000000
-#define LIRC_MODE2_TIMEOUT   0x03000000
-
-#define LIRC_VALUE_MASK      0x00FFFFFF
-#define LIRC_MODE2_MASK      0xFF000000
-
-#define LIRC_SPACE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_SPACE)
-#define LIRC_PULSE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_PULSE)
-#define LIRC_FREQUENCY(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_FREQUENCY)
-#define LIRC_TIMEOUT(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_TIMEOUT)
-
-#define LIRC_VALUE(val) ((val)&LIRC_VALUE_MASK)
-#define LIRC_MODE2(val) ((val)&LIRC_MODE2_MASK)
-
-#define LIRC_IS_SPACE(val) (LIRC_MODE2(val) == LIRC_MODE2_SPACE)
-#define LIRC_IS_PULSE(val) (LIRC_MODE2(val) == LIRC_MODE2_PULSE)
-#define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
-#define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
-
-/* used heavily by lirc userspace */
-#define lirc_t int
-
-/*** lirc compatible hardware features ***/
-
-#define LIRC_MODE2SEND(x) (x)
-#define LIRC_SEND2MODE(x) (x)
-#define LIRC_MODE2REC(x) ((x) << 16)
-#define LIRC_REC2MODE(x) ((x) >> 16)
-
-#define LIRC_MODE_RAW                  0x00000001
-#define LIRC_MODE_PULSE                0x00000002
-#define LIRC_MODE_MODE2                0x00000004
-#define LIRC_MODE_LIRCCODE             0x00000010
-
-
-#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
-#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
-#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
-#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
-
-#define LIRC_CAN_SEND_MASK             0x0000003f
-
-#define LIRC_CAN_SET_SEND_CARRIER      0x00000100
-#define LIRC_CAN_SET_SEND_DUTY_CYCLE   0x00000200
-#define LIRC_CAN_SET_TRANSMITTER_MASK  0x00000400
-
-#define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
-#define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
-#define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
-#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
-
-#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
-
-#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
-#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
-
-#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
-#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
-#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
-#define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
-#define LIRC_CAN_SET_REC_FILTER           0x08000000
-
-#define LIRC_CAN_MEASURE_CARRIER          0x02000000
-#define LIRC_CAN_USE_WIDEBAND_RECEIVER    0x04000000
-
-#define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
-#define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
-
-#define LIRC_CAN_NOTIFY_DECODE            0x01000000
-
-/*** IOCTL commands for lirc driver ***/
-
-#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
-
-#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
-#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
-#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
-#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
-#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
-#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, __u32)
-#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
-
-#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
-#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
-
-#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
-#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
-#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
-#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
-
-/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
-#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
-
-#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
-#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
-/* Note: these can reset the according pulse_width */
-#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
-#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
-#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
-#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)
-#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
-
-/*
- * when a timeout != 0 is set the driver will send a
- * LIRC_MODE2_TIMEOUT data packet, otherwise LIRC_MODE2_TIMEOUT is
- * never sent, timeout is disabled by default
- */
-#define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
-
-/* 1 enables, 0 disables timeout reports in MODE2 */
-#define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
-
-/*
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
- * if enabled from the next key press on the driver will send
- * LIRC_MODE2_FREQUENCY packets
- */
-#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
-
-/*
- * to set a range use
- * LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE with the
- * lower bound first and later
- * LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper bound
- */
-
-#define LIRC_SET_REC_DUTY_CYCLE_RANGE  _IOW('i', 0x0000001e, __u32)
-#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
-
-#define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
-
-#define LIRC_SETUP_START               _IO('i', 0x00000021)
-#define LIRC_SETUP_END                 _IO('i', 0x00000022)
-
-#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
-
-#endif
+#include <uapi/linux/lirc.h>
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index be88166..b4029e9 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -230,6 +230,7 @@ endif
 header-y += l2tp.h
 header-y += libc-compat.h
 header-y += limits.h
+header-y += lirc.h
 header-y += llc.h
 header-y += loop.h
 header-y += lp.h
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
new file mode 100644
index 0000000..ac7dc5a
--- /dev/null
+++ b/include/uapi/linux/lirc.h
@@ -0,0 +1,163 @@
+#ifndef _LINUX_LIRC_H
+#define _LINUX_LIRC_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define PULSE_BIT       0x01000000
+#define PULSE_MASK      0x00FFFFFF
+
+#define LIRC_MODE2_SPACE     0x00000000
+#define LIRC_MODE2_PULSE     0x01000000
+#define LIRC_MODE2_FREQUENCY 0x02000000
+#define LIRC_MODE2_TIMEOUT   0x03000000
+
+#define LIRC_VALUE_MASK      0x00FFFFFF
+#define LIRC_MODE2_MASK      0xFF000000
+
+#define LIRC_SPACE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_SPACE)
+#define LIRC_PULSE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_PULSE)
+#define LIRC_FREQUENCY(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_FREQUENCY)
+#define LIRC_TIMEOUT(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_TIMEOUT)
+
+#define LIRC_VALUE(val) ((val)&LIRC_VALUE_MASK)
+#define LIRC_MODE2(val) ((val)&LIRC_MODE2_MASK)
+
+#define LIRC_IS_SPACE(val) (LIRC_MODE2(val) == LIRC_MODE2_SPACE)
+#define LIRC_IS_PULSE(val) (LIRC_MODE2(val) == LIRC_MODE2_PULSE)
+#define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
+#define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
+
+/* Heavily used by lirc userspace */
+#define lirc_t int
+
+/*** lirc compatible hardware features ***/
+
+#define LIRC_MODE2SEND(x) (x)
+#define LIRC_SEND2MODE(x) (x)
+#define LIRC_MODE2REC(x) ((x) << 16)
+#define LIRC_REC2MODE(x) ((x) >> 16)
+
+#define LIRC_MODE_RAW                  0x00000001
+#define LIRC_MODE_PULSE                0x00000002
+#define LIRC_MODE_MODE2                0x00000004
+#define LIRC_MODE_LIRCCODE             0x00000010
+
+
+#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
+#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
+#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_SEND_MASK             0x0000003f
+
+#define LIRC_CAN_SET_SEND_CARRIER      0x00000100
+#define LIRC_CAN_SET_SEND_DUTY_CYCLE   0x00000200
+#define LIRC_CAN_SET_TRANSMITTER_MASK  0x00000400
+
+#define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
+#define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
+#define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
+#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
+
+#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
+#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
+
+#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
+#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
+#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
+#define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
+#define LIRC_CAN_SET_REC_FILTER           0x08000000
+
+#define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_USE_WIDEBAND_RECEIVER    0x04000000
+
+#define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
+#define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
+
+#define LIRC_CAN_NOTIFY_DECODE            0x01000000
+
+/*** IOCTL commands for lirc driver ***/
+
+#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
+
+#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
+#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
+#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
+#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
+#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
+#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, __u32)
+#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
+
+#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
+#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
+
+#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
+#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
+#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
+#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
+
+/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
+#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
+
+#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
+#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
+/* Note: these can reset the according pulse_width */
+#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
+#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
+#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
+#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)
+#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
+
+/*
+ * when a timeout != 0 is set the driver will send a
+ * LIRC_MODE2_TIMEOUT data packet, otherwise LIRC_MODE2_TIMEOUT is
+ * never sent, timeout is disabled by default
+ */
+#define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
+
+/* 1 enables, 0 disables timeout reports in MODE2 */
+#define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
+
+/*
+ * pulses shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x0000001a, __u32)
+/*
+ * spaces shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001b, __u32)
+/*
+ * if filter cannot be set independently for pulse/space, this should
+ * be used
+ */
+#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001c, __u32)
+
+/*
+ * if enabled from the next key press on the driver will send
+ * LIRC_MODE2_FREQUENCY packets
+ */
+#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
+
+/*
+ * to set a range use
+ * LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE with the
+ * lower bound first and later
+ * LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper bound
+ */
+
+#define LIRC_SET_REC_DUTY_CYCLE_RANGE  _IOW('i', 0x0000001e, __u32)
+#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
+
+#define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
+
+#define LIRC_SETUP_START               _IO('i', 0x00000021)
+#define LIRC_SETUP_END                 _IO('i', 0x00000022)
+
+#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
+
+#endif
-- 
1.9.3

