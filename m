Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52828 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751936AbdBUL5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 06:57:55 -0500
Date: Tue, 21 Feb 2017 13:57:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, vladimir_zapolskiy@mentor.com,
        CARLOS.PALMINHA@synopsys.com, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v9 1/2] Add OV5647 device tree documentation
Message-ID: <20170221115746.GF16975@valkosipuli.retiisi.org.uk>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <5a93352142495528dd56d5e281a8ed8ad6404a05.1487334912.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a93352142495528dd56d5e281a8ed8ad6404a05.1487334912.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Fri, Feb 17, 2017 at 01:14:15PM +0000, Ramiro Oliveira wrote:
> Create device tree bindings documentation.
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> new file mode 100644
> index 000000000000..31956426d3b9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> @@ -0,0 +1,35 @@
> +Omnivision OV5647 raw image sensor
> +---------------------------------
> +
> +OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
> +and CCI (I2C compatible) control bus.
> +
> +Required properties:
> +
> +- compatible		: "ovti,ov5647".
> +- reg			: I2C slave address of the sensor.
> +- clocks		: Reference to the xclk clock.
> +- clock-names		: Should be "xclk".
> +- clock-frequency	: Frequency of the xclk clock.
> +
> +The common video interfaces bindings (see video-interfaces.txt) should be
> +used to specify link to the image data receiver. The OV5647 device
> +node should contain one 'port' child node with an 'endpoint' subnode.

The remote-endpoint property in endpoint nodes should be mandatory,
shouldn't it? Otherwise the sensor isn't connected to anything and hardly
useful as such. The list of optional endpoint properties is a long one and
it should be documented here which ones are recognised, either as optional
or mandatory.

> +
> +Example:
> +
> +	i2c@2000 {
> +		...
> +		ov: camera@36 {
> +			compatible = "ovti,ov5647";
> +			reg = <0x36>;
> +			clocks = <&camera_clk>;
> +			clock-names = "xclk";
> +			clock-frequency = <25000000>;
> +			port {
> +				camera_1: endpoint {
> +					remote-endpoint = <&csi1_ep1>;
> +				};
> +			};
> +		};
> +	};

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
