Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:42400 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752014AbdHHOSd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 10:18:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] MAINTAINERS: add entry for meson ao cec driver
Message-ID: <323ef568-a88f-5bc1-390c-fd630dfc4535@xs4all.nl>
Date: Tue, 8 Aug 2017 16:18:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entry to the MAINTAINERS file for the meson ao cec driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 9826a918d37a..ed568e1ac856 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8671,6 +8671,16 @@ F:	drivers/leds/leds-menf21bmc.c
 F:	drivers/hwmon/menf21bmc_hwmon.c
 F:	Documentation/hwmon/menf21bmc

+MESON AO CEC DRIVER FOR AMLOGIC SOCS
+M:	Neil Armstrong <narmstrong@baylibre.com>
+L:	linux-media@lists.freedesktop.org
+L:	linux-amlogic@lists.infradead.org
+W:	http://linux-meson.com/
+S:	Supported
+F:	drivers/media/platform/meson/ao-cec.c
+F:	Documentation/devicetree/bindings/media/meson-ao-cec.txt
+T:	git git://linuxtv.org/media_tree.git
+
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
 L:	linux-metag@vger.kernel.org
