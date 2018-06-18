Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41386 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935361AbeFRPAT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 11:00:19 -0400
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v4 09/19] ARM: dts: sun7i-a20: Also use dedicated SRAM controller compatible
Date: Mon, 18 Jun 2018 16:58:33 +0200
Message-Id: <20180618145843.14631-10-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
References: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the newly-introduced SRAM controller compatible for the A20, aside
of its A10 fashion.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index e529e4ff2174..f64eab4ce6f1 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -240,7 +240,8 @@
 		ranges;
 
 		sram-controller@1c00000 {
-			compatible = "allwinner,sun4i-a10-sram-controller";
+			compatible = "allwinner,sun7i-a20-sram-controller",
+				     "allwinner,sun4i-a10-sram-controller";
 			reg = <0x01c00000 0x30>;
 			#address-cells = <1>;
 			#size-cells = <1>;
-- 
2.17.0
