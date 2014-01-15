Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:35940 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAOTgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 14:36:15 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZG00DZ4JSE3410@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Jan 2014 14:36:14 -0500 (EST)
Date: Wed, 15 Jan 2014 17:35:59 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti =?UTF-8?B?U2VwcMOkbMOk?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] nuvoton-cir: Add support for user configurable wake-up
 codes
Message-id: <20140115173559.7e53239a@samsung.com>
In-reply-to: <1388758723-21653-1-git-send-email-a.seppala@gmail.com>
References: <1388758723-21653-1-git-send-email-a.seppala@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  3 Jan 2014 16:18:43 +0200
Antti Seppälä <a.seppala@gmail.com> escreveu:

> This patch introduces module parameters for setting wake-up codes to be
> programmed into the hardware FIFO. This allows users to provide custom
> IR sample sequences to trigger system wake-up from sleep states.
> 
> Usage:
>    modprobe nuvoton-cir wake_samples=0x90,0x11,0xa1... (up to 67 bytes)
> 
> Here is a summary of module parameters introduced by this patch:
>  * wake_samples: FIFO values to compare against received IR codes when
>    in sleep state.
> 
>  * cmp_deep: Number of bytes the hardware will compare against. This is
>    currently autodetected by the driver.
> 
>  * cmp_tolerance: The maximum allowed value difference between a single
>    wake-up byte and a sample read from IR to be still considered a match.
>    Default is 5.

Instead of adding it as a modprobe parameter, the better is to create
an special sysfs node for devices that support wake up.

Btw, there's another device driver also requiring a similar feature.

Regards,
Mauro

> 
> Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
> ---
>  drivers/media/rc/nuvoton-cir.c | 65 +++++++++++++++++++++++++++++++-----------
>  drivers/media/rc/nuvoton-cir.h |  6 ++--
>  2 files changed, 51 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 21ee0dc..b11ee43 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -39,6 +39,15 @@
>  
>  #include "nuvoton-cir.h"
>  
> +/* debugging module parameter */
> +static int debug;
> +
> +/* Wake up configuration parameters */
> +static unsigned char wake_samples[WAKE_FIFO_LEN];
> +static unsigned int num_wake_samples;
> +static unsigned char cmp_deep;
> +static unsigned char cmp_tolerance = CIR_WAKE_CMP_TOLERANCE;
> +
>  /* write val to config reg */
>  static inline void nvt_cr_write(struct nvt_dev *nvt, u8 val, u8 reg)
>  {
> @@ -418,13 +427,38 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
>  
>  static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
>  {
> +	int i;
> +	u8 cmp_reg = CIR_WAKE_FIFO_CMP_BYTES;
> +	u8 ircon_reg = CIR_WAKE_IRCON_RXEN | CIR_WAKE_IRCON_R |
> +		       CIR_WAKE_IRCON_RXINV | CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL;
> +	/*
> +	 * Enable TX and RX, specific carrier on = low, off = high, and set
> +	 * sample period (currently 50us)
> +	 */
> +	nvt_cir_wake_reg_write(nvt, ircon_reg | CIR_WAKE_IRCON_MODE1,
> +			       CIR_WAKE_IRCON);
> +
> +	/* clear cir wake rx fifo */
> +	nvt_clear_cir_wake_fifo(nvt);
> +
> +	/* Write samples from module parameter to fifo */
> +	for (i = 0; i < num_wake_samples; i++)
> +		nvt_cir_wake_reg_write(nvt, wake_samples[i],
> +				       CIR_WAKE_WR_FIFO_DATA);
> +
> +	/* Switch cir to wakeup mode and disable fifo writing */
> +	nvt_cir_wake_reg_write(nvt, ircon_reg | CIR_WAKE_IRCON_MODE0,
> +			       CIR_WAKE_IRCON);
> +
>  	/* set number of bytes needed for wake from s3 (default 65) */
> -	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFO_CMP_BYTES,
> -			       CIR_WAKE_FIFO_CMP_DEEP);
> +	if (cmp_deep)
> +		cmp_reg = cmp_deep;
> +	else if (num_wake_samples)
> +		cmp_reg = num_wake_samples;
> +	nvt_cir_wake_reg_write(nvt, cmp_reg, CIR_WAKE_FIFO_CMP_DEEP);
>  
>  	/* set tolerance/variance allowed per byte during wake compare */
> -	nvt_cir_wake_reg_write(nvt, CIR_WAKE_CMP_TOLERANCE,
> -			       CIR_WAKE_FIFO_CMP_TOL);
> +	nvt_cir_wake_reg_write(nvt, cmp_tolerance, CIR_WAKE_FIFO_CMP_TOL);
>  
>  	/* set sample limit count (PE interrupt raised when reached) */
>  	nvt_cir_wake_reg_write(nvt, CIR_RX_LIMIT_COUNT >> 8, CIR_WAKE_SLCH);
> @@ -434,18 +468,6 @@ static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
>  	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFOCON_RX_TRIGGER_LEV,
>  			       CIR_WAKE_FIFOCON);
>  
> -	/*
> -	 * Enable TX and RX, specific carrier on = low, off = high, and set
> -	 * sample period (currently 50us)
> -	 */
> -	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 | CIR_WAKE_IRCON_RXEN |
> -			       CIR_WAKE_IRCON_R | CIR_WAKE_IRCON_RXINV |
> -			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL,
> -			       CIR_WAKE_IRCON);
> -
> -	/* clear cir wake rx fifo */
> -	nvt_clear_cir_wake_fifo(nvt);
> -
>  	/* clear any and all stray interrupts */
>  	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
>  }
> @@ -1232,6 +1254,17 @@ static void nvt_exit(void)
>  module_param(debug, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Enable debugging output");
>  
> +module_param_array(wake_samples, byte, &num_wake_samples, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(wake_samples, "FIFO sample bytes triggering wake");
> +
> +module_param(cmp_deep, byte, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(cmp_deep, "How many bytes need to compare\n"
> +			   "\t\t(0 = auto (default))");
> +
> +module_param(cmp_tolerance, byte, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(cmp_tolerance, "Data tolerance to each wake sample byte\n"
> +				"\t\t(default = 5)");
> +
>  MODULE_DEVICE_TABLE(pnp, nvt_ids);
>  MODULE_DESCRIPTION("Nuvoton W83667HG-A & W83677HG-I CIR driver");
>  
> diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
> index 07e8310..8209f84 100644
> --- a/drivers/media/rc/nuvoton-cir.h
> +++ b/drivers/media/rc/nuvoton-cir.h
> @@ -31,10 +31,6 @@
>  /* platform driver name to register */
>  #define NVT_DRIVER_NAME "nuvoton-cir"
>  
> -/* debugging module parameter */
> -static int debug;
> -
> -
>  #define nvt_pr(level, text, ...) \
>  	printk(level KBUILD_MODNAME ": " text, ## __VA_ARGS__)
>  
> @@ -64,6 +60,8 @@ static int debug;
>  #define TX_BUF_LEN 256
>  #define RX_BUF_LEN 32
>  
> +#define WAKE_FIFO_LEN 67
> +
>  struct nvt_dev {
>  	struct pnp_dev *pdev;
>  	struct rc_dev *rdev;


-- 

Cheers,
Mauro
