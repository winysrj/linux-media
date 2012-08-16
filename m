Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab2HPXMn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 19:12:43 -0400
Message-ID: <502D7E62.9040204@redhat.com>
Date: Thu, 16 Aug 2012 20:12:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [media] rc-core: move timeout and checks to lirc
References: <20120816221514.GA26546@pequod.mess.org>
In-Reply-To: <20120816221514.GA26546@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-08-2012 19:15, Sean Young escreveu:
>  
>> The lirc TX functionality expects the process which writes (TX) data to
>> the lirc dev to sleep until the actual data has been transmitted by the
>> hardware.
>>
>> Since the same timeout calculation is duplicated in more than one driver
>> (and would have to be duplicated in even more drivers as they gain TX
>> support), it makes sense to move this timeout calculation to the lirc
>> layer instead.
>>
>> At the same time, centralize some of the sanity checks.
>>
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>> Cc: Jarod Wilson <jwilson@redhat.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/rc/ir-lirc-codec.c | 33 +++++++++++++++++++++++++++++----
>>  drivers/media/rc/mceusb.c        | 18 ------------------
>>  drivers/media/rc/rc-loopback.c   | 12 ------------
>>  3 files changed, 29 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
>> index d2fd064..6ad4a07 100644
>> --- a/drivers/media/rc/ir-lirc-codec.c
>> +++ b/drivers/media/rc/ir-lirc-codec.c
>> @@ -107,6 +107,12 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>>  	unsigned int *txbuf; /* buffer with values to transmit */
>>  	ssize_t ret = -EINVAL;
>>  	size_t count;
>> +	ktime_t start;
>> +	s64 towait;
>> +	unsigned int duration = 0; /* signal duration in us */
>> +	int i;
>> +
>> +	start = ktime_get();
>>  
>>  	lirc = lirc_get_pdata(file);
>>  	if (!lirc)
>> @@ -129,11 +135,30 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>>  		goto out;
>>  	}
>>  
>> -	if (dev->tx_ir)
>> -		ret = dev->tx_ir(dev, txbuf, count);
>> +	if (!dev->tx_ir) {
>> +		ret = -ENOSYS;
>> +		goto out;
>> +	}
>> +
>> +	ret = dev->tx_ir(dev, txbuf, (u32)n);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	for (i = 0; i < ret; i++)
>> +		duration += txbuf[i];
>>  
>> -	if (ret > 0)
>> -		ret *= sizeof(unsigned);
>> +	ret *= sizeof(unsigned int);
>> +
>> +	/*
>> +	 * The lircd gap calculation expects the write function to
>> +	 * wait for the actual IR signal to be transmitted before
>> +	 * returning.
>> +	 */
>> +	towait = ktime_us_delta(ktime_add_us(start, duration), ktime_get());
>> +	if (towait > 0) {
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		schedule_timeout(usecs_to_jiffies(towait));
>> +	}
>>  
>>  out:
> 
> You've moved the sleeping out of the drivers to ir-lirc-codec, which makes
> sense for some devices. However you haven't updated winbond-cir.c which
> does two things:
> 
> 1) Modifies the txbuf (which is now used after transmit)
> 2) Does the sleeping already since it blocks on the device to complete.
> 
> Surely if the driver can block on the device to complete then that is 
> better than sleeping; there might some difference due to rounding and 
> clock skew.
> 
> In addition to winbond-cir, iguanair suffer from the same problem. There
> might be others.

That's likely my fault: I was waiting for Jarod's review on this patch,
with didn't happen, likely because he is too busy with some other stuff.
Both winbond and iguanair drivers went after David's patch.

Feel free to send me a patch fixing it there.

> Could we have a flag in rc_dev to signify whether a driver blocks on
> completion of a transmit and only sleep here if it is not set?
> 
> e.g. rc_dev.tx_blocks_until_complete
> 
> The wording could be improved.
> 
> Another alternative would be if the drivers provided a 
> "wait_for_tx_to_complete()" function. If they can provided that; using 
> that it would be possible to implement O_NONBLOCK and sync.

Seems fine on my eyes. It may avoid code duplication if you pass the fd 
flags to the lirc call, and add a code there that will wait for complete, 
if the device was not opened in block mode.

Regards,
mauro

> 
>>  	kfree(txbuf);
>> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
>> index d289fd4..a5c6c1c 100644
>> --- a/drivers/media/rc/mceusb.c
>> +++ b/drivers/media/rc/mceusb.c
>> @@ -791,10 +791,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>>  	int i, ret = 0;
>>  	int cmdcount = 0;
>>  	unsigned char *cmdbuf; /* MCE command buffer */
>> -	long signal_duration = 0; /* Singnal length in us */
>> -	struct timeval start_time, end_time;
>> -
>> -	do_gettimeofday(&start_time);
>>  
>>  	cmdbuf = kzalloc(sizeof(unsigned) * MCE_CMDBUF_SIZE, GFP_KERNEL);
>>  	if (!cmdbuf)
>> @@ -807,7 +803,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>>  
>>  	/* Generate mce packet data */
>>  	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
>> -		signal_duration += txbuf[i];
>>  		txbuf[i] = txbuf[i] / MCE_TIME_UNIT;
>>  
>>  		do { /* loop to support long pulses/spaces > 127*50us=6.35ms */
>> @@ -850,19 +845,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>>  	/* Transmit the command to the mce device */
>>  	mce_async_out(ir, cmdbuf, cmdcount);
>>  
>> -	/*
>> -	 * The lircd gap calculation expects the write function to
>> -	 * wait the time it takes for the ircommand to be sent before
>> -	 * it returns.
>> -	 */
>> -	do_gettimeofday(&end_time);
>> -	signal_duration -= (end_time.tv_usec - start_time.tv_usec) +
>> -			   (end_time.tv_sec - start_time.tv_sec) * 1000000;
>> -
>> -	/* delay with the closest number of ticks */
>> -	set_current_state(TASK_INTERRUPTIBLE);
>> -	schedule_timeout(usecs_to_jiffies(signal_duration));
>> -
>>  out:
>>  	kfree(cmdbuf);
>>  	return ret ? ret : count;
>> diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
>> index fae1615..f9be681 100644
>> --- a/drivers/media/rc/rc-loopback.c
>> +++ b/drivers/media/rc/rc-loopback.c
>> @@ -105,18 +105,9 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>>  {
>>  	struct loopback_dev *lodev = dev->priv;
>>  	u32 rxmask;
>> -	unsigned total_duration = 0;
>>  	unsigned i;
>>  	DEFINE_IR_RAW_EVENT(rawir);
>>  
>> -	for (i = 0; i < count; i++)
>> -		total_duration += abs(txbuf[i]);
>> -
>> -	if (total_duration == 0) {
>> -		dprintk("invalid tx data, total duration zero\n");
>> -		return -EINVAL;
>> -	}
>> -
>>  	if (lodev->txcarrier < lodev->rxcarriermin ||
>>  	    lodev->txcarrier > lodev->rxcarriermax) {
>>  		dprintk("ignoring tx, carrier out of range\n");
>> @@ -148,9 +139,6 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>>  	ir_raw_event_handle(dev);
>>  
>>  out:
>> -	/* Lirc expects this function to take as long as the total duration */
>> -	set_current_state(TASK_INTERRUPTIBLE);
>> -	schedule_timeout(usecs_to_jiffies(total_duration));
>>  	return count;
>>  }
>>  
>> -- 
>> 1.7.11.2
>>
> 
> Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

