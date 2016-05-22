Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55683 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbcEVCOK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2016 22:14:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 4/6] MAINTAINERS: add zd1301_demod driver
Date: Sun, 22 May 2016 05:13:49 +0300
Message-Id: <1463883231-14329-4-git-send-email-crope@iki.fi>
In-Reply-To: <1463883231-14329-1-git-send-email-crope@iki.fi>
References: <1463883231-14329-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-T demodulator driver for ZyDAS ZD1301 chip.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 090bec2..a4ae460 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12391,6 +12391,15 @@ L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
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

