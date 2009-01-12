Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail00.svc.cra.dublin.eircom.net ([159.134.118.16])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jdonog01@eircom.net>) id 1LMSDg-0006Og-1R
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 20:13:07 +0100
From: John Donoghue <jdonog01@eircom.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1231719484.10277.4.camel@palomino.walls.org>
References: <20090109154005.3295d447@bk.ru>
	<1231719484.10277.4.camel@palomino.walls.org>
Date: Mon, 12 Jan 2009 19:12:29 +0000
Message-Id: <1231787549.5897.16.camel@john-desktop>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] cx88-dvb: Fix order of frontend allocations
 (Re:	 current v4l-dvb - cannot access /dev/dvb/: No such file or	directory)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, 2009-01-11 at 19:18 -0500, Andy Walls wrote:
> 
> 
> I don't have the hardware to test with.  Please try this patch.
> 
> Regards,
> Andy
> 
> 
> Signed-off-by: Andy Walls <awalls@radix.net>
> 
> diff -r a28c39659c25 linux/drivers/media/video/cx88/cx88-dvb.c
> --- a/linux/drivers/media/video/cx88/cx88-dvb.c	Sat Jan 10 16:04:45 2009 -0500
> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Sun Jan 11 19:13:10 2009 -0500
> @@ -621,33 +621,40 @@ static struct stv0288_config tevii_tuner
>  	.set_ts_params = cx24116_set_ts_param,
>  };
>  
> +static int cx8802_alloc_frontends(struct cx8802_dev *dev)
> +{
> +	struct cx88_core *core = dev->core;
> +	struct videobuf_dvb_frontend *fe = NULL;
> +	int i;
> +
> +	mutex_init(&dev->frontends.lock);
> +	INIT_LIST_HEAD(&dev->frontends.felist);
> +
> +	if (!core->board.num_frontends)
> +		return -ENODEV;
> +
> +	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
> +			 core->board.num_frontends);
> +	for (i = 1; i <= core->board.num_frontends; i++) {
> +		fe = videobuf_dvb_alloc_frontend(&dev->frontends, i);
> +		if (!fe) {
> +			printk(KERN_ERR "%s() failed to alloc\n", __func__);
> +			videobuf_dvb_dealloc_frontends(&dev->frontends);
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int dvb_register(struct cx8802_dev *dev)
>  {
>  	struct cx88_core *core = dev->core;
>  	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
>  	int mfe_shared = 0; /* bus not shared by default */
> -	int i;
>  
>  	if (0 != core->i2c_rc) {
>  		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
>  		goto frontend_detach;
> -	}
> -
> -	if (!core->board.num_frontends)
> -		return -EINVAL;
> -
> -	mutex_init(&dev->frontends.lock);
> -	INIT_LIST_HEAD(&dev->frontends.felist);
> -
> -	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
> -			 core->board.num_frontends);
> -	for (i = 1; i <= core->board.num_frontends; i++) {
> -		fe0 = videobuf_dvb_alloc_frontend(&dev->frontends, i);
> -		if (!fe0) {
> -			printk(KERN_ERR "%s() failed to alloc\n", __func__);
> -			videobuf_dvb_dealloc_frontends(&dev->frontends);
> -			goto frontend_detach;
> -		}
>  	}
>  
>  	/* Get the first frontend */
> @@ -1253,6 +1260,8 @@ static int cx8802_dvb_probe(struct cx880
>  	struct cx88_core *core = drv->core;
>  	struct cx8802_dev *dev = drv->core->dvbdev;
>  	int err;
> +	struct videobuf_dvb_frontend *fe;
> +	int i;
>  
>  	dprintk( 1, "%s\n", __func__);
>  	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
> @@ -1268,39 +1277,34 @@ static int cx8802_dvb_probe(struct cx880
>  	/* If vp3054 isn't enabled, a stub will just return 0 */
>  	err = vp3054_i2c_probe(dev);
>  	if (0 != err)
> -		goto fail_probe;
> +		goto fail_core;
>  
>  	/* dvb stuff */
>  	printk(KERN_INFO "%s/2: cx2388x based DVB/ATSC card\n", core->name);
>  	dev->ts_gen_cntrl = 0x0c;
>  
> +	err = cx8802_alloc_frontends(dev);
> +	if (err)
> +		goto fail_core;
> +
>  	err = -ENODEV;
> -	if (core->board.num_frontends) {
> -		struct videobuf_dvb_frontend *fe;
> -		int i;
> -
> -		for (i = 1; i <= core->board.num_frontends; i++) {
> -			fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
> -			if (fe == NULL) {
> -				printk(KERN_ERR "%s() failed to get frontend(%d)\n",
> +	for (i = 1; i <= core->board.num_frontends; i++) {
> +		fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
> +		if (fe == NULL) {
> +			printk(KERN_ERR "%s() failed to get frontend(%d)\n",
>  					__func__, i);
> -				goto fail_probe;
> -			}
> -			videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
> +			goto fail_probe;
> +		}
> +		videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
>  				    &dev->pci->dev, &dev->slock,
>  				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
>  				    V4L2_FIELD_TOP,
>  				    sizeof(struct cx88_buffer),
>  				    dev);
> -			/* init struct videobuf_dvb */
> -			fe->dvb.name = dev->core->name;
> -		}
> -	} else {
> -		/* no frontends allocated */
> -		printk(KERN_ERR "%s/2 .num_frontends should be non-zero\n",
> -			core->name);
> -		goto fail_core;
> +		/* init struct videobuf_dvb */
> +		fe->dvb.name = dev->core->name;
>  	}
> +
>  	err = dvb_register(dev);
>  	if (err)
>  		/* frontends/adapter de-allocated in dvb_register */
> 
> 
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

Andy,

Many thanks for the patch, which works for me on a Hauppauge
WinTV-Nova-S-Plus with both 2.6.27-7 and 2.6.27-9.  I had been getting
the oops with 2.6.27-9 only.

Your earlier message mentioned dvb_init() being called twice and running
concurrently.  I don't believe this is happening.  It appears twice on
the kernel call trace, because it has called both printk and
cx8802_register_driver, and neither of these calls has yet completed.

Regards,
John



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
