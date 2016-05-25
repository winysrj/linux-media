Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33374 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbcEYS7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 14:59:11 -0400
Date: Wed, 25 May 2016 13:59:08 -0500
From: Rob Herring <robh@kernel.org>
To: roliveir <Ramiro.Oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	mchehab@osg.samsung.com, CARLOS.PALMINHA@synopsys.com
Subject: Re: [RFC 1/2] Add OV5647 device tree documentation
Message-ID: <20160525185908.GA12900@rob-hp-laptop>
References: <cover.1464112779.git.roliveir@synopsys.com>
 <c98fab2075cefbe155c99b99f7b09cdad67514a8.1464112779.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c98fab2075cefbe155c99b99f7b09cdad67514a8.1464112779.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 24, 2016 at 07:16:47PM +0100, roliveir wrote:
> Signed-off-by: roliveir <roliveir@synopsys.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5647.txt       | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> new file mode 100644
> index 0000000..fa6b09c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> @@ -0,0 +1,29 @@
> +Omnivision OV5657 raw image sensor

5657?

> +---------------------------------
> +
> +OV5657 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
> +and CCI (I2C compatible) control bus.
> +
> +Required properties:
> +
> +- compatible	: "ov5647";
> +- reg		: I2C slave address of the sensor;
> +- clocks	: should contain list of phandle and clock specifier pairs
> +		  according to common clock bindings for the clocks described
> +		  in the clock-names property;

Need to state how many clocks and the order.

> +- clock-names	: should contain "extclk" entry for the sensor's EXTCLK clock;
> +
> +Optional properties:
> +
> +- clock-frequency : the frequency at which the "extclk" clock should be
> +		    configured to operate, in Hz; if this property is not
> +		    specified default 27 MHz value will be used.
> +
> +The common video interfaces bindings (see video-interfaces.txt) should be
> +used to specify link to the image data receiver. The OV5657 device
> +node should contain one 'port' child node with an 'endpoint' subnode.
> +
> +Following properties are valid for the endpoint node:
> +
> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> +  video-interfaces.txt.  The sensor supports only two data lanes.
> -- 
> 2.8.1
> 
> 
