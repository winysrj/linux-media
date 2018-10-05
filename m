Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22685 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbeJFEfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Oct 2018 00:35:03 -0400
Date: Sat, 6 Oct 2018 00:34:26 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        jacopo@jmondi.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/3] [media] imx214: device tree binding
Message-ID: <20181005213425.5mcafszioz4wxun5@kekkonen.localdomain>
References: <20181005124940.15539-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005124940.15539-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Fri, Oct 05, 2018 at 02:49:37PM +0200, Ricardo Ribalda Delgado wrote:
> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
> 
> Document bindings for imx214 camera sensor
> 
> Cc: devicetree@vger.kernel.org
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  .../devicetree/bindings/media/i2c/imx214.txt  | 53 +++++++++++++++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/imx214.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/imx214.txt b/Documentation/devicetree/bindings/media/i2c/imx214.txt
> new file mode 100644
> index 000000000000..421a019ab7f9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/imx214.txt
> @@ -0,0 +1,53 @@
> +* Sony 1/3.06-Inch 13.13Mp CMOS Digital Image Sensor
> +
> +The Sony imx214 is a 1/3.06-inch CMOS active pixel digital image sensor with
> +an active array size of 4224H x 3200V. It is programmable through an I2C
> +interface. The I2C address can be configured to 0x1a or 0x10, depending on
> +how the hardware is wired.
> +Image data is sent through MIPI CSI-2, through 2 or 4 lanes at a maximum
> +throughput of 1.2Gbps/lane.
> +
> +
> +Required Properties:
> +- compatible: value should be "sony,imx214" for imx214 sensor

should -> shall ?

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
