Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:30992 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756169AbeAHJfr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 04:35:47 -0500
Date: Mon, 8 Jan 2018 11:35:13 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v2 2/2] media: ov9650: add device tree binding
Message-ID: <20180108093513.nvr2e7vbt7imai2p@paasikivi.fi.intel.com>
References: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
 <1515344064-23156-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515344064-23156-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thanks for the update.

On Mon, Jan 08, 2018 at 01:54:24AM +0900, Akinobu Mita wrote:
> Now the ov9650 driver supports device tree probing.  So this adds a
> device tree binding documentation.
> 
> Cc: Jacopo Mondi <jacopo@jmondi.org>
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Hugues Fruchet <hugues.fruchet@st.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * Changelog v2
> - Split binding documentation, suggested by Rob Herring and Jacopo Mondi
> - Improve the wording for compatible property in the binding documentation,
>   suggested by Jacopo Mondi
> - Improve the description for the device node in the binding documentation,
>   suggested by Sakari Ailus
> 
>  .../devicetree/bindings/media/i2c/ov9650.txt       | 36 ++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov9650.txt b/Documentation/devicetree/bindings/media/i2c/ov9650.txt
> new file mode 100644
> index 0000000..506dfc5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov9650.txt
> @@ -0,0 +1,36 @@
> +* Omnivision OV9650/OV9652 CMOS sensor
> +
> +Required Properties:
> +- compatible: shall be one of
> +	"ovti,ov9650"
> +	"ovti,ov9652"
> +- clocks: reference to the xvclk input clock.
> +
> +Optional Properties:
> +- reset-gpios: reference to the GPIO connected to the resetb pin, if any.
> +  Active is high.
> +- powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
> +  Active is high.
> +
> +The device node shall contain one 'port' child node with one child 'endpoint'
> +subnode for its digital output video port, in accordance with the video
> +interface bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt.
> +
> +Example:
> +
> +&i2c0 {
> +	ov9650: camera@30 {
> +		compatible = "ovti,ov9650";
> +		reg = <0x30>;
> +		reset-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_HIGH>;
> +		powerdown-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_HIGH>;
> +		clocks = <&xclk>;
> +
> +		port {
> +			ov9650_0: endpoint {
> +				remote-endpoint = <&vcap1_in0>;
> +			};
> +		};
> +	};
> +};

I was going to say you're missing the MAINTAINERS entry for this newly
added file but then I noticed that the entire driver is missing an entry.
Still this file should have a MAINTAINERS entry added for it independently
of that, in the same patch.

Cc Sylwester.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
