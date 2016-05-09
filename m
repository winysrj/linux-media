Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58662 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbcEIUHD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 16:07:03 -0400
Date: Mon, 9 May 2016 15:06:57 -0500
From: Rob Herring <robh@kernel.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH 4/7] [media] ir-rx51: add DT support to driver
Message-ID: <20160509200657.GA3379@rob-hp-laptop>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462634508-24961-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 07, 2016 at 06:21:45PM +0300, Ivaylo Dimitrov wrote:
> With the upcoming removal of legacy boot, lets add support to one of the
> last N900 drivers remaining without it. As the driver still uses omap
> dmtimer, add auxdata as well.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>  .../devicetree/bindings/media/nokia,lirc-rx51         | 19 +++++++++++++++++++
>  arch/arm/mach-omap2/pdata-quirks.c                    |  6 +-----
>  drivers/media/rc/ir-rx51.c                            | 11 ++++++++++-
>  3 files changed, 30 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/nokia,lirc-rx51
> 
> diff --git a/Documentation/devicetree/bindings/media/nokia,lirc-rx51 b/Documentation/devicetree/bindings/media/nokia,lirc-rx51
> new file mode 100644
> index 0000000..5b3081e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/nokia,lirc-rx51
> @@ -0,0 +1,19 @@
> +Device-Tree bindings for LIRC TX driver for Nokia N900(RX51)
> +
> +Required properties:
> +	- compatible: should be "nokia,lirc-rx51".

lirc is a Linux term. Also, nokia,rx51-... would be conventional 
ordering.

Is this anything more than a PWM LED?

> +	- pwms: specifies PWM used for IR signal transmission.
> +
> +Example node:
> +
> +	pwm9: dmtimer-pwm@9 {
> +		compatible = "ti,omap-dmtimer-pwm";
> +		ti,timers = <&timer9>;
> +		#pwm-cells = <3>;
> +	};
> +
> +	ir: lirc-rx51 {
> +		compatible = "nokia,lirc-rx51";
> +
> +		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
> +	};
