Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52788 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbeGJICE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:04 -0400
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
Subject: [PATCH v5 04/22] dt-bindings: sram: sunxi: Add A13, A20, A23 and H3 dedicated bindings
Date: Tue, 10 Jul 2018 10:00:56 +0200
Message-Id: <20180710080114.31469-5-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces dedicated bindings for the system control blocks found
on the A13, A20, A23 and H3 sunxi platforms.

Since the controllers on the A33 are the very same as those on the A23,
no specific compatible is introduced for it.

These bindings are introduced to allow reflecting the differences that
exist between these controllers, that may become significant to driver
implementations.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 Documentation/devicetree/bindings/sram/sunxi-sram.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/sram/sunxi-sram.txt b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
index d7dd1a393011..156a02ab6b54 100644
--- a/Documentation/devicetree/bindings/sram/sunxi-sram.txt
+++ b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
@@ -12,6 +12,10 @@ Required properties:
 - compatible : should be:
     - "allwinner,sun4i-a10-sram-controller" (deprecated)
     - "allwinner,sun4i-a10-system-control"
+    - "allwinner,sun5i-a13-system-control"
+    - "allwinner,sun7i-a20-system-control"
+    - "allwinner,sun8i-a23-system-control"
+    - "allwinner,sun8i-h3-system-control"
     - "allwinner,sun50i-a64-sram-controller" (deprecated)
     - "allwinner,sun50i-a64-system-control"
 - reg : sram controller register offset + length
-- 
2.17.1
