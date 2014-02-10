Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51682 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbaBJT3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 14:29:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 5/5] MAINTAINERS: add msi3101 driver
Date: Mon, 10 Feb 2014 21:29:03 +0200
Message-Id: <1392060543-3972-6-git-send-email-crope@iki.fi>
In-Reply-To: <1392060543-3972-1-git-send-email-crope@iki.fi>
References: <1392060543-3972-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mirics MSi2500 (MSi3101) SDR ADC + USB interface driver. Currently
in staging as SDR API is not ready.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 15ebabb..f03772a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5767,6 +5767,16 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/staging/media/msi3101/msi001*
 
+MSI3101 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/staging/media/msi3101/sdr-msi3101*
+
 MT9M032 APTINA SENSOR DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
1.8.5.3

