Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42623 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752451AbeBZLbR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 06:31:17 -0500
Date: Mon, 26 Feb 2018 11:31:15 +0000
From: Sean Young <sean@mess.org>
To: James Hogan <jhogan@kernel.org>
Cc: linux-metag@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 12/13] media: img-ir: Drop METAG dependency
Message-ID: <20180226113114.jpewudrlez3pla2y@gofer.mess.org>
References: <20180221233825.10024-1-jhogan@kernel.org>
 <20180221233825.10024-13-jhogan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180221233825.10024-13-jhogan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 21, 2018 at 11:38:24PM +0000, James Hogan wrote:
> Now that arch/metag/ has been removed, remove the METAG dependency from
> the IMG IR device driver. The hardware is also present on MIPS SoCs so
> the driver still has value.
> 
> Signed-off-by: James Hogan <jhogan@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: linux-metag@vger.kernel.org

Acked-by: Sean Young <sean@mess.org>


> ---
>  drivers/media/rc/img-ir/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
> index a896d3c83a1c..d2c6617d468e 100644
> --- a/drivers/media/rc/img-ir/Kconfig
> +++ b/drivers/media/rc/img-ir/Kconfig
> @@ -1,7 +1,7 @@
>  config IR_IMG
>  	tristate "ImgTec IR Decoder"
>  	depends on RC_CORE
> -	depends on METAG || MIPS || COMPILE_TEST
> +	depends on MIPS || COMPILE_TEST
>  	select IR_IMG_HW if !IR_IMG_RAW
>  	help
>  	   Say Y or M here if you want to use the ImgTec infrared decoder
> -- 
> 2.13.6
