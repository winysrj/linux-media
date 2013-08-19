Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:57661 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3HSNZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 09:25:44 -0400
Message-ID: <1376918739.3157.9.camel@hornet>
Subject: Re: [PATCH RFC v5] s5k5baf: add camera sensor driver
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
Date: Mon, 19 Aug 2013 14:25:39 +0100
In-Reply-To: <1376918307-21490-1-git-send-email-a.hajda@samsung.com>
References: <1376918307-21490-1-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2013-08-19 at 14:18 +0100, Andrzej Hajda wrote:
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> @@ -0,0 +1,51 @@
> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
> +-------------------------------------------------------------
> +
> +Required properties:
> +
> +- compatible     : "samsung,s5k5baf";
> +- reg            : I2C slave address of the sensor;
> +- vdda-supply    : analog power supply 2.8V (2.6V to 3.0V);
> +- vddreg-supply          : regulator input power supply 1.8V (1.7V to 1.9V)
> +                    or 2.8V (2.6V to 3.0);
> +- vddio-supply   : I/O power supply 1.8V (1.65V to 1.95V)
> +                    or 2.8V (2.5V to 3.1V);
> +- gpios                  : GPIOs connected to STDBYN and RSTN pins,
> +                    in order: STBYN, RSTN;

You probably want to use the "[<name>-]gpios" convention here (see
Documentation/devicetree/bindings/gpio/gpio.txt), so something like
stbyn-gpios and rstn-gpios.

Pawel


