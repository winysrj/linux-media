Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33445 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbcFNWFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:05:19 -0400
Date: Tue, 14 Jun 2016 17:05:17 -0500
From: Rob Herring <robh@kernel.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	pavel@ucw.cz, linux-media@vger.kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] media: et8ek8: Add documentation
Message-ID: <20160614220517.GA23504@rob-hp-laptop>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1465659593-16858-3-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465659593-16858-3-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 11, 2016 at 06:39:53PM +0300, Ivaylo Dimitrov wrote:
> Add DT bindings description

Not exactly the best commit msg.

> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>  .../bindings/media/i2c/toshiba,et8ek8.txt          | 50 ++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> new file mode 100644
> index 0000000..997d268
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> @@ -0,0 +1,50 @@
> +Toshiba et8ek8 5MP sensor
> +
> +Toshiba et8ek8 5MP sensor is an image sensor found in Nokia N900 device
> +
> +More detailed documentation can be found in
> +Documentation/devicetree/bindings/media/video-interfaces.txt .
> +
> +
> +Mandatory properties
> +--------------------
> +
> +- compatible: "toshiba,et8ek8"
> +- reg: I2C address (0x3e, or an alternative address)
> +- vana-supply: Analogue voltage supply (VANA), 2.8 volts

> +- clocks: External clock to the sensor
> +- clock-frequency: Frequency of the external clock to the sensor

These should be mutually-exclusive. If you have a clock, then you can 
get the frequency at runtime.

Rob
