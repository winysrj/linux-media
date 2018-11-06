Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36406 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387537AbeKFRXn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 12:23:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id z13-v6so9926679wrs.3
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 23:59:44 -0800 (PST)
From: Maxime Jourdan <mjourdan@baylibre.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v4 3/3] MAINTAINERS: Add meson video decoder
Date: Tue,  6 Nov 2018 08:59:26 +0100
Message-Id: <20181106075926.19269-4-mjourdan@baylibre.com>
In-Reply-To: <20181106075926.19269-1-mjourdan@baylibre.com>
References: <20181106075926.19269-1-mjourdan@baylibre.com>
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
index f4855974f325..df013e7758b6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9621,6 +9621,14 @@ F:	drivers/media/platform/meson/ao-cec.c
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
2.19.1
