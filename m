Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59710 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754379AbdLGN7P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 08:59:15 -0500
Date: Thu, 7 Dec 2017 15:59:12 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v3 3/5] media: dt-bindings: ov5640: add support of DVP
 parallel interface
Message-ID: <20171207135911.urs6sg2sd35jcnqq@valkosipuli.retiisi.org.uk>
References: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
 <1512650453-24476-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512650453-24476-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Dec 07, 2017 at 01:40:51PM +0100, Hugues Fruchet wrote:
> Add bindings for OV5640 DVP parallel interface support.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5640.txt       | 27 ++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> index 540b36c..04e2a91 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> @@ -1,4 +1,4 @@
> -* Omnivision OV5640 MIPI CSI-2 sensor
> +* Omnivision OV5640 MIPI CSI-2 / parallel sensor
>  
>  Required Properties:
>  - compatible: should be "ovti,ov5640"
> @@ -18,7 +18,11 @@ The device node must contain one 'port' child node for its digital output
>  video port, in accordance with the video interface bindings defined in
>  Documentation/devicetree/bindings/media/video-interfaces.txt.
>  
> -Example:
> +Parallel or CSI mode is selected according to optional endpoint properties.
> +Without properties (or bus properties), parallel mode is selected.
> +Specifying any CSI properties such as lanes will enable CSI mode.

These bindings never documented what which endpoint properties were needed.

Beyond that, the sensor supports two CSI-2 lanes. You should explicitly
specify that, in other words, you'll need "data-lanes" property. Could you
add that?

Long time ago when the video-interfaces.txt and the V4L2 OF framework were
written, the bus type selection was made implicit and only later on
explicit. This is still reflected in how the bus type gets set between
CSI-2 D-PHY, parallel and Bt.656.

> +
> +Examples:
>  
>  &i2c1 {
>  	ov5640: camera@3c {
> @@ -35,6 +39,7 @@ Example:
>  		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
>  
>  		port {
> +			/* MIPI CSI-2 bus endpoint */
>  			ov5640_to_mipi_csi2: endpoint {
>  				remote-endpoint = <&mipi_csi2_from_ov5640>;
>  				clock-lanes = <0>;
> @@ -43,3 +48,21 @@ Example:
>  		};
>  	};
>  };
> +
> +&i2c1 {
> +	ov5640: camera@3c {
> +		compatible = "ovti,ov5640";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_ov5640>;
> +		reg = <0x3c>;
> +		clocks = <&clk_ext_camera>;
> +		clock-names = "xclk";
> +
> +		port {
> +			/* Parallel bus endpoint */
> +			ov5640_to_parallel: endpoint {
> +				remote-endpoint = <&parallel_from_ov5640>;
> +			};
> +		};
> +	};
> +};
> -- 
> 1.9.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
