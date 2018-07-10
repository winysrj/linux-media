Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52865 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932756AbeGJICH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:07 -0400
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
Subject: [PATCH v5 07/22] drivers: soc: sunxi: Add support for the C1 SRAM region
Date: Tue, 10 Jul 2018 10:00:59 +0200
Message-Id: <20180710080114.31469-8-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Maxime Ripard <maxime.ripard@bootlin.com>

This introduces support for the SRAM C1 section, that is controlled by
the system controller. This SRAM area can be muxed either to the CPU
or the Video Engine, that needs this area to store various tables (e.g.
the Huffman VLD decoding tables).

This only supports devices with the same layout as the A10 (which also
includes the A13, A20, A33 and other SoCs).

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/soc/sunxi/sunxi_sram.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 236f34307c0f..b19fa2cc67c2 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -64,6 +64,12 @@ static struct sunxi_sram_desc sun4i_a10_sram_a3_a4 = {
 				  SUNXI_SRAM_MAP(1, 1, "emac")),
 };
 
+static struct sunxi_sram_desc sun4i_a10_sram_c1 = {
+	.data	= SUNXI_SRAM_DATA("C1", 0x0, 0x0, 31,
+				  SUNXI_SRAM_MAP(0, 0, "cpu"),
+				  SUNXI_SRAM_MAP(0x7fffffff, 1, "ve")),
+};
+
 static struct sunxi_sram_desc sun4i_a10_sram_d = {
 	.data	= SUNXI_SRAM_DATA("D", 0x4, 0x0, 1,
 				  SUNXI_SRAM_MAP(0, 0, "cpu"),
@@ -81,6 +87,10 @@ static const struct of_device_id sunxi_sram_dt_ids[] = {
 		.compatible	= "allwinner,sun4i-a10-sram-a3-a4",
 		.data		= &sun4i_a10_sram_a3_a4.data,
 	},
+	{
+		.compatible	= "allwinner,sun4i-a10-sram-c1",
+		.data		= &sun4i_a10_sram_c1.data,
+	},
 	{
 		.compatible	= "allwinner,sun4i-a10-sram-d",
 		.data		= &sun4i_a10_sram_d.data,
-- 
2.17.1
