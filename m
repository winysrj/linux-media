Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54244 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbaH2OZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 10:25:41 -0400
Date: Fri, 29 Aug 2014 15:25:18 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
	"lars@metafoo.de" <lars@metafoo.de>,
	"w.sang@pengutronix.de" <w.sang@pengutronix.de>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/2] adv7604: Use DT parsing in dummy creation
Message-ID: <20140829142518.GA27331@leverpostej>
References: <1409318897-12668-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <1409318897-12668-2-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409318897-12668-2-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Aug 29, 2014 at 02:28:17PM +0100, Jean-Michel Hautbois wrote:
> This patch uses DT in order to parse addresses for dummy devices of adv7604.
> If nothing is defined, it uses default addresses.
> The main prupose is using two adv76xx on the same i2c bus.

This is rather opaque.

It seems from the code below that a single adv7611 device has multiple
I2C addresses at which different registers may be accessed. I guess the
secondary instances of the unit have different addresses for all of the
pages?

> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  .../devicetree/bindings/media/i2c/adv7604.txt      |  7 ++-
>  drivers/media/i2c/adv7604.c                        | 56 ++++++++++++++--------
>  2 files changed, 42 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> index c27cede..221b75c 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -10,6 +10,7 @@ Required Properties:
>  
>    - compatible: Must contain one of the following
>      - "adi,adv7611" for the ADV7611
> +    - "adi,adv7604" for the ADV7604
>  
>    - reg: I2C slave address

This should be updated, at least to say "address(es)".

>  
> @@ -32,6 +33,8 @@ The digital output port node must contain at least one endpoint.
>  Optional Properties:
>  
>    - reset-gpios: Reference to the GPIO connected to the device's reset pin.
> +  - reg-names : Names of registers to be reprogrammed.

This doesn't describe _which_ names you expect, and I have no idea what
is meant by "to be reprogrammed".

> +		Refer to source code for possible values.

Bindings shouldn't say things like this. The binding should describe the
contract between the DTB and the OS, which this clearly doesn't.

A binding document shouldn't necessitate reading code.

>  Optional Endpoint Properties:
>  
> @@ -50,7 +53,9 @@ Example:
>  
>  	hdmi_receiver@4c {
>  		compatible = "adi,adv7611";
> -		reg = <0x4c>;
> +		/* edid page will be accessible @ 0x66 on i2c bus*/
> +		reg = <0x4c 0x66>;
> +		reg-names = "main", "edid";

What about the other IDs? Are they accessible or not?

Why didn't we always list the full set of IDs in the first place? That
would have made this far less painful.

Thanks,
Mark.
