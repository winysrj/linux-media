Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57512 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759992Ab3LHWby (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 06/18] MAINTAINERS: add M88DS3103
Date: Mon,  9 Dec 2013 00:31:23 +0200
Message-Id: <1386541895-8634-7-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is Montage M88DS3103 DVB-S/S2 demodulator driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4..0604247 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5347,6 +5347,16 @@ W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
 F:	arch/m68k/hp300/
 
+M88DS3103 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/m88ds3103*
+
 M88RS2000 MEDIA DRIVER
 M:	Malcolm Priestley <tvboxspy@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
1.8.4.2

