Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52871 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbaGOBJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/18] MAINTAINERS: update MSI3101 / MSI2500 driver location
Date: Tue, 15 Jul 2014 04:09:15 +0300
Message-Id: <1405386561-30450-12-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MSi3101 driver is moved out of staging and renamed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e0bd8b0..798c138 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5893,7 +5893,7 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/msi001*
 
-MSI3101 MEDIA DRIVER
+MSI2500 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
@@ -5901,7 +5901,7 @@ W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
-F:	drivers/staging/media/msi3101/sdr-msi3101*
+F:	drivers/media/usb/msi2500/msi2500*
 
 MT9M032 APTINA SENSOR DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-- 
1.9.3

