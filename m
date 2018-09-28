Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46161 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729232AbeI1Uxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 16:53:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id z3-v6so6603078wrr.13
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2018 07:29:32 -0700 (PDT)
From: Maxime Jourdan <mjourdan@baylibre.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxime Jourdan <mjourdan@baylibre.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v3 3/3] MAINTAINERS: Add meson video decoder
Date: Fri, 28 Sep 2018 16:28:16 +0200
Message-Id: <20180928142816.4311-4-mjourdan@baylibre.com>
In-Reply-To: <20180928142816.4311-1-mjourdan@baylibre.com>
References: <20180928142816.4311-1-mjourdan@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for the meson video decoder for amlogic SoCs.

Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4ece30f15777..93689a6d95d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9507,6 +9507,14 @@ F:	drivers/media/platform/meson/ao-cec.c
 F:	Documentation/devicetree/bindings/media/meson-ao-cec.txt
 T:	git git://linuxtv.org/media_tree.git
 
+MESON VIDEO DECODER DRIVER FOR AMLOGIC SOCS
+M:	Maxime Jourdan <mjourdan@baylibre.com>
+L:	linux-media@lists.freedesktop.org
+L:	linux-amlogic@lists.infradead.org
+S:	Supported
+F:	drivers/media/platform/meson/vdec/
+T:	git git://linuxtv.org/media_tree.git
+
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
 W:	http://www.monstr.eu/fdt/
-- 
2.19.0
