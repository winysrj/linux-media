Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:41657 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab3HWJsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:48:09 -0400
Message-ID: <1377251284.2626.18.camel@hornet>
Subject: Re: [PATCH v7] s5k5baf: add camera sensor driver
From: Pawel Moll <pawel.moll@arm.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Fri, 23 Aug 2013 10:48:04 +0100
In-Reply-To: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-08-21 at 15:41 +0100, Andrzej Hajda wrote:
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> new file mode 100644
> index 0000000..d680d99
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> @@ -0,0 +1,59 @@
> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
> +--------------------------------------------------------------------
> +
> +Required properties:
> +
> +- compatible     : "samsung,s5k5baf";
> +- reg            : I2C slave address of the sensor;
> +- vdda-supply    : analog power supply 2.8V (2.6V to 3.0V);
> +- vddreg-supply          : regulator input power supply 1.8V (1.7V to 1.9V)
> +                   or 2.8V (2.6V to 3.0);
> +- vddio-supply   : I/O power supply 1.8V (1.65V to 1.95V)
> +                   or 2.8V (2.5V to 3.1V);
> +- stbyn-gpios    : GPIO connected to STDBYN pin;
> +- rstn-gpios     : GPIO connected to RSTN pin;
> +- clocks         : the sensor's master clock specifier (from the common
> +                   clock bindings);
> +- clock-names    : must be "mclk";
> +
> +Optional properties:
> +
> +- clock-frequency : the frequency at which the "mclk" clock should be
> +                   configured to operate, in Hz; if this property is not
> +                   specified default 24 MHz value will be used.
> +
> +The device node should contain one 'port' child node with one child 'endpoint'
> +node, according to the bindings defined in Documentation/devicetree/bindings/
> +media/video-interfaces.txt. The following are properties specific to those
> +nodes.
> +
> +endpoint node
> +-------------
> +
> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> +  video-interfaces.txt. This property can be only used to specify number
> +  of data lanes, i.e. the array's content is unused, only its length is
> +  meaningful. When this property is not specified default value of 1 lane
> +  will be used.
> +
> +Example:
> +
> +s5k5bafx@2d {
> +       compatible = "samsung,s5k5baf";
> +       reg = <0x2d>;
> +       vdda-supply = <&cam_io_en_reg>;
> +       vddreg-supply = <&vt_core_15v_reg>;
> +       vddio-supply = <&vtcam_reg>;
> +       stbyn-gpios = <&gpl2 0 1>;
> +       rstn-gpios = <&gpl2 1 1>;
> +       clock-names = "mclk";
> +       clocks = <&clock_cam 0>;
> +       clock-frequency = <24000000>;
> +
> +       port {
> +               s5k5bafx_ep: endpoint {
> +                       remote-endpoint = <&csis1_ep>;
> +                       data-lanes = <1>;
> +               };
> +       };
> +};

For the binding:

Acked-by: Pawel Moll <pawel.moll@arm.com>

As to the discussion about GPIO naming, I'll stand by the "call it what
it is called in the documentation" stanza...

Thanks!

Pawel


