Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38053 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcAFKjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 05:39:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 07/10] [media] tvp5150: Add device tree binding document
Date: Wed, 06 Jan 2016 12:39:25 +0200
Message-ID: <2787681.imkQ5NT8Qm@avalon>
In-Reply-To: <1451910332-23385-8-git-send-email-javier@osg.samsung.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com> <1451910332-23385-8-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Monday 04 January 2016 09:25:29 Javier Martinez Canillas wrote:
> Add a Device Tree binding document for the TVP5150 video decoder.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt      | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt new file mode
> 100644
> index 000000000000..bf0b3f3128ce
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> @@ -0,0 +1,35 @@
> +* Texas Instruments TVP5150 and TVP5151 video decoders
> +
> +The TVP5150 and TVP5151 are video decoders that convert baseband NTSC and
> PAL
> +(and also SECAM in the TVP5151 case) video signals to either 8-bit 4:2:2
> YUV
> +with discrete syncs or 8-bit ITU-R BT.656 with embedded syncs output
> formats.
> +
> +Required Properties:
> +- compatible: value must be "ti,tvp5150"
> +- reg: I2C slave address
> +
> +Optional Properties:
> +- powerdown-gpios: phandle for the GPIO connected to the PDN pin, if any.

The signal is called PDN in the datasheet, so it might make sense to call this 
pdn-gpios. I have no strong opinion on this, I'll let you decide what you 
think is best.

Apart from that (and the indentation issue pointed out by Rob),

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +- reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
> +
> +The device node must contain one 'port' child node for its digital output
> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +&i2c2 {
> +	...
> +	tvp5150@5c {
> +			compatible = "ti,tvp5150";
> +			reg = <0x5c>;
> +			powerdown-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
> +			reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
> +
> +			port {
> +				tvp5150_1: endpoint {
> +					remote-endpoint = <&ccdc_ep>;
> +				};
> +			};
> +	};
> +};

-- 
Regards,

Laurent Pinchart

