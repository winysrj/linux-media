Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1IURd5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 13:33:57 -0400
Message-ID: <4E7A1360.8060706@redhat.com>
Date: Wed, 21 Sep 2011 13:40:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: jarod@wilsonet.com
CC: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/10] rc-core: move timeout and checks to lirc
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <20110428151403.8272.25977.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151403.8272.25977.stgit@felix.hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-04-2011 12:14, David Härdeman escreveu:
> The lirc TX functionality expects the process which writes (TX) data to
> the lirc dev to sleep until the actual data has been transmitted by the
> hardware.
> 
> Since the same timeout calculation is duplicated in more than one driver
> (and would have to be duplicated in even more drivers as they gain TX
> support), it makes sense to move this timeout calculation to the lirc
> layer instead.
> 
> At the same time, centralize some of the sanity checks.

This patch[1] were never applied, nor I'm seeing any comments about it
at the ML.

Jarod, 

would you care to review it?

Thanks,
Mauro

[1] http://patchwork.linuxtv.org/patch/6468/


> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/ir-lirc-codec.c |   33 +++++++++++++++++++++++++++++----
>  drivers/media/rc/mceusb.c        |   18 ------------------
>  drivers/media/rc/rc-loopback.c   |   12 ------------
>  3 files changed, 29 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index ac54139..a58c7fe 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -106,6 +106,12 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
>  	unsigned int *txbuf; /* buffer with values to transmit */
>  	ssize_t ret = 0;
>  	size_t count;
> +	ktime_t start;
> +	s64 towait;
> +	unsigned int duration = 0; /* signal duration in us */
> +	int i;
> +
> +	start = ktime_get();
>  
>  	lirc = lirc_get_pdata(file);
>  	if (!lirc)
> @@ -128,11 +134,30 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
>  		goto out;
>  	}
>  
> -	if (dev->tx_ir)
> -		ret = dev->tx_ir(dev, txbuf, count);
> +	if (!dev->tx_ir) {
> +		ret = -ENOSYS;
> +		goto out;
> +	}
> +
> +	ret = dev->tx_ir(dev, txbuf, (u32)n);
> +	if (ret < 0)
> +		goto out;
> +
> +	for (i = 0; i < ret; i++)
> +		duration += txbuf[i];
>  
> -	if (ret > 0)
> -		ret *= sizeof(unsigned);
> +	ret *= sizeof(unsigned int);
> +
> +	/*
> +	 * The lircd gap calculation expects the write function to
> +	 * wait for the actual IR signal to be transmitted before
> +	 * returning.
> +	 */
> +	towait = ktime_us_delta(ktime_add_us(start, duration), ktime_get());
> +	if (towait > 0) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(usecs_to_jiffies(towait));
> +	}
>  
>  out:
>  	kfree(txbuf);
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index c1cd00d..7b08797 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -671,10 +671,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>  	int i, ret = 0;
>  	int cmdcount = 0;
>  	unsigned char *cmdbuf; /* MCE command buffer */
> -	long signal_duration = 0; /* Singnal length in us */
> -	struct timeval start_time, end_time;
> -
> -	do_gettimeofday(&start_time);
>  
>  	cmdbuf = kzalloc(sizeof(unsigned) * MCE_CMDBUF_SIZE, GFP_KERNEL);
>  	if (!cmdbuf)
> @@ -687,7 +683,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>  
>  	/* Generate mce packet data */
>  	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
> -		signal_duration += txbuf[i];
>  		txbuf[i] = txbuf[i] / MCE_TIME_UNIT;
>  
>  		do { /* loop to support long pulses/spaces > 127*50us=6.35ms */
> @@ -730,19 +725,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>  	/* Transmit the command to the mce device */
>  	mce_async_out(ir, cmdbuf, cmdcount);
>  
> -	/*
> -	 * The lircd gap calculation expects the write function to
> -	 * wait the time it takes for the ircommand to be sent before
> -	 * it returns.
> -	 */
> -	do_gettimeofday(&end_time);
> -	signal_duration -= (end_time.tv_usec - start_time.tv_usec) +
> -			   (end_time.tv_sec - start_time.tv_sec) * 1000000;
> -
> -	/* delay with the closest number of ticks */
> -	set_current_state(TASK_INTERRUPTIBLE);
> -	schedule_timeout(usecs_to_jiffies(signal_duration));
> -
>  out:
>  	kfree(cmdbuf);
>  	return ret ? ret : count;
> diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
> index fb8ca81..5cb7057 100644
> --- a/drivers/media/rc/rc-loopback.c
> +++ b/drivers/media/rc/rc-loopback.c
> @@ -105,18 +105,9 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>  {
>  	struct loopback_dev *lodev = dev->priv;
>  	u32 rxmask;
> -	unsigned total_duration = 0;
>  	unsigned i;
>  	DEFINE_IR_RAW_EVENT(rawir);
>  
> -	for (i = 0; i < count; i++)
> -		total_duration += abs(txbuf[i]);
> -
> -	if (total_duration == 0) {
> -		dprintk("invalid tx data, total duration zero\n");
> -		return -EINVAL;
> -	}
> -
>  	if (lodev->txcarrier < lodev->rxcarriermin ||
>  	    lodev->txcarrier > lodev->rxcarriermax) {
>  		dprintk("ignoring tx, carrier out of range\n");
> @@ -148,9 +139,6 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>  	ir_raw_event_handle(dev);
>  
>  out:
> -	/* Lirc expects this function to take as long as the total duration */
> -	set_current_state(TASK_INTERRUPTIBLE);
> -	schedule_timeout(usecs_to_jiffies(total_duration));
>  	return count;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

