Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55500 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbcCYNKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 09:10:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv14 08/18] cec: add compat32 ioctl support
Date: Fri, 25 Mar 2016 14:10:06 +0100
Message-Id: <1458911416-47981-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
References: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC ioctls didn't have compat32 support, so they returned -ENOTTY
when used in a 32 bit application on a 64 bit kernel.

Since all the CEC ioctls are 32-bit compatible adding support for this
API is trivial.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 fs/compat_ioctl.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 6402eaf..4f17e4e 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -57,6 +57,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/atalk.h>
 #include <linux/gfp.h>
+#include <linux/cec.h>
 
 #include "internal.h"
 
@@ -1399,6 +1400,18 @@ COMPATIBLE_IOCTL(VIDEO_GET_NAVI)
 COMPATIBLE_IOCTL(VIDEO_SET_ATTRIBUTES)
 COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
 COMPATIBLE_IOCTL(VIDEO_GET_FRAME_RATE)
+/* cec */
+COMPATIBLE_IOCTL(CEC_ADAP_G_CAPS)
+COMPATIBLE_IOCTL(CEC_ADAP_LOG_STATUS)
+COMPATIBLE_IOCTL(CEC_ADAP_G_LOG_ADDRS)
+COMPATIBLE_IOCTL(CEC_ADAP_S_LOG_ADDRS)
+COMPATIBLE_IOCTL(CEC_ADAP_G_PHYS_ADDR)
+COMPATIBLE_IOCTL(CEC_ADAP_S_PHYS_ADDR)
+COMPATIBLE_IOCTL(CEC_G_MODE)
+COMPATIBLE_IOCTL(CEC_S_MODE)
+COMPATIBLE_IOCTL(CEC_TRANSMIT)
+COMPATIBLE_IOCTL(CEC_RECEIVE)
+COMPATIBLE_IOCTL(CEC_DQEVENT)
 
 /* joystick */
 COMPATIBLE_IOCTL(JSIOCGVERSION)
-- 
2.7.0

