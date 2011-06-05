Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108Ab1FEMwZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jun 2011 08:52:25 -0400
Message-ID: <4DEB7C01.3050905@redhat.com>
Date: Sun, 05 Jun 2011 09:52:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, skandalfo@gmail.com
Subject: Re: [PATCH] rc-core: fix winbond-cir issues
References: <20110330141952.11373.16400.stgit@felix.hardeman.nu>
In-Reply-To: <20110330141952.11373.16400.stgit@felix.hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-03-2011 11:20, David Härdeman escreveu:
> The conversion of winbond-cir to use rc-core seems to have missed a
> a few bits and pieces which were in my local tree. Kudos to
> Juan Jesús García de Soria Lucena <skandalfo@gmail.com> for noticing.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

Hi David,

This patch got missed by patchwork. I'm applying it right now on my tree.
Please check if is there anything else missed.

Thanks,
Mauro.

> ---
>  drivers/media/rc/winbond-cir.c |   20 +++++---------------
>  1 files changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
> index 186de55..16f4178 100644
> --- a/drivers/media/rc/winbond-cir.c
> +++ b/drivers/media/rc/winbond-cir.c
> @@ -7,7 +7,7 @@
>   *  with minor modifications.
>   *
>   *  Original Author: David H�rdeman <david@hardeman.nu>
> - *     Copyright (C) 2009 - 2010 David H�rdeman <david@hardeman.nu>
> + *     Copyright (C) 2009 - 2011 David H�rdeman <david@hardeman.nu>
>   *
>   *  Dedicated to my daughter Matilda, without whose loving attention this
>   *  driver would have been finished in half the time and with a fraction
> @@ -629,18 +629,8 @@ wbcir_init_hw(struct wbcir_data *data)
>  	/* prescaler 1.0, tx/rx fifo lvl 16 */
>  	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
>  
> -	/* Set baud divisor to generate one byte per bit/cell */
> -	switch (protocol) {
> -	case IR_PROTOCOL_RC5:
> -		outb(0xA7, data->sbase + WBCIR_REG_SP3_BGDL);
> -		break;
> -	case IR_PROTOCOL_RC6:
> -		outb(0x53, data->sbase + WBCIR_REG_SP3_BGDL);
> -		break;
> -	case IR_PROTOCOL_NEC:
> -		outb(0x69, data->sbase + WBCIR_REG_SP3_BGDL);
> -		break;
> -	}
> +	/* Set baud divisor to sample every 10 us */
> +	outb(0x0F, data->sbase + WBCIR_REG_SP3_BGDL);
>  	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
>  
>  	/* Set CEIR mode */
> @@ -649,9 +639,9 @@ wbcir_init_hw(struct wbcir_data *data)
>  	inb(data->sbase + WBCIR_REG_SP3_LSR); /* Clear LSR */
>  	inb(data->sbase + WBCIR_REG_SP3_MSR); /* Clear MSR */
>  
> -	/* Disable RX demod, run-length encoding/decoding, set freq span */
> +	/* Disable RX demod, enable run-length enc/dec, set freq span */
>  	wbcir_select_bank(data, WBCIR_BANK_7);
> -	outb(0x10, data->sbase + WBCIR_REG_SP3_RCCFG);
> +	outb(0x90, data->sbase + WBCIR_REG_SP3_RCCFG);
>  
>  	/* Disable timer */
>  	wbcir_select_bank(data, WBCIR_BANK_4);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

