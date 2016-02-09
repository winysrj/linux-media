Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50219 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964809AbcBIAPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 19:15:47 -0500
Date: Mon, 8 Feb 2016 18:15:40 -0600
From: Rob Herring <robh@kernel.org>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, jslaby@suse.com, joe@perches.com,
	kvalo@codeaurora.org, davem@davemloft.net,
	gregkh@linuxfoundation.org, akpm@linux-foundation.org,
	mchehab@osg.samsung.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, laurent.pinchart@ideasonboard.com,
	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Subject: Re: [PATCH v6] media: spi: Add support for LMH0395
Message-ID: <20160209001540.GA23750@rob-hp-laptop>
References: <1454930424-6030-1-git-send-email-jean-michel.hautbois@veo-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454930424-6030-1-git-send-email-jean-michel.hautbois@veo-labs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 08, 2016 at 12:20:24PM +0100, Jean-Michel Hautbois wrote:
> This device is a SPI based device from TI.
> It is a 3 Gbps HD/SD SDI Dual Output Low Power
> Extended Reach Adaptive Cable Equalizer.
> 
> LMH0395 enables the use of up to two outputs.
> These can be configured using DT.
> The name gives the spi bus, and the CS associated.
> Example : lmh0395-1@spi2
> LMH0395 is on bus SPI2 with CS number 1.
> 
> Controls should be accessible from userspace too.
> This will have to be done later.

Your line wrap should be ~72 columns.

> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
> ---
> v2: Add DT support
> v3: Change the bit set/clear in output_type as disabled means 'set the bit'
> v4: Clearer description of endpoints usage in Doc, and some init changes.
>     Add a dependency on OF and don't test CONFIG_OF anymore.
> v5: Change port description in Documentation
>     Multiple ports : required #address-cells and #size-cells
>     Alphabetical order for include files
>     Simplify register set/clear
>     Check device ID
>     Implement log_status handler
> v6: Take Laurent Pinchart remarks into account
>     Correct register settings
>     Use next generation MC
> 
>  .../devicetree/bindings/media/spi/lmh0395.txt      |  51 +++
>  MAINTAINERS                                        |   6 +
>  drivers/media/Kconfig                              |   1 +
>  drivers/media/Makefile                             |   2 +-
>  drivers/media/spi/Kconfig                          |  15 +
>  drivers/media/spi/Makefile                         |   1 +
>  drivers/media/spi/lmh0395.c                        | 477 +++++++++++++++++++++
>  drivers/media/spi/lmh039x.h                        |  55 +++
>  8 files changed, 607 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/media/spi/lmh0395.txt
>  create mode 100644 drivers/media/spi/Kconfig
>  create mode 100644 drivers/media/spi/Makefile
>  create mode 100644 drivers/media/spi/lmh0395.c
>  create mode 100644 drivers/media/spi/lmh039x.h
> 
> diff --git a/Documentation/devicetree/bindings/media/spi/lmh0395.txt b/Documentation/devicetree/bindings/media/spi/lmh0395.txt
> new file mode 100644
> index 0000000..5c6ab4a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/spi/lmh0395.txt
> @@ -0,0 +1,51 @@
> +* Texas Instruments lmh0395 3G HD/SD SDI equalizer
> +
> +"The LMH0395 is an SDI equalizer designed to extend the reach of SDI signals
> +transmitted over cable by equalizing the input signal and generating clean
> +outputs. It has one differential input and two differential output that can be
> +independently controlled."
> +
> +Required Properties :
> +- compatible: Must be "ti,lmh0395"

You don't state this is a SPI device and uses standard SPI device 
properties.

> +
> +The device node must contain one 'port' child node per device input and output
> +port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +The LMH0395 has three ports numbered as follows.
> +
> +  Port			LMH0395
> +------------------------------------------------------------
> +  SDI (SDI input)	0
> +  SDO0 (SDI output 0)	1
> +  SDO1 (SDI output 1)	2
> +
> +Example:
> +
> +ecspi@02010000 {

s/ecspi/spi/ and drop the leading 0.

Presumbly the dts you based this on was wrong.

> +	...
> +	...
> +
> +	lmh0395@1 {
> +		compatible = "ti,lmh0395";
> +		reg = <1>;
> +		spi-max-frequency = <20000000>;
> +		ports {
> +			port@0 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;

These belong up one level in ports.

> +				reg = <0>;
> +				sdi0_in: endpoint {};
> +			};
> +			port@1 {
> +				reg = <1>;
> +				sdi0_out0: endpoint {};
> +			};
> +			port@2 {
> +				reg = <2>;
> +				/* endpoint not specified, disable output */
> +			};
> +		};
> +	};
> +	...
> +};
