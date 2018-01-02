Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33454 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751973AbeABMax (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 07:30:53 -0500
Date: Tue, 2 Jan 2018 14:30:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 3/4] meida: mt9m111: document missing required clocks
 property
Message-ID: <20180102123050.fmgwwo4si7gf6722@valkosipuli.retiisi.org.uk>
References: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
 <1513787614-12008-4-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513787614-12008-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thanks for the patchset.

On Thu, Dec 21, 2017 at 01:33:33AM +0900, Akinobu Mita wrote:
> The mt9m111 driver requires clocks property for the master clock to the
> sensor, but there is no description for that.  This adds it.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> index ed5a334..ffb57d1 100644
> --- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> @@ -6,6 +6,8 @@ interface.
>  
>  Required Properties:
>  - compatible: value should be "micron,mt9m111"
> +- clocks: reference to the master clock.
> +- clock-names: should be "mclk".

s/should/shall/

?

The subject could begin with "media: " but not with "meida: ". Mauro's
scripts will add it so you may equally well omit it altogether.

>  
>  For further reading on port node refer to
>  Documentation/devicetree/bindings/media/video-interfaces.txt.
> @@ -16,6 +18,8 @@ Example:
>  		mt9m111@5d {
>  			compatible = "micron,mt9m111";
>  			reg = <0x5d>;
> +			clocks = <&mclk>;
> +			clock-names = "mclk";
>  
>  			remote = <&pxa_camera>;
>  			port {

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
