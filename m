Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:43364 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752862AbdK2VUX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 16:20:23 -0500
Received: by mail-pg0-f66.google.com with SMTP id b18so2052684pgv.10
        for <linux-media@vger.kernel.org>; Wed, 29 Nov 2017 13:20:22 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v4 1/5] MAINTAINERS: add entry for NXP TDA1997x driver
Date: Wed, 29 Nov 2017 13:19:53 -0800
Message-Id: <1511990397-27647-2-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1511990397-27647-1-git-send-email-tharvey@gateworks.com>
References: <1511990397-27647-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa71ab52f..502bc97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13244,6 +13244,14 @@ T:	git git://linuxtv.org/mkrufky/tuners.git
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
