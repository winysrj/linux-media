Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:2580 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbbKLMWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 07:22:06 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv10 08/16] cec: add compat32 ioctl support
Date: Thu, 12 Nov 2015 13:21:37 +0100
Message-Id: <793abfb94a6335a7f771ae99c6e8fdb1619a1882.1447329279.git.hansverk@cisco.com>
In-Reply-To: <cover.1447329279.git.hansverk@cisco.com>
References: <cover.1447329279.git.hansverk@cisco.com>
In-Reply-To: <cover.1447329279.git.hansverk@cisco.com>
References: <cover.1447329279.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC ioctls didn't have compat32 support, so they returned -ENOTTY
when used in a 32 bit application on a 64 bit kernel.

Since all the CEC ioctls are 32-bit compatible adding support for this
API is trivial.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 fs/compat_ioctl.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 48851f6..c8651aa 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -57,6 +57,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/atalk.h>
 #include <linux/gfp.h>
+#include <linux/cec.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_sock.h>
@@ -1381,6 +1382,24 @@ COMPATIBLE_IOCTL(VIDEO_GET_NAVI)
 COMPATIBLE_IOCTL(VIDEO_SET_ATTRIBUTES)
 COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
 COMPATIBLE_IOCTL(VIDEO_GET_FRAME_RATE)
+/* cec */
+COMPATIBLE_IOCTL(CEC_ADAP_G_CAPS)
+COMPATIBLE_IOCTL(CEC_ADAP_G_LOG_ADDRS)
+COMPATIBLE_IOCTL(CEC_ADAP_S_LOG_ADDRS)
+COMPATIBLE_IOCTL(CEC_ADAP_G_STATE)
+COMPATIBLE_IOCTL(CEC_ADAP_S_STATE)
+COMPATIBLE_IOCTL(CEC_ADAP_G_PHYS_ADDR)
+COMPATIBLE_IOCTL(CEC_ADAP_S_PHYS_ADDR)
+COMPATIBLE_IOCTL(CEC_ADAP_G_VENDOR_ID)
+COMPATIBLE_IOCTL(CEC_ADAP_S_VENDOR_ID)
+COMPATIBLE_IOCTL(CEC_G_MONITOR)
+COMPATIBLE_IOCTL(CEC_S_MONITOR)
+COMPATIBLE_IOCTL(CEC_CLAIM)
+COMPATIBLE_IOCTL(CEC_RELEASE)
+COMPATIBLE_IOCTL(CEC_G_PASSTHROUGH)
+COMPATIBLE_IOCTL(CEC_TRANSMIT)
+COMPATIBLE_IOCTL(CEC_RECEIVE)
+COMPATIBLE_IOCTL(CEC_DQEVENT)
 
 /* joystick */
 COMPATIBLE_IOCTL(JSIOCGVERSION)
-- 
2.6.2

