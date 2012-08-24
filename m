Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17583 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030446Ab2HXVGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 17:06:38 -0400
Date: Fri, 24 Aug 2012 13:39:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 7/8] ir-rx51: Convert latency constraints to PM QoS
 API
Message-ID: <20120824203957.GC1303@atomide.com>
References: <1345820986-4597-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1345820986-4597-8-git-send-email-timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345820986-4597-8-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Timo Kokkonen <timo.t.kokkonen@iki.fi> [120824 08:11]:
> Convert the driver from the obsolete omap_pm_set_max_mpu_wakeup_lat
> API to the new PM QoS API. This allows the callback to be removed from
> the platform data structure.
> 
> The latency requirements are also adjusted to prevent the MPU from
> going into sleep mode. This is needed as the GP timers have no means
> to wake up the MPU once it has gone into sleep. The "side effect" is
> that from now on the driver actually works even if there is no
> background load keeping the MPU awake.
> 
> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>

This should get acked by Kevin ideally. Other than that:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |  2 --
>  drivers/media/rc/ir-rx51.c                   | 15 ++++++++++-----
>  include/media/ir-rx51.h                      |  2 --
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index ca07264..e0750cb 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -34,7 +34,6 @@
>  #include <plat/gpmc.h>
>  #include <plat/onenand.h>
>  #include <plat/gpmc-smc91x.h>
> -#include <plat/omap-pm.h>
>  
>  #include <mach/board-rx51.h>
>  
> @@ -1227,7 +1226,6 @@ static void __init rx51_init_tsc2005(void)
>  
>  #if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
>  static struct lirc_rx51_platform_data rx51_lirc_data = {
> -	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
>  	.pwm_timer = 9, /* Use GPT 9 for CIR */
>  };
>  
> diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
> index 6e1ffa6..008cdab 100644
> --- a/drivers/media/rc/ir-rx51.c
> +++ b/drivers/media/rc/ir-rx51.c
> @@ -25,6 +25,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/sched.h>
>  #include <linux/wait.h>
> +#include <linux/pm_qos.h>
>  
>  #include <plat/dmtimer.h>
>  #include <plat/clock.h>
> @@ -49,6 +50,7 @@ struct lirc_rx51 {
>  	struct omap_dm_timer *pulse_timer;
>  	struct device	     *dev;
>  	struct lirc_rx51_platform_data *pdata;
> +	struct pm_qos_request	pm_qos_request;
>  	wait_queue_head_t     wqueue;
>  
>  	unsigned long	fclk_khz;
> @@ -268,10 +270,14 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>  		lirc_rx51->wbuf[count] = -1; /* Insert termination mark */
>  
>  	/*
> -	 * Adjust latency requirements so the device doesn't go in too
> -	 * deep sleep states
> +	 * If the MPU is going into too deep sleep state while we are
> +	 * transmitting the IR code, timers will not be able to wake
> +	 * up the MPU. Thus, we need to set a strict enough latency
> +	 * requirement in order to ensure the interrupts come though
> +	 * properly.
>  	 */
> -	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
> +	pm_qos_add_request(&lirc_rx51->pm_qos_request,
> +			PM_QOS_CPU_DMA_LATENCY,	10);
>  
>  	lirc_rx51_on(lirc_rx51);
>  	lirc_rx51->wbuf_index = 1;
> @@ -292,8 +298,7 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>  	 */
>  	lirc_rx51_stop_tx(lirc_rx51);
>  
> -	/* We can sleep again */
> -	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
> +	pm_qos_remove_request(&lirc_rx51->pm_qos_request);
>  
>  	return n;
>  }
> diff --git a/include/media/ir-rx51.h b/include/media/ir-rx51.h
> index 104aa89..57523f2 100644
> --- a/include/media/ir-rx51.h
> +++ b/include/media/ir-rx51.h
> @@ -3,8 +3,6 @@
>  
>  struct lirc_rx51_platform_data {
>  	int pwm_timer;
> -
> -	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
>  };
>  
>  #endif
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
