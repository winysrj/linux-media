Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:47722 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755702AbdKOUC2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 15:02:28 -0500
Date: Wed, 15 Nov 2017 14:02:26 -0600
From: Rob Herring <robh@kernel.org>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v7 01/25] rcar-vin: add Gen3 devicetree bindings
 documentation
Message-ID: <20171115200226.wd343hd3a52jjhdd@rob-hp-laptop>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
 <20171111003835.4909-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171111003835.4909-2-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 11, 2017 at 01:38:11AM +0100, Niklas Söderlund wrote:
> Document the devicetree bindings for the CSI-2 inputs available on Gen3.
> 
> There is a need to add a custom property 'renesas,id' and to define
> which CSI-2 input is described in which endpoint under the port@1 node.
> This information is needed since there are a set of predefined routes
> between each VIN and CSI-2 block. This routing table will be kept
> inside the driver but in order for it to act on it it must know which
> VIN and CSI-2 is which.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         | 116 ++++++++++++++++++---
>  1 file changed, 104 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 6e4ef8caf759e5d3..df1abd0fb20386f8 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -2,8 +2,12 @@ Renesas R-Car Video Input driver (rcar_vin)
>  -------------------------------------------
>  
>  The rcar_vin device provides video input capabilities for the Renesas R-Car
> -family of devices. The current blocks are always slaves and suppot one input
> -channel which can be either RGB, YUYV or BT656.
> +family of devices.
> +
> +Each VIN instance has a single parallel input that supports RGB and YUV video,
> +with both external synchronization and BT.656 synchronization for the latter.
> +Depending on the instance the VIN input is connected to external SoC pins, or
> +on Gen3 to a CSI-2 receiver.
>  
>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7795" for the R8A7795 device
> @@ -28,21 +32,38 @@ channel which can be either RGB, YUYV or BT656.
>  Additionally, an alias named vinX will need to be created to specify
>  which video input device this is.
>  
> -The per-board settings:
> +The per-board settings Gen2:
>   - port sub-node describing a single endpoint connected to the vin
>     as described in video-interfaces.txt[1]. Only the first one will
>     be considered as each vin interface has one input port.
>  
> -   These settings are used to work out video input format and widths
> -   into the system.
> +The per-board settings Gen3:
> +
> +Gen3 can support both a single connected parallel input source from
> +external SoC pins (port0) and/or multiple parallel input sources from
> +local SoC CSI-2 receivers (port1) depending on SoC.
>  
> +- renesas,id - ID number of the VIN, VINx in the documentation.

Why is this needed? We try to avoid indexes unless that's the only way a 
device is addressed (and then we use reg).
