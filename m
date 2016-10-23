Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34353 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754925AbcJWRG3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 13:06:29 -0400
Subject: Re: [PATCH 1/1] [media] ite-cir: initialize use_demodulator before
 using it
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20160910165949.3507-1-nicolas.iooss_linux@m4x.org>
Cc: linux-kernel@vger.kernel.org
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-ID: <6c5b02a0-dff7-0244-657f-61621b73c66a@m4x.org>
Date: Sun, 23 Oct 2016 19:06:24 +0200
MIME-Version: 1.0
In-Reply-To: <20160910165949.3507-1-nicolas.iooss_linux@m4x.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I sent the following patch (available on
https://patchwork.kernel.org/patch/9325039/) a few weeks ago and got no
feedback even though the bug it fixes seems to still exist in
linux-next. Did I do something wrong, like sending to the wrong maintainers?

Thanks,
Nicolas

On 10/09/16 18:59, Nicolas Iooss wrote:
> Function ite_set_carrier_params() uses variable use_demodulator after
> having initialized it to false in some if branches, but this variable is
> never set to true otherwise.
> 
> This bug has been found using clang -Wsometimes-uninitialized warning
> flag.
> 
> Fixes: 620a32bba4a2 ("[media] rc: New rc-based ite-cir driver for
> several ITE CIRs")
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> ---
>  drivers/media/rc/ite-cir.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> index 0f301903aa6f..63165d324fff 100644
> --- a/drivers/media/rc/ite-cir.c
> +++ b/drivers/media/rc/ite-cir.c
> @@ -263,6 +263,8 @@ static void ite_set_carrier_params(struct ite_dev *dev)
>  
>  			if (allowance > ITE_RXDCR_MAX)
>  				allowance = ITE_RXDCR_MAX;
> +
> +			use_demodulator = true;
>  		}
>  	}
>  
> 

