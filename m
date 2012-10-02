Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3974 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2JBEE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 00:04:56 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 6/8] MAINTAINERS: add Michael Krufky as cxusb maintainer
Date: Tue,  2 Oct 2012 00:04:10 -0400
Message-Id: <1349150652-12171-6-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
References: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ba5feb..1a4d7dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2559,6 +2559,16 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/dvb-usb-v2/ce6230*
 
+DVB_USB_CXUSB MEDIA DRIVER
+M:	Michael Krufky <mkrufky@linuxtv.org>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://github.com/mkrufky
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/cxusb*
+
 DVB_USB_CYPRESS_FIRMWARE MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-- 
1.7.9.5

