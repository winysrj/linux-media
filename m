Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35807 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbcFFOij (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 10:38:39 -0400
Date: Mon, 6 Jun 2016 09:38:37 -0500
From: Rob Herring <robh@kernel.org>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	mchehab@osg.samsung.com, CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH 1/2] Add OV5647 device tree documentation
Message-ID: <20160606143837.GA22997@rob-hp-laptop>
References: <cover.1464966020.git.roliveir@synopsys.com>
 <4221809485a46dbf12b883a8207784553fd776a3.1464966020.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4221809485a46dbf12b883a8207784553fd776a3.1464966020.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 03, 2016 at 06:36:40PM +0100, Ramiro Oliveira wrote:
> From: roliveir <roliveir@synopsys.com>
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5647.txt          | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> new file mode 100644
> index 0000000..5e4aa49
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> @@ -0,0 +1,19 @@
> +Omnivision OV5657 raw image sensor

Still 5657?

> +---------------------------------
> +
> +OV5657 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
> +and CCI (I2C compatible) control bus.
> +
> +Required properties:
> +
> +- compatible	: "ov5647";

Needs vendor prefix?

> +- reg		: I2C slave address of the sensor;

What happened to the clocks property. I'm pretty sure the driver always 
needs to know the input clock freq.

> +
> +The common video interfaces bindings (see video-interfaces.txt) should be
> +used to specify link to the image data receiver. The OV5647 device
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
