Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:47934 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934097AbdKAVv7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 17:51:59 -0400
Date: Wed, 1 Nov 2017 16:51:57 -0500
From: Rob Herring <robh@kernel.org>
To: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] media: ov7740: Document device tree bindings
Message-ID: <20171101215157.5hemcpuplikvtpqx@rob-hp-laptop>
References: <20171031011146.6899-1-wenyou.yang@microchip.com>
 <20171031011146.6899-3-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031011146.6899-3-wenyou.yang@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 31, 2017 at 09:11:44AM +0800, Wenyou Yang wrote:
> Add the device tree binding documentation for the ov7740 sensor driver.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> ---
> 
> Changes in v4: None
> Changes in v3:
>  - Explicitly document the "remote-endpoint" property.
> 
> Changes in v2: None
> 
>  .../devicetree/bindings/media/i2c/ov7740.txt       | 47 ++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7740.txt b/Documentation/devicetree/bindings/media/i2c/ov7740.txt
> new file mode 100644
> index 000000000000..af781c3a5f0e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov7740.txt
> @@ -0,0 +1,47 @@
> +* Omnivision OV7740 CMOS image sensor
> +
> +The Omnivision OV7740 image sensor supports multiple output image
> +size, such as VGA, and QVGA, CIF and any size smaller. It also
> +supports the RAW RGB and YUV output formats.
> +
> +The common video interfaces bindings (see video-interfaces.txt) should
> +be used to specify link to the image data receiver. The OV7740 device
> +node should contain one 'port' child node with an 'endpoint' subnode.
> +
> +Required Properties:
> +- compatible:	"ovti,ov7740".
> +- reg:		I2C slave address of the sensor.
> +- clocks:	Reference to the xvclk input clock.
> +- clock-names:	"xvclk".
> +
> +Optional Properties:
> +- reset-gpios: Rreference to the GPIO connected to the reset_b pin,
> +  if any. Active low with pull-ip resistor.
> +- powerdown-gpios: Reference to the GPIO connected to the pwdn pin,
> +  if any. Active high with pull-down resistor.
> +
> +Endpoint node mandatory properties:
> +- remote-endpoint: A phandle to the bus receiver's endpoint node.

This is not really necessary. What's required is documenting how many 
ports and how many endpoints for each port which you have above.

Acked-by: Rob Herring <robh@kernel.org>
