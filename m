Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52962 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753269AbeDPJyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 05:54:22 -0400
Date: Mon, 16 Apr 2018 06:54:15 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] media: Revert cleanup ktime_set() usage
Message-ID: <20180416065415.38f5ef37@vento.lan>
In-Reply-To: <1523662294-17971-1-git-send-email-jasmin@anw.at>
References: <1523662294-17971-1-git-send-email-jasmin@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Apr 2018 01:31:34 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> From: Jasmin Jessich <jasmin@anw.at>
> 
> This reverts 8b0e195314fa, because this will not compile for Kernels
> older than 4.10.

This patch looks fine, but not for the above-mentioned.

The thing is that it is not consistent to have some places with
things like:
	timeout = ktime_set(1, ir->polling * 1000000);

and others with:
	timeout = ir->polling * 1000000;

We should either use ktime_set() everywhere or remove it as a whole.
My preference is to keep using it, as it makes it better documented.
In any case, gcc should be smart enough to discard multiply by a
zero constant when evaluating ktime_set() macro (if not, it is a gcc
issue).

The fact that it makes maintainership of the media_build backport
tree easier is just a plus, but it makes no sense upstream.

> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>
> ---
>  drivers/media/dvb-core/dmxdev.c     | 2 +-
>  drivers/media/pci/cx88/cx88-input.c | 6 ++++--
>  drivers/media/pci/pt3/pt3.c         | 2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index 61a750f..cb078d6 100644
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -622,7 +622,7 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
>  				 struct dmxdev_filter *filter,
>  				 struct dmxdev_feed *feed)
>  {
> -	ktime_t timeout = 0;
> +	ktime_t timeout = ktime_set(0, 0);
>  	struct dmx_pes_filter_params *para = &filter->params.pes;
>  	enum dmx_output otype;
>  	int ret;
> diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
> index 6f4e692..b13243d 100644
> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -180,7 +180,8 @@ static enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
>  	struct cx88_IR *ir = container_of(timer, struct cx88_IR, timer);
>  
>  	cx88_ir_handle_key(ir);
> -	missed = hrtimer_forward_now(&ir->timer, ir->polling * 1000000LL);
> +	missed = hrtimer_forward_now(&ir->timer,
> +				     ktime_set(0, ir->polling * 1000000));
>  	if (missed > 1)
>  		ir_dprintk("Missed ticks %ld\n", missed - 1);
>  
> @@ -200,7 +201,8 @@ static int __cx88_ir_start(void *priv)
>  	if (ir->polling) {
>  		hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  		ir->timer.function = cx88_ir_work;
> -		hrtimer_start(&ir->timer, ir->polling * 1000000LL,
> +		hrtimer_start(&ir->timer,
> +			      ktime_set(0, ir->polling * 1000000),
>  			      HRTIMER_MODE_REL);
>  	}
>  	if (ir->sampling) {
> diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
> index da74828..8ced807 100644
> --- a/drivers/media/pci/pt3/pt3.c
> +++ b/drivers/media/pci/pt3/pt3.c
> @@ -464,7 +464,7 @@ static int pt3_fetch_thread(void *data)
>  
>  		pt3_proc_dma(adap);
>  
> -		delay = PT3_FETCH_DELAY * NSEC_PER_MSEC;
> +		delay = ktime_set(0, PT3_FETCH_DELAY * NSEC_PER_MSEC);
>  		set_current_state(TASK_UNINTERRUPTIBLE);
>  		freezable_schedule_hrtimeout_range(&delay,
>  					PT3_FETCH_DELAY_DELTA * NSEC_PER_MSEC,



Thanks,
Mauro
