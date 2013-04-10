Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44026 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935955Ab3DJAbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 20:31:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] MAINTAINERS: add RTL2832 media driver
Date: Wed, 10 Apr 2013 03:30:43 +0300
Message-Id: <1365553843-4117-3-git-send-email-crope@iki.fi>
In-Reply-To: <1365553843-4117-1-git-send-email-crope@iki.fi>
References: <1365553843-4117-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver author has disappeared, even mails are bouncing back.
I will keep care with that as I have done for a while.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 413aebc..5a9ee27 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6705,6 +6705,16 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/dvb-frontends/rtl2830*
 
+RTL2832 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/rtl2832*
+
 RTL8180 WIRELESS DRIVER
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
-- 
1.7.11.7

