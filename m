Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54118 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaDOJcI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:32:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/10] MAINTAINERS: add si2168 driver
Date: Tue, 15 Apr 2014 12:31:45 +0300
Message-Id: <1397554306-14561-10-git-send-email-crope@iki.fi>
In-Reply-To: <1397554306-14561-1-git-send-email-crope@iki.fi>
References: <1397554306-14561-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silicon Labs Si2168 DVB-T/T2/C demod driver

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 94c9cff..c44c914 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7813,6 +7813,16 @@ M:	Robin Holt <robinmholt@gmail.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
+SI2168 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/si2168*
+
 SI470X FM RADIO RECEIVER I2C DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
1.9.0

