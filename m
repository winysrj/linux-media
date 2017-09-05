Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41958 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751316AbdIEOqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 10:46:24 -0400
Date: Tue, 5 Sep 2017 17:46:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX
 Device Tree bindings
Message-ID: <20170905144620.mleywtmz7nmbdb5j@valkosipuli.retiisi.org.uk>
References: <20170904130335.23280-1-maxime.ripard@free-electrons.com>
 <20170904130335.23280-2-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904130335.23280-2-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Mon, Sep 04, 2017 at 03:03:34PM +0200, Maxime Ripard wrote:
> The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up to
> 4 CSI-2 lanes, and can route the frames to up to 4 streams, depending on
> the hardware implementation.
> 
> It can operate with an external D-PHY, an internal one or no D-PHY at all
> in some configurations.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../devicetree/bindings/media/cdns-csi2rx.txt      | 98 ++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx.txt

Naming this according to the compatible string would make it easier to
find. The same pattern is used by a number of existing binding files.

Up to you.

> 
> diff --git a/Documentation/devicetree/bindings/media/cdns-csi2rx.txt b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> new file mode 100644
> index 000000000000..2395030d8c72
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> @@ -0,0 +1,98 @@
> +Cadence MIPI-CSI2 RX controller
> +===============================
> +
> +The Cadence MIPI-CSI2 RX controller is a CSI-2 bridge supporting up to 4 CSI
> +lanes in input, and 4 different pixel streams in output.
> +
> +Required properties:
> +  - compatible: must be set to "cdns,csi2rx" and an SoC-specific compatible
> +  - reg: base address and size of the memory mapped region
> +  - clocks: phandles to the clocks driving the controller
> +  - clock-names: must contain:
> +    * sys_clk: main clock
> +    * p_clk: register bank clock
> +    * pixel_if[0-3]_clk: pixel stream output clock, one for each stream
> +                         implemented in hardware, between 0 and 3
> +
> +Optional properties:
> +  - phys: phandle to the external D-PHY, phy-names must be provided
> +  - phy-names: must contain dphy, if the implementation uses an
> +               external D-PHY
> +
> +Required subnodes:
> +  - ports: A ports node with endpoint definitions as defined in
> +           Documentation/devicetree/bindings/media/video-interfaces.txt. The
> +           first port subnode should be the input endpoint, the next ones the
> +           output, one for each stream supported by the CSI2-RX controller.

While I guess the DT compiler won't rearrange the nodes, it'd be better to
define the port numbers explicitly, i.e. that input is number 0.

> +           The ports ID must be the stream output number used in the
> +           implementation, plus 1.

And also that outputs are from 1 to 4.

With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
