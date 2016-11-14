Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33082 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933126AbcKNTlN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 14:41:13 -0500
Date: Mon, 14 Nov 2016 13:41:10 -0600
From: Rob Herring <robh@kernel.org>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: mark.rutland@arm.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] media: i2c: max2175: Add MAX2175 support
Message-ID: <20161114194110.fh6gyhfdciikj7kt@rob-hp-laptop>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1478706284-59134-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1478706284-59134-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 09, 2016 at 03:44:41PM +0000, Ramesh Shanmugasundaram wrote:
> This patch adds driver support for MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-defined
> radio solutions. This driver exposes the tuner as a sub-device instance
> with standard and custom controls to configure the device.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
>  .../devicetree/bindings/media/i2c/max2175.txt      |   61 +

It's preferred that bindings are a separate patch.

>  drivers/media/i2c/Kconfig                          |    4 +
>  drivers/media/i2c/Makefile                         |    2 +
>  drivers/media/i2c/max2175/Kconfig                  |    8 +
>  drivers/media/i2c/max2175/Makefile                 |    4 +
>  drivers/media/i2c/max2175/max2175.c                | 1558 ++++++++++++++++++++
>  drivers/media/i2c/max2175/max2175.h                |  108 ++
>  7 files changed, 1745 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt
>  create mode 100644 drivers/media/i2c/max2175/Kconfig
>  create mode 100644 drivers/media/i2c/max2175/Makefile
>  create mode 100644 drivers/media/i2c/max2175/max2175.c
>  create mode 100644 drivers/media/i2c/max2175/max2175.h
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> new file mode 100644
> index 0000000..69f0dad
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> @@ -0,0 +1,61 @@
> +Maxim Integrated MAX2175 RF to Bits tuner
> +-----------------------------------------
> +
> +The MAX2175 IC is an advanced analog/digital hybrid-radio receiver with
> +RF to Bits® front-end designed for software-defined radio solutions.
> +
> +Required properties:
> +--------------------
> +- compatible: "maxim,max2175" for MAX2175 RF-to-bits tuner.
> +- clocks: phandle to the fixed xtal clock.
> +- clock-names: name of the fixed xtal clock.
> +- port: child port node of a tuner that defines the local and remote
> +  endpoints. The remote endpoint is assumed to be an SDR device
> +  that is capable of receiving the digital samples from the tuner.
> +
> +Optional properties:
> +--------------------
> +- maxim,slave	      : empty property indicates this is a slave of
> +			another master tuner. This is used to define two
> +			tuners in diversity mode (1 master, 1 slave). By
> +			default each tuner is an individual master.
> +- maxim,refout-load-pF: load capacitance value (in pF) on reference

Please add 'pF' to property-units.txt.

> +			output drive level. The possible load values are
> +			 0pF (default - refout disabled)
> +			10pF
> +			20pF
> +			30pF
> +			40pF
> +			60pF
> +			70pF
> +- maxim,am-hiz	      : empty property indicates AM Hi-Z filter path is
> +			selected for AM antenna input. By default this
> +			filter path is not used.
> +
> +Example:
> +--------
> +
> +Board specific DTS file
> +
> +/* Fixed XTAL clock node */
> +maxim_xtal: maximextal {

clock {

> +	compatible = "fixed-clock";
> +	#clock-cells = <0>;
> +	clock-frequency = <36864000>;
> +};
> +
> +/* A tuner device instance under i2c bus */
> +max2175_0: tuner@60 {
> +	compatible = "maxim,max2175";
> +	reg = <0x60>;
> +	clocks = <&maxim_xtal>;
> +	clock-names = "xtal";
> +	maxim,refout-load-pF = <10>;
> +
> +	port {
> +		max2175_0_ep: endpoint {
> +			remote-endpoint = <&slave_rx_v4l2_sdr_device>;

'v4l2' is not something that should appear in a DT.

> +		};
> +	};
> +
> +};
