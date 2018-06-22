Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34066 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754318AbeFVPEb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:04:31 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: "Chiang, AlanX" <alanx.chiang@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: RE: [v1, 2/2] dt-bindings: at24: Add address-width property
Date: Fri, 22 Jun 2018 15:00:28 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D6D4E29@PGSMSX111.gar.corp.intel.com>
References: <1529660799-19202-1-git-send-email-alanx.chiang@intel.com>
 <1529660799-19202-2-git-send-email-alanx.chiang@intel.com>
In-Reply-To: <1529660799-19202-2-git-send-email-alanx.chiang@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

Thanks for the patch set.
You should change the subject as below.
[PATCH v1, 1/2]
[PATCH v1, 2/2]

And I think you may missed to create a cover page. Please follow my BKM. Thanks.
git format-patch --cover --subject-prefix <version> -o <output folder> HEAD~n


Regards, Andy

> -----Original Message-----
> From: Chiang, AlanX
> Sent: Friday, June 22, 2018 5:47 PM
> To: linux-media@vger.kernel.org
> Cc: Yeh, Andy <andy.yeh@intel.com>; sakari.ailus@linux.intel.com;
> Shevchenko, Andriy <andriy.shevchenko@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Chiang, AlanX <alanx.chiang@intel.com>
> Subject: [v1, 2/2] dt-bindings: at24: Add address-width property
> 
> From: "alanx.chiang" <alanx.chiang@intel.com>
> 
> The AT24 series chips use 8-bit address by default. If some chips would like to
> support more than 8 bits, the at24 driver should be added the compatible
> field for specfic chips.
> 
> Provide a flexible way to determine the addressing bits through address-width
> in this patch.
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
> diff --git a/Documentation/devicetree/bindings/eeprom/at24.txt
> b/Documentation/devicetree/bindings/eeprom/at24.txt
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
>  };
> --
> 2.7.4
