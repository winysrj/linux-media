Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37584 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751354AbdA0UzM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 15:55:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v3 4/7] MAINTAINERS: add zd1301_demod driver
Date: Fri, 27 Jan 2017 22:54:41 +0200
Message-Id: <20170127205444.3242-4-crope@iki.fi>
In-Reply-To: <20170127205444.3242-1-crope@iki.fi>
References: <20170127205444.3242-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-T demodulator driver for ZyDAS ZD1301 chip.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 52cc077..26ae0ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13380,6 +13380,15 @@ L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 F:	drivers/net/wireless/zydas/zd1211rw/
 
+ZD1301_DEMOD MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	https://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/dvb-frontends/zd1301_demod*
+
 ZPOOL COMPRESSED PAGE STORAGE API
 M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
-- 
http://palosaari.fi/

