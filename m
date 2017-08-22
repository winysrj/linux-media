Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33794 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbdHVSfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 14:35:39 -0400
Subject: Re: [PATCH v2 1/3] dt: bindings: Document DT bindings for Analog
 devices as3645a
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170819212410.3084-1-sakari.ailus@linux.intel.com>
 <20170819212410.3084-2-sakari.ailus@linux.intel.com>
Cc: javier@dowhile0.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <93a8cb02-2eb9-e0d5-ec0f-b39193ccccf5@gmail.com>
Date: Tue, 22 Aug 2017 20:34:54 +0200
MIME-Version: 1.0
In-Reply-To: <20170819212410.3084-2-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the update.

On 08/19/2017 11:24 PM, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../devicetree/bindings/leds/ams,as3645a.txt       | 71 ++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
> 
> diff --git a/Documentation/devicetree/bindings/leds/ams,as3645a.txt b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
> new file mode 100644
> index 000000000000..12c5ef26ec73
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
> @@ -0,0 +1,71 @@
> +Analog devices AS3645A device tree bindings
> +
> +The AS3645A flash LED controller can drive two LEDs, one high current
> +flash LED and one indicator LED. The high current flash LED can be
> +used in torch mode as well.
> +
> +Ranges below noted as [a, b] are closed ranges between a and b, i.e. a
> +and b are included in the range.
> +
> +Please also see common.txt in the same directory.
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
> +Optional properties of the "flash" child node
> +=============================================
> +
> +label		: The label of the flash LED.
> +
> +
> +Required properties of the "indicator" child node
> +=================================================
> +
> +led-max-microamp: Maximum indicator current. The allowed values are
> +		  2500, 5000, 7500 and 10000.
> +
> +Optional properties of the "indicator" child node
> +=================================================
> +
> +label		: The label of the indicator LED.
> +
> +
> +Example
> +=======
> +
> +	as3645a@30 {
> +		reg = <0x30>;
> +		compatible = "ams,as3645a";
> +		flash {
> +			flash-timeout-us = <150000>;
> +			flash-max-microamp = <320000>;
> +			led-max-microamp = <60000>;
> +			ams,input-max-microamp = <1750000>;
> +			label = "as3645a:flash";
> +		};
> +		indicator {
> +			led-max-microamp = <10000>;
> +			label = "as3645a:indicator";
> +		};
> +	};
> 

For the patch going through media tree:

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
