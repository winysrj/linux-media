Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35503 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935903Ab3DJAbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 20:31:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/3] MAINTAINERS: update CYPRESS_FIRMWARE media driver
Date: Wed, 10 Apr 2013 03:30:41 +0300
Message-Id: <1365553843-4117-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is moved to the different location and renamed.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 154b02c..bde9825 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2367,6 +2367,16 @@ W:	http://www.cyclades.com/
 S:	Orphan
 F:	drivers/net/wan/pc300*
 
+CYPRESS_FIRMWARE MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/common/cypress_firmware*
+
 CYTTSP TOUCHSCREEN DRIVER
 M:	Javier Martinez Canillas <javier@dowhile0.org>
 L:	linux-input@vger.kernel.org
@@ -2731,16 +2741,6 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/dvb-usb/cxusb*
 
-DVB_USB_CYPRESS_FIRMWARE MEDIA DRIVER
-M:	Antti Palosaari <crope@iki.fi>
-L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
-W:	http://palosaari.fi/linux/
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-T:	git git://linuxtv.org/anttip/media_tree.git
-S:	Maintained
-F:	drivers/media/usb/dvb-usb-v2/cypress_firmware*
-
 DVB_USB_EC168 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-- 
1.7.11.7

