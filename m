Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34242 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaIJHWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 03:22:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] MAINTAINERS: add HackRF SDR driver
Date: Wed, 10 Sep 2014 10:21:39 +0300
Message-Id: <1410333699-19705-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HackRF SDR driver. Video4Linux USB device.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 78b38e9..3e907d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4146,6 +4146,16 @@ L:	linuxppc-dev@lists.ozlabs.org
 S:	Odd Fixes
 F:	drivers/tty/hvc/
 
+HACKRF MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/hackrf/
+
 HARDWARE MONITORING
 M:	Jean Delvare <jdelvare@suse.de>
 M:	Guenter Roeck <linux@roeck-us.net>
-- 
http://palosaari.fi/

