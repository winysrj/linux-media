Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51964 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab3KFR5s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:57:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/8] MAINTAINERS: add M88DS3103
Date: Wed,  6 Nov 2013 19:57:34 +0200
Message-Id: <1383760655-11388-8-git-send-email-crope@iki.fi>
In-Reply-To: <1383760655-11388-1-git-send-email-crope@iki.fi>
References: <1383760655-11388-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is Montage M88DS3103 DVB-S/S2 demodulator driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..85cfc6f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5244,6 +5244,16 @@ W:	http://www.tazenda.demon.co.uk/phil/linux-hp
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

