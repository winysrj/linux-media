Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36441 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753526AbdBQAvs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 19:51:48 -0500
MIME-Version: 1.0
In-Reply-To: <1487211578-11360-8-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com> <1487211578-11360-8-git-send-email-steve_longerbeam@mentor.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 16 Feb 2017 22:51:47 -0200
Message-ID: <CAOMZO5AHJ2jSWvF1iZKhYyDAMmpg99R4-gz4ZyDZAcB4b3d0ag@mail.gmail.com>
Subject: Re: [PATCH v4 07/36] ARM: dts: imx6-sabresd: add OV5642 and OV5640
 camera sensors
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        nick@shmanahar.org, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        bparrot@ti.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        Pavel Machek <pavel@ucw.cz>, devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, Feb 16, 2017 at 12:19 AM, Steve Longerbeam
<slongerbeam@gmail.com> wrote:
> Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.
>
> The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.
>
> The OV5640 connects to the input port on the MIPI CSI-2 receiver on
> mipi_csi.
>
> Until the OV5652 sensor module compatible with the SabreSD becomes
> available for testing, the ov5642 node is currently disabled.

You missed your Signed-off-by.
