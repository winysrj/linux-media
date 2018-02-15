Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34869 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946187AbeBOR4S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 12:56:18 -0500
Received: by mail-pg0-f67.google.com with SMTP id l131so355132pga.2
        for <linux-media@vger.kernel.org>; Thu, 15 Feb 2018 09:56:17 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v13 4/8] MAINTAINERS: add entry for NXP TDA1997x driver
Date: Thu, 15 Feb 2018 09:55:32 -0800
Message-Id: <1518717336-6271-5-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1518717336-6271-1-git-send-email-tharvey@gateworks.com>
References: <1518717336-6271-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 845fc25..439b500 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13262,6 +13262,14 @@ T:	git git://linuxtv.org/mkrufky/tuners.git
 S:	Maintained
 F:	drivers/media/tuners/tda18271*
 
+TDA1997x MEDIA DRIVER
+M:	Tim Harvey <tharvey@gateworks.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/i2c/tda1997x.*
+
 TDA827x MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
