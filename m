Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38138 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbbG0LWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:22:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/6] MAINTAINERS: add zd1301 DVB USB interface driver
Date: Mon, 27 Jul 2015 14:22:10 +0300
Message-Id: <1437996130-23735-7-git-send-email-crope@iki.fi>
In-Reply-To: <1437996130-23735-1-git-send-email-crope@iki.fi>
References: <1437996130-23735-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB USB interface driver for ZyDAS ZD1301 chip.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5d92ef..7bbcff5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11405,6 +11405,16 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/dvb-frontends/zd1301_demod*
 
+ZD1301 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/zd1301*
+
 ZPOOL COMPRESSED PAGE STORAGE API
 M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
-- 
http://palosaari.fi/

