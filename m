Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37239 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaBCLAL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Feb 2014 06:00:11 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/5] MAINTAINERS: add msi001 driver
Date: Mon,  3 Feb 2014 12:59:53 +0200
Message-Id: <1391425195-17865-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391425195-17865-1-git-send-email-crope@iki.fi>
References: <1391425195-17865-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mirics MSi001 silicon tuner driver. Currently in staging as SDR API
is not ready.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 08701bd..69fc44b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5685,6 +5685,16 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/msi-wmi.c
 
+MSI001 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/staging/media/msi3101/msi001*
+
 MT9M032 APTINA SENSOR DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
1.8.5.3

