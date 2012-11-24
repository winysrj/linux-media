Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-02.mandic.com.br ([200.225.81.133]:55160 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2KXAeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 19:34:04 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 08/24] MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*
Date: Fri, 23 Nov 2012 22:26:32 -0200
Message-Id: <1353716808-16375-9-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver was never at dvb-usb-v2, as far as I could see.

Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c382ff9..0488d14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2594,7 +2594,7 @@ W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
-F:	drivers/media/usb/dvb-usb-v2/cxusb*
+F:	drivers/media/usb/dvb-usb/cxusb*
 
 DVB_USB_CYPRESS_FIRMWARE MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
-- 
1.7.11.7

