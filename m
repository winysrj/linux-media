Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:46292 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2HMTlR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 15:41:17 -0400
Message-ID: <50295855.3020707@iki.fi>
Date: Mon, 13 Aug 2012 22:41:09 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 1/2] media: rc: Introduce RX51 IR transmitter driver
References: <1344593797-15819-1-git-send-email-timo.t.kokkonen@iki.fi> <1344593797-15819-2-git-send-email-timo.t.kokkonen@iki.fi> <20120813183647.GA32660@pequod.mess.org>
In-Reply-To: <20120813183647.GA32660@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/13/12 21:36, Sean Young wrote:
> On Fri, Aug 10, 2012 at 01:16:36PM +0300, Timo Kokkonen wrote:
>> +static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>> +			  size_t n, loff_t *ppos)
>> +{
>> +	int count, i;
>> +	struct lirc_rx51 *lirc_rx51 = file->private_data;
>> +
>> +	if (n % sizeof(int))
>> +		return -EINVAL;
>> +
>> +	count = n / sizeof(int);
>> +	if ((count > WBUF_LEN) || (count % 2 == 0))
>> +		return -EINVAL;
>> +
>> +	/* Wait any pending transfers to finish */
>> +	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> 
> If a signal arrives then this could return ERESTARTSYS and the condition
> might not have evaluated to true.

hmm.. The whole point of it is to wait if for any possibly pending
transfers to finish. However, we don't allow the device to be opened
more than once and parallel access doesn't make much sense here anyway.
Only way we can end up waiting here is that the process is having
multiple threads writing to the same file descriptor (or has inherited
it from its parent), which doesn't make any sense.

I think we could simply return -EBUSY in case previous transfer is still
going on. I don't see any reason why we should wait here.

> 
>> +
>> +	if (copy_from_user(lirc_rx51->wbuf, buf, n))
>> +		return -EFAULT;
>> +
>> +	/* Sanity check the input pulses */
>> +	for (i = 0; i < count; i++)
>> +		if (lirc_rx51->wbuf[i] < 0)
>> +			return -EINVAL;
>> +
>> +	init_timing_params(lirc_rx51);
>> +	if (count < WBUF_LEN)
>> +		lirc_rx51->wbuf[count] = -1; /* Insert termination mark */
>> +
>> +	/*
>> +	 * Adjust latency requirements so the device doesn't go in too
>> +	 * deep sleep states
>> +	 */
>> +	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
>> +
>> +	lirc_rx51_on(lirc_rx51);
>> +	lirc_rx51->wbuf_index = 1;
>> +	pulse_timer_set_timeout(lirc_rx51, lirc_rx51->wbuf[0]);
>> +
>> +	/*
>> +	 * Don't return back to the userspace until the transfer has
>> +	 * finished
>> +	 */
>> +	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> 
> same here.
> 
> BTW so the semantics for lirc write() are that they complete when the 
> data has been transmitted. This doesn't play well with signals, polling 
> or non-blocking I/O. Is this deliberate or historical?
> 
> I guess a lirc write() handler should ignore signals completely.
> 

I'll change it to wait_event_timeout instead.

>> +
>> +struct platform_driver lirc_rx51_platform_driver = {
>> +	.probe		= lirc_rx51_probe,
>> +	.remove		= __exit_p(lirc_rx51_remove),
>> +	.suspend	= lirc_rx51_suspend,
>> +	.resume		= lirc_rx51_resume,
>> +	.remove		= __exit_p(lirc_rx51_remove),
> 
> .remove is here twice.

hehe.. I remember I was supposed to write a patch for that five years
ago but I was busy :) Thanks for your review. Will send round three.

-Timo

