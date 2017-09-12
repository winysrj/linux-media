Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:38505 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdILQmK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 12:42:10 -0400
Date: Tue, 12 Sep 2017 11:42:08 -0500
From: Rob Herring <robh@kernel.org>
To: Leon Luo <leonl@leopardimaging.com>
Cc: mchehab@kernel.org, mark.rutland@arm.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        soren.brinkmann@xilinx.com
Subject: Re: [PATCH v4 1/2] media:imx274 device tree binding file
Message-ID: <20170912164208.gdsyrmovf337wc66@rob-hp-laptop>
References: <20170901203243.25694-1-leonl@leopardimaging.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901203243.25694-1-leonl@leopardimaging.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 01, 2017 at 01:32:42PM -0700, Leon Luo wrote:
> The binding file for imx274 CMOS sensor V4l2 driver
> 
> Signed-off-by: Leon Luo <leonl@leopardimaging.com>
> ---
> v4:
>  - no changes
> v3:
>  - remove redundant properties and references
>  - document 'reg' property
> v2:
>  - no changes
> ---
>  .../devicetree/bindings/media/i2c/imx274.txt       | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/imx274.txt b/Documentation/devicetree/bindings/media/i2c/imx274.txt
> new file mode 100644
> index 000000000000..1f03256b35db
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/imx274.txt
> @@ -0,0 +1,32 @@
> +* Sony 1/2.5-Inch 8.51Mp CMOS Digital Image Sensor
> +
> +The Sony imx274 is a 1/2.5-inch CMOS active pixel digital image sensor with
> +an active array size of 3864H x 2202V. It is programmable through I2C
> +interface. The I2C address is fixed to 0x1a as per sensor data sheet.
> +Image data is sent through MIPI CSI-2, which is configured as 4 lanes
> +at 1440 Mbps.
> +
> +
> +Required Properties:
> +- compatible: value should be "sony,imx274" for imx274 sensor
> +- reg: I2C bus address of the device
> +
> +Optional Properties:
> +- reset-gpios: Sensor reset GPIO
> +
> +For further reading on port node refer to
> +Documentation/devicetree/bindings/media/video-interfaces.txt.

You need to specify here exactly how many ports and endpoints for each 
port. With that,

Acked-by: Rob Herring <robh@kernel.org>
