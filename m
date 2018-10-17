Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:35230 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbeJQP1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 11:27:36 -0400
Received: by mail-it1-f195.google.com with SMTP id p64-v6so1327470itp.0
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 00:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <1537951204-24672-1-git-send-email-yong.deng@magewell.com>
In-Reply-To: <1537951204-24672-1-git-send-email-yong.deng@magewell.com>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Wed, 17 Oct 2018 13:03:03 +0530
Message-ID: <CAMty3ZD3TDOC_PSvbEtopT12pCmXCDqZQdPVB9GNC7wOrj_LYQ@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v11 1/2] dt-bindings: media: Add Allwinner
 V3s Camera Sensor Interface (CSI)
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, davem@davemloft.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, arnd@arndb.de,
        Hans Verkuil <hans.verkuil@cisco.com>,
        laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        jacob-chen@iotwrt.com, Neil Armstrong <narmstrong@baylibre.com>,
        treding@nvidia.com, Philipp Zabel <p.zabel@pengutronix.de>,
        todor.tomov@linaro.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 26, 2018 at 2:11 PM Yong Deng <yong.deng@magewell.com> wrote:
>
> Add binding documentation for Allwinner V3s CSI.
>
> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  .../devicetree/bindings/media/sun6i-csi.txt        | 59 ++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
>
> diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> new file mode 100644
> index 000000000000..2ff47a9507a6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> @@ -0,0 +1,59 @@
> +Allwinner V3s Camera Sensor Interface
> +-------------------------------------
> +
> +Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> +interface and CSI1 is used for parallel interface.
> +
> +Required properties:
> +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> +  - reg: base address and size of the memory-mapped region.
> +  - interrupts: interrupt associated to this IP
> +  - clocks: phandles to the clocks feeding the CSI
> +    * bus: the CSI interface clock
> +    * mod: the CSI module clock
> +    * ram: the CSI DRAM clock
> +  - clock-names: the clock names mentioned above
> +  - resets: phandles to the reset line driving the CSI
> +
> +Each CSI node should contain one 'port' child node with one child 'endpoint'
> +node, according to the bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. As mentioned
> +above, the endpoint's bus type should be MIPI CSI-2 for CSI0 and parallel or
> +Bt656 for CSI1.

But A64 manual claimed that CSI0 is parallel (ofcourse it has only one
controller). On the other-side the register space seems similar. and
also is Bt656 and CCIR656 are same types?

-- 
Jagan Teki
Senior Linux Kernel Engineer | Amarula Solutions
U-Boot, Linux | Upstream Maintainer
Hyderabad, India.
