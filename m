Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56722 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaBKCFQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 21:05:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 16/16] MAINTAINERS: add rtl2832_sdr driver
Date: Tue, 11 Feb 2014 04:04:59 +0200
Message-Id: <1392084299-16549-17-git-send-email-crope@iki.fi>
In-Reply-To: <1392084299-16549-1-git-send-email-crope@iki.fi>
References: <1392084299-16549-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Realtek RTL2832 SDR driver. Currently in staging as SDR API is not
ready.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f03772a..0ed943a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7338,6 +7338,16 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/dvb-frontends/rtl2832*
 
+RTL2832_SDR MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/staging/media/rtl2832u_sdr/rtl2832_sdr*
+
 RTL8180 WIRELESS DRIVER
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
-- 
1.8.5.3

