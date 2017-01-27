Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50836 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdA0U4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 15:56:06 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] MAINTAINERS: remove hd29l2
Date: Fri, 27 Jan 2017 22:55:48 +0200
Message-Id: <20170127205549.3397-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drop unused driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 52cc077..761a3cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5595,16 +5595,6 @@ L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
 
-HD29L2 MEDIA DRIVER
-M:	Antti Palosaari <crope@iki.fi>
-L:	linux-media@vger.kernel.org
-W:	https://linuxtv.org
-W:	http://palosaari.fi/linux/
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-T:	git git://linuxtv.org/anttip/media_tree.git
-S:	Maintained
-F:	drivers/media/dvb-frontends/hd29l2*
-
 HEWLETT PACKARD ENTERPRISE ILO NMI WATCHDOG DRIVER
 M:	Brian Boylston <brian.boylston@hpe.com>
 S:	Supported
-- 
http://palosaari.fi/

