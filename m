Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39835 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2HXWQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 18:16:09 -0400
Date: Sat, 25 Aug 2012 00:16:04 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Jarod Wilson <jwilson@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [media] rc-core: move timeout and checks to lirc
Message-ID: <20120824221604.GC19354@hardeman.nu>
References: <20120816221514.GA26546@pequod.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120816221514.GA26546@pequod.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 16, 2012 at 11:15:14PM +0100, Sean Young wrote:
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
>You've moved the sleeping out of the drivers to ir-lirc-codec, which makes
>sense for some devices. However you haven't updated winbond-cir.c which
>does two things:
>
>1) Modifies the txbuf (which is now used after transmit)
>2) Does the sleeping already since it blocks on the device to complete.

I'm not sure what issue 1) is?

Note that txstate is checked in wbcir_tx() at the beginning and the end.
The buf shouldn't be used after transmit...

>Surely if the driver can block on the device to complete then that is 
>better than sleeping; there might some difference due to rounding and 
>clock skew.

As noted in other mails, I actually think an asynchronous method is
better since it permits different approaches while a blocking TX method
forces that behavior.

Regards,
David

