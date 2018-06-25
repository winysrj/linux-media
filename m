Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55961 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753921AbeFYIHI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 04:07:08 -0400
Date: Mon, 25 Jun 2018 11:06:57 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: alanx.chiang@intel.com
Cc: linux-media@vger.kernel.org, andy.yeh@intel.com,
        andriy.shevchenko@intel.com, rajmohan.mani@intel.com
Subject: Re: [RESEND PATCH v1 2/2] dt-bindings: at24: Add address-width
 property
Message-ID: <20180625080657.pb3oksaqgu7xapa4@paasikivi.fi.intel.com>
References: <1529911783-28576-1-git-send-email-alanx.chiang@intel.com>
 <1529911783-28576-3-git-send-email-alanx.chiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529911783-28576-3-git-send-email-alanx.chiang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2018 at 03:29:43PM +0800, alanx.chiang@intel.com wrote:
> From: "alanx.chiang" <alanx.chiang@intel.com>
> 
> The AT24 series chips use 8-bit address by default. If some
> chips would like to support more than 8 bits, the at24 driver
> should be added the compatible field for specfic chips.
> 
> Provide a flexible way to determine the addressing bits through
> address-width in this patch.
> 
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> Reviewed-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  Documentation/devicetree/bindings/eeprom/at24.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/eeprom/at24.txt b/Documentation/devicetree/bindings/eeprom/at24.txt
> index 61d833a..5879259 100644
> --- a/Documentation/devicetree/bindings/eeprom/at24.txt
> +++ b/Documentation/devicetree/bindings/eeprom/at24.txt
> @@ -72,6 +72,8 @@ Optional properties:
>  
>    - wp-gpios: GPIO to which the write-protect pin of the chip is connected.
>  
> +  - address-width : number of address bits (one of 8, 16).
> +
>  Example:
>  
>  eeprom@52 {
> @@ -79,4 +81,5 @@ eeprom@52 {
>  	reg = <0x52>;
>  	pagesize = <32>;
>  	wp-gpios = <&gpio1 3 0>;
> +	address-width = <16>;

Since we're only now adding address-width, it hasn't been needed
previously. Therefore I wouldn't add it to an example.

>  };

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
