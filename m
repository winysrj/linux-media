Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52298 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab3KFR5s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:57:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/8] MAINTAINERS: add M88TS2022
Date: Wed,  6 Nov 2013 19:57:35 +0200
Message-Id: <1383760655-11388-9-git-send-email-crope@iki.fi>
In-Reply-To: <1383760655-11388-1-git-send-email-crope@iki.fi>
References: <1383760655-11388-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is Montage M88TS2022 DVB-S/S2 silicon tuner driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 85cfc6f..314b485 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5262,6 +5262,16 @@ Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/dvb-frontends/m88rs2000*
 
+M88TS2022 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/m88ts2022*
+
 MA901 MASTERKIT USB FM RADIO DRIVER
 M:      Alexey Klimov <klimov.linux@gmail.com>
 L:      linux-media@vger.kernel.org
-- 
1.8.4.2

