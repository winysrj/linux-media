Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60635 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1KQLPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 06:15:10 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: RE: [PATCH] board-dm646x-evm.c: wrong register used in
 setup_vpif_input_channel_mode
Date: Thu, 17 Nov 2011 11:15:01 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F75010801@DBDE01.ent.ti.com>
References: <1321294849-2738-1-git-send-email-hverkuil@xs4all.nl>
 <986dc5c6de4525aa3427ccded735d8e982080b0e.1321294701.git.hans.verkuil@cisco.com>
In-Reply-To: <986dc5c6de4525aa3427ccded735d8e982080b0e.1321294701.git.hans.verkuil@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,
 Thank you for the patch. I have verified from the data sheet. 
It might be a copy mistake. It also says the vpif_vsclkdis_reg
can be used to disable and enable in case we make any clock switches
so as to avoid glitches.
In this case I would imagine we would stream off before switching, so
That might not be a necessity.
I have not been able to test this however. Trust you would have.

Acked-by: Manjunath Hadli 
<manjunath.hadli@ti.com>


Thanks and Regards,
-Manju

On Mon, Nov 14, 2011 at 23:50:49, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The function setup_vpif_input_channel_mode() used the VSCLKDIS register instead of VIDCLKCTL. This meant that when in HD mode videoport channel 0 used a different clock from channel 1.
> 
> Clearly a copy-and-paste error.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  arch/arm/mach-davinci/board-dm646x-evm.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index 337c45e..607a527 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -563,7 +563,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
>  	int val;
>  	u32 value;
>  
> -	if (!vpif_vsclkdis_reg || !cpld_client)
> +	if (!vpif_vidclkctl_reg || !cpld_client)
>  		return -ENXIO;
>  
>  	val = i2c_smbus_read_byte(cpld_client); @@ -571,7 +571,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
>  		return val;
>  
>  	spin_lock_irqsave(&vpif_reg_lock, flags);
> -	value = __raw_readl(vpif_vsclkdis_reg);
> +	value = __raw_readl(vpif_vidclkctl_reg);
>  	if (mux_mode) {
>  		val &= VPIF_INPUT_TWO_CHANNEL;
>  		value |= VIDCH1CLK;
> @@ -579,7 +579,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
>  		val |= VPIF_INPUT_ONE_CHANNEL;
>  		value &= ~VIDCH1CLK;
>  	}
> -	__raw_writel(value, vpif_vsclkdis_reg);
> +	__raw_writel(value, vpif_vidclkctl_reg);
>  	spin_unlock_irqrestore(&vpif_reg_lock, flags);
>  
>  	err = i2c_smbus_write_byte(cpld_client, val);
> --
> 1.7.7
> 
> 

