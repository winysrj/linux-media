Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56735 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaFSHiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 03:38:18 -0400
Date: Thu, 19 Jun 2014 09:38:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] media: mt9m111: add device-tree documentation
In-Reply-To: <1402863452-30365-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1406190937290.22703@axis700.grange>
References: <1402863452-30365-1-git-send-email-robert.jarzmik@free.fr>
 <1402863452-30365-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sun, 15 Jun 2014, Robert Jarzmik wrote:

> Add documentation for the Micron mt9m111 image sensor.

A nitpick: this isn't documentation for the sensor:) This is driver DT 
bindings' documentation.

Thanks
Guennadi

> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  .../devicetree/bindings/media/i2c/mt9m111.txt      | 28 ++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> new file mode 100644
> index 0000000..ed5a334
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> @@ -0,0 +1,28 @@
> +Micron 1.3Mp CMOS Digital Image Sensor
> +
> +The Micron MT9M111 is a CMOS active pixel digital image sensor with an active
> +array size of 1280H x 1024V. It is programmable through a simple two-wire serial
> +interface.
> +
> +Required Properties:
> +- compatible: value should be "micron,mt9m111"
> +
> +For further reading on port node refer to
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	i2c_master {
> +		mt9m111@5d {
> +			compatible = "micron,mt9m111";
> +			reg = <0x5d>;
> +
> +			remote = <&pxa_camera>;
> +			port {
> +				mt9m111_1: endpoint {
> +					bus-width = <8>;
> +					remote-endpoint = <&pxa_camera>;
> +				};
> +			};
> +		};
> +	};
> -- 
> 2.0.0.rc2
> 
