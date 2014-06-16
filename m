Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:21216 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaFPM3G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 08:29:06 -0400
Message-ID: <539EE30C.4060502@eukrea.com>
Date: Mon, 16 Jun 2014 14:29:00 +0200
From: Denis Carikli <denis@eukrea.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: devel@driverdev.osuosl.org, Russell King <linux@arm.linux.org.uk>,
	=?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v14 09/10] ARM: dts: mbimx51sd: Add display support.
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-9-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-9-git-send-email-denis@eukrea.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2014 12:11 PM, Denis Carikli wrote:> +	reg_lcd_3v3: lcd-en {
 > +		compatible = "regulator-fixed";
 > +		pinctrl-names = "default";
 > +		pinctrl-0 = <&pinctrl_reg_lcd_3v3>;
 > +		regulator-name = "lcd-3v3";
 > +		regulator-min-microvolt = <3300000>;
 > +		regulator-max-microvolt = <3300000>;
 > +		gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
 > +		regulator-boot-on;
 > +	};
 > +};
This is wrong, I'll fix it in the next serie.

What it really does is to make regulator-fixed think that the gpio is 
active low, the bindings documentation(fixed-regulator.txt) says:
 > - enable-active-high: Polarity of GPIO is Active high
 > If this property is missing, the default assumed is Active low.

Then regulator-boot-on will make it think that the regulator is already 
on and so the regulator will be disabled.
 From the bindings documentation (regulator.txt):
 > regulator-boot-on: bootloader/firmware enabled regulator

Which result at the lcd regulator being physically powered on at boot.
I didn't see that because powering it on at boot is what I want.

How can I do that beside doing it in userspace by issuing the following 
commands:
echo 4 > /sys/devices/display-subsystem/graphics/fb0/blank
echo 0 > /sys/devices/display-subsystem/graphics/fb0/blank

Denis.
