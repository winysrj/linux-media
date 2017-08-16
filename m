Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35129 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbdHPU2L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 16:28:11 -0400
Subject: Re: [PATCH 1/3] dt: bindings: Document DT bindings for Analog devices
 as3645a
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
 <20170816125514.27634-1-sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <8b966328-138a-5777-f8b5-692e692567e8@gmail.com>
Date: Wed, 16 Aug 2017 22:27:27 +0200
MIME-Version: 1.0
In-Reply-To: <20170816125514.27634-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch. One issue below.

On 08/16/2017 02:55 PM, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../devicetree/bindings/leds/ams,as3645a.txt       | 56 ++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
> 
> diff --git a/Documentation/devicetree/bindings/leds/ams,as3645a.txt b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
> new file mode 100644
> index 000000000000..00066e3f9036
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
> @@ -0,0 +1,56 @@
> +Analog devices AS3645A device tree bindings
> +
> +The AS3645A flash LED controller can drive two LEDs, one high current
> +flash LED and one indicator LED. The high current flash LED can be
> +used in torch mode as well.
> +
> +Ranges below noted as [a, b] are closed ranges between a and b, i.e. a
> +and b are included in the range.
> +
> +
> +Required properties
> +===================
> +
> +compatible	: Must be "ams,as3645a".
> +reg		: The I2C address of the device. Typically 0x30.
> +
> +
> +Required properties of the "flash" child node
> +=============================================
> +
> +flash-timeout-us: Flash timeout in microseconds. The value must be in
> +		  the range [100000, 850000] and divisible by 50000.
> +flash-max-microamp: Maximum flash current in microamperes. Has to be
> +		    in the range between [200000, 500000] and
> +		    divisible by 20000.
> +led-max-microamp: Maximum torch (assist) current in microamperes. The
> +		  value must be in the range between [20000, 160000] and
> +		  divisible by 20000.
> +ams,input-max-microamp: Maximum flash controller input current. The
> +			value must be in the range [1250000, 2000000]
> +			and divisible by 50000.
> +
> +
> +Required properties of the "indicator" child node
> +=================================================
> +
> +led-max-microamp: Maximum indicator current. The allowed values are
> +		  2500, 5000, 7500 and 10000.

Most LED bindings mention also optional label property in the form:

- label : See Documentation/devicetree/bindings/leds/common.txt

> +
> +Example
> +=======
> +
> +	as3645a: flash@30 {
> +		reg = <0x30>;
> +		compatible = "ams,as3645a";
> +		flash {

			label = "as3645a:flash";

> +			flash-timeout-us = <150000>;
> +			flash-max-microamp = <320000>;
> +			led-max-microamp = <60000>;
> +			ams,input-max-microamp = <1750000>;
> +		};
> +		indicator {

			label = "as3645a:indicator";

> +			led-max-microamp = <10000>;
> +		};
> +	};
> 

-- 
Best regards,
Jacek Anaszewski
