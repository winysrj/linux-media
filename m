Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52806 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbeGJICF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:05 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v5 05/22] dt-bindings: sram: sunxi: Populate valid sections compatibles
Date: Tue, 10 Jul 2018 10:00:57 +0200
Message-Id: <20180710080114.31469-6-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a list of valid SRAM sections compatibles for the A13, A20,
A23 and H3 platforms. Per-platform compatibles are introduced for the
SRAM sections of these platforms, with the A10 compatibles also listed
as valid when applicable.

In particular, compatibles for the C1 SRAM section are introduced.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 .../devicetree/bindings/sram/sunxi-sram.txt   | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/sram/sunxi-sram.txt b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
index 156a02ab6b54..07c53c5214a0 100644
--- a/Documentation/devicetree/bindings/sram/sunxi-sram.txt
+++ b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
@@ -32,8 +32,33 @@ once again the representation described in the mmio-sram binding.
 
 The valid sections compatible for A10 are:
     - allwinner,sun4i-a10-sram-a3-a4
+    - allwinner,sun4i-a10-sram-c1
     - allwinner,sun4i-a10-sram-d
 
+The valid sections compatible for A13 are:
+    - allwinner,sun5i-a13-sram-a3-a4
+    - allwinner,sun4i-a10-sram-a3-a4
+    - allwinner,sun5i-a13-sram-c1
+    - allwinner,sun4i-a10-sram-c1
+    - allwinner,sun5i-a13-sram-d
+    - allwinner,sun4i-a10-sram-d
+
+The valid sections compatible for A20 are:
+    - allwinner,sun7i-a20-sram-a3-a4
+    - allwinner,sun4i-a10-sram-a3-a4
+    - allwinner,sun7i-a20-sram-c1
+    - allwinner,sun4i-a10-sram-c1
+    - allwinner,sun7i-a20-sram-d
+    - allwinner,sun4i-a10-sram-d
+
+The valid sections compatible for A23/A33 are:
+    - allwinner,sun8i-a23-sram-c1
+    - allwinner,sun4i-a10-sram-c1
+
+The valid sections compatible for H3 are:
+    - allwinner,sun8i-h3-sram-c1
+    - allwinner,sun4i-a10-sram-c1
+
 The valid sections compatible for A64 are:
     - allwinner,sun50i-a64-sram-c
 
-- 
2.17.1
