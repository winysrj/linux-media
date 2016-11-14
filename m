Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35604 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbcKNQUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 11:20:22 -0500
Date: Mon, 14 Nov 2016 10:20:20 -0600
From: Rob Herring <robh@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sakari.ailus@iki.fi, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: et8ek8: add device tree binding documentation
Message-ID: <20161114162020.sxf6bew7vg7mkwnt@rob-hp-laptop>
References: <20161023191706.GA25754@amd>
 <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
 <20161107104648.GB5326@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161107104648.GB5326@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 07, 2016 at 11:46:48AM +0100, Pavel Machek wrote:
> Add device tree binding documentation for toshiba et8ek8 sensor.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> new file mode 100644
> index 0000000..b03b21d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> @@ -0,0 +1,53 @@
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
> +- clock-frequency: Frequency of the external clock to the sensor. Camera
> +  driver will set this frequency on the external clock. The clock frequency is
> +  a pre-determined frequency known to be suitable to the board.
> +- reset-gpios: XSHUTDOWN GPIO. The XSHUTDOWN signal is active high. The sensor
> +  is in hardware standby mode when the signal is in low state.

Sounds like active low to me. "Active" means when is the defined 
function of the pin enabled, not when is the chip active/enabled. So in 
this case reset or shutdown is active when low.

Rob
