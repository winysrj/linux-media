Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33059 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754378AbdFLQhJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 12:37:09 -0400
Received: by mail-pf0-f195.google.com with SMTP id w12so6918422pfk.0
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 09:37:04 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] MAINTAINERS: add entry for Freescale i.MX media driver
Date: Mon, 12 Jun 2017 09:36:51 -0700
Message-Id: <1497285411-9082-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add maintainer entry for the imx-media driver.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c7f663..11adc51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8111,6 +8111,18 @@ L:	linux-iio@vger.kernel.org
 S:	Maintained
 F:	drivers/iio/dac/cio-dac.c
 
+MEDIA DRIVERS FOR FREESCALE IMX
+M:	Steve Longerbeam <slongerbeam@gmail.com>
+M:	Philipp Zabel <p.zabel@pengutronix.de>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/imx.txt
+F:	Documentation/media/v4l-drivers/imx.rst
+F:	drivers/staging/media/imx/
+F:	include/linux/imx-media.h
+F:	include/media/imx.h
+
 MEDIA DRIVERS FOR RENESAS - FCP
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
