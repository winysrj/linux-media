Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50039 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079AbaGRBFW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 21:05:22 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] MAINTAINERS: add airspy driver
Date: Fri, 18 Jul 2014 04:05:13 +0300
Message-Id: <1405645513-25616-4-git-send-email-crope@iki.fi>
In-Reply-To: <1405645513-25616-1-git-send-email-crope@iki.fi>
References: <1405645513-25616-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video4Linux2 driver for AirSpy SDR device.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 943efe3..f8e2c7f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -508,6 +508,16 @@ S:	Supported
 F:	fs/aio.c
 F:	include/linux/*aio*.h
 
+AIRSPY MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/airspy/
+
 ALCATEL SPEEDTOUCH USB DRIVER
 M:	Duncan Sands <duncan.sands@free.fr>
 L:	linux-usb@vger.kernel.org
-- 
1.9.3

