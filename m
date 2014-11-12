Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57882 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934102AbaKLETm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 9/9] MAINTAINERS: add mn88473 (Panasonic MN88473)
Date: Wed, 12 Nov 2014 06:19:31 +0200
Message-Id: <1415765971-24378-10-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add mn88473 driver from staging. DVB-T/T2/C demodulator driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 644a1ae..a6288ca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6126,6 +6126,17 @@ S:	Maintained
 F:	drivers/staging/media/mn88472/
 F:	drivers/media/dvb-frontends/mn88472.h
 
+MN88473 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/staging/media/mn88473/
+F:	drivers/media/dvb-frontends/mn88473.h
+
 MODULE SUPPORT
 M:	Rusty Russell <rusty@rustcorp.com.au>
 S:	Maintained
-- 
http://palosaari.fi/

