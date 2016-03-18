Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:3318 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbcCROSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 10:18:00 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv13 08/17] cec: add compat32 ioctl support
Date: Fri, 18 Mar 2016 15:07:07 +0100
Message-Id: <1458310036-19252-9-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1458310036-19252-1-git-send-email-hans.verkuil@cisco.com>
References: <1458310036-19252-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC ioctls didn't have compat32 support, so they returned -ENOTTY
when used in a 32 bit application on a 64 bit kernel.

Since all the CEC ioctls are 32-bit compatible adding support for this
API is trivial.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 fs/compat_ioctl.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 6402eaf..140934c 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -57,6 +57,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/atalk.h>
 #include <linux/gfp.h>
+#include <linux/cec.h>
 
 #include "internal.h"
 
@@ -1399,6 +1400,22 @@ COMPATIBLE_IOCTL(VIDEO_GET_NAVI)
 COMPATIBLE_IOCTL(VIDEO_SET_ATTRIBUTES)
 COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
 COMPATIBLE_IOCTL(VIDEO_GET_FRAME_RATE)
+/* cec */
+COMPATIBLE_IOCTL(CEC_ADAP_G_CAPS)
+COMPATIBLE_IOCTL(CEC_ADAP_LOG_STATUS)
+COMPATIBLE_IOCTL(CEC_ADAP_G_LOG_ADDRS)
+COMPATIBLE_IOCTL(CEC_ADAP_S_LOG_ADDRS)
+COMPATIBLE_IOCTL(CEC_ADAP_G_STATE)
+COMPATIBLE_IOCTL(CEC_ADAP_S_STATE)
+COMPATIBLE_IOCTL(CEC_ADAP_G_PHYS_ADDR)
+COMPATIBLE_IOCTL(CEC_ADAP_S_PHYS_ADDR)
+COMPATIBLE_IOCTL(CEC_ADAP_G_VENDOR_ID)
+COMPATIBLE_IOCTL(CEC_ADAP_S_VENDOR_ID)
+COMPATIBLE_IOCTL(CEC_G_MODE)
+COMPATIBLE_IOCTL(CEC_S_MODE)
+COMPATIBLE_IOCTL(CEC_TRANSMIT)
+COMPATIBLE_IOCTL(CEC_RECEIVE)
+COMPATIBLE_IOCTL(CEC_DQEVENT)
 
 /* joystick */
 COMPATIBLE_IOCTL(JSIOCGVERSION)
-- 
2.7.0

