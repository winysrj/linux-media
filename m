Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50647 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935566Ab3DJAbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 20:31:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Carl Lundqvist <comabug@gmail.com>
Subject: [PATCH 2/3] MAINTAINERS: add DVB_USB_GL861
Date: Wed, 10 Apr 2013 03:30:42 +0300
Message-Id: <1365553843-4117-2-git-send-email-crope@iki.fi>
In-Reply-To: <1365553843-4117-1-git-send-email-crope@iki.fi>
References: <1365553843-4117-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have the hardware and I have already made almost all changes what
are needed during the recent few years, so lets mark it as maintained.

Cc: Carl Lundqvist <comabug@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bde9825..413aebc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2751,6 +2751,15 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/dvb-usb-v2/ec168*
 
+DVB_USB_GL861 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/gl861*
+
 DVB_USB_MXL111SF MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-- 
1.7.11.7

