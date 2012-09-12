Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:57031 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2ILSxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 14:53:55 -0400
Message-ID: <5050DA40.8050105@wwwdotorg.org>
Date: Wed, 12 Sep 2012 12:53:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] media: add V4L2 DT binding documentation
References: <Pine.LNX.4.64.1209111746420.22084@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209111746420.22084@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2012 09:51 AM, Guennadi Liakhovetski wrote:
> This patch adds a document, describing common V4L2 device tree bindings.
> 
> Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Overall, I think this looks pretty reasonable, so:

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Just a couple comments:

> +++ b/Documentation/devicetree/bindings/media/v4l2.txt

> +	ceu0: ceu@0xfe910000 {

> +		mclk: master_clock {
> +			compatible = "renesas,ceu-clock";
> +			#clock-cells = <1>;

Why 1? If there's only 1 clock output from this provider, I don't see a
need for any cells, unless there are some configuration flags?

> +			clock-frequency = <50000000>;	/* max clock frequency */
> +			clock-output-names = "mclk";
> +		};
> +
> +		port {
...
> +			ceu0_0: link@0 {
> +				reg = <0>;
> +				remote = <&csi2_2>;
> +				immutable;

Did we decide "immutable" was actually needed? Presumably the driver for
the HW in question knows the HW isn't configurable, and would simply not
attempt to apply any configuration even if the .dts author erroneously
provided some?

> +			};
> +		};
> +	};
> +
> +	i2c0: i2c@0xfff20000 {
...
> +		ov772x_1: camera@0x21 {
...
> +			clocks = <&mclk 0>;

So presumably that could just be "clocks = <&mclk>;"?
