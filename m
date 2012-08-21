Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38581 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2HUTmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 15:42:33 -0400
Date: Tue, 21 Aug 2012 21:42:26 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sean Young <sean@mess.org>, Jarod Wilson <jwilson@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [media] rc-core: move timeout and checks to lirc
Message-ID: <20120821194226.GA4993@hardeman.nu>
References: <20120816221514.GA26546@pequod.mess.org>
 <502D7E62.9040204@redhat.com>
 <20120820213659.GC14636@hardeman.nu>
 <5032B407.8030407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5032B407.8030407@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 20, 2012 at 07:02:47PM -0300, Mauro Carvalho Chehab wrote:
>Em 20-08-2012 18:36, David Härdeman escreveu:
>> On Thu, Aug 16, 2012 at 08:12:34PM -0300, Mauro Carvalho Chehab wrote:
>>> Em 16-08-2012 19:15, Sean Young escreveu:
>>>>  
>>>>> The lirc TX functionality expects the process which writes (TX) data to
>>>>> the lirc dev to sleep until the actual data has been transmitted by the
>>>>> hardware.
>>>>>
>>>>> Since the same timeout calculation is duplicated in more than one driver
>>>>> (and would have to be duplicated in even more drivers as they gain TX
>>>>> support), it makes sense to move this timeout calculation to the lirc
>>>>> layer instead.
>>>>>
>>>>> At the same time, centralize some of the sanity checks.
>>>>>
>>>>> Signed-off-by: David Härdeman <david@hardeman.nu>
>>>>> Cc: Jarod Wilson <jwilson@redhat.com>
>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>> ---
>>>>>  drivers/media/rc/ir-lirc-codec.c | 33 +++++++++++++++++++++++++++++----
>>>>>  drivers/media/rc/mceusb.c        | 18 ------------------
>>>>>  drivers/media/rc/rc-loopback.c   | 12 ------------
>>>>>  3 files changed, 29 insertions(+), 34 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
>>>>> index d2fd064..6ad4a07 100644
>>>>> --- a/drivers/media/rc/ir-lirc-codec.c
>>>>> +++ b/drivers/media/rc/ir-lirc-codec.c
>>>>> @@ -107,6 +107,12 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>>>>>  	unsigned int *txbuf; /* buffer with values to transmit */
>>>>>  	ssize_t ret = -EINVAL;
>>>>>  	size_t count;
>>>>> +	ktime_t start;
>>>>> +	s64 towait;
>>>>> +	unsigned int duration = 0; /* signal duration in us */
>>>>> +	int i;
>>>>> +
>>>>> +	start = ktime_get();
>>>>>  
>>>>>  	lirc = lirc_get_pdata(file);
>>>>>  	if (!lirc)
>>>>> @@ -129,11 +135,30 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>>>>>  		goto out;
>>>>>  	}
>>>>>  
>>>>> -	if (dev->tx_ir)
>>>>> -		ret = dev->tx_ir(dev, txbuf, count);
>>>>> +	if (!dev->tx_ir) {
>>>>> +		ret = -ENOSYS;
>>>>> +		goto out;
>>>>> +	}
>>>>> +
>>>>> +	ret = dev->tx_ir(dev, txbuf, (u32)n);
>>>>> +	if (ret < 0)
>>>>> +		goto out;
>>>>> +
>>>>> +	for (i = 0; i < ret; i++)
>>>>> +		duration += txbuf[i];
>>>>>  
>>>>> -	if (ret > 0)
>>>>> -		ret *= sizeof(unsigned);
>>>>> +	ret *= sizeof(unsigned int);
>>>>> +
>>>>> +	/*
>>>>> +	 * The lircd gap calculation expects the write function to
>>>>> +	 * wait for the actual IR signal to be transmitted before
>>>>> +	 * returning.
>>>>> +	 */
>>>>> +	towait = ktime_us_delta(ktime_add_us(start, duration), ktime_get());
>>>>> +	if (towait > 0) {
>>>>> +		set_current_state(TASK_INTERRUPTIBLE);
>>>>> +		schedule_timeout(usecs_to_jiffies(towait));
>>>>> +	}
>>>>>  
>>>>>  out:
>>>>
>>>> You've moved the sleeping out of the drivers to ir-lirc-codec, which makes
>>>> sense for some devices. However you haven't updated winbond-cir.c which
>>>> does two things:
>>>>
>>>> 1) Modifies the txbuf (which is now used after transmit)
>>>> 2) Does the sleeping already since it blocks on the device to complete.
>>>>
>>>> Surely if the driver can block on the device to complete then that is 
>>>> better than sleeping; there might some difference due to rounding and 
>>>> clock skew.
>>>>
>>>> In addition to winbond-cir, iguanair suffer from the same problem. There
>>>> might be others.
>>>
>>> That's likely my fault: I was waiting for Jarod's review on this patch,
>>> with didn't happen, likely because he is too busy with some other stuff.
>>> Both winbond and iguanair drivers went after David's patch.
>>>
>>> Feel free to send me a patch fixing it there.
>>>
>>>> Could we have a flag in rc_dev to signify whether a driver blocks on
>>>> completion of a transmit and only sleep here if it is not set?
>>>>
>>>> e.g. rc_dev.tx_blocks_until_complete
>>>>
>>>> The wording could be improved.
>>>>
>>>> Another alternative would be if the drivers provided a 
>>>> "wait_for_tx_to_complete()" function. If they can provided that; using 
>>>> that it would be possible to implement O_NONBLOCK and sync.
>>>
>>> Seems fine on my eyes. It may avoid code duplication if you pass the fd 
>>> flags to the lirc call, and add a code there that will wait for complete, 
>>> if the device was not opened in block mode.
>> 
>> I think a future rc-core native TX API should behave like a write() on a
>> network socket does.
>> 
>> That is, a write on a rc device opened with O_NONBLOCK will either
>> succeed immediately (i.e. write data to buffers for further processing)
>> or return EAGAIN.  A write on a non-O_NONBLOCK device will either write
>> the data to buffer space and return or wait for more space to be
>> available. No waiting for the data to actually leave the "device" (NIC
>> or IR transmitter) is done by the write() call.
>> 
>> The "gap calculation" that lirc wants to do based on the time a write()
>> takes to complete is quite non-unixy in my eyes and seems bogus.
>> 
>> If a user-space program wants a very specific and deterministic
>> behaviour, eg. wrt gaps...it should just add it to the TX data.
>> 
>> I.e. if you want to TX command "A", wait 150ms, TX command "B", then
>> instead of doing:
>> 
>> write(A); sleep(150ms); write(B);
>> 
>> the app should do:
>> 
>> write(A + 150ms silence + B);
>> 
>> The same goes for e.g. trailing silences after commands, etc...
>
>That makes sense to me, but we need to not break existing userspace
>applications with new improvements.

Agreed. But that is what the patch aimed to do. The "timeout" was moved
to the lirc code and out of the drivers. Then a new API could call the 
drivers directly, without any timeout, while the lirc layer emulates the
old behavior.

>Yeah, a better API is needed to not only allow sending pulse/space/waiting
>times to IR TX, but also sending real keystrokes, like:
>
>echo "A" > /dev/<some rc device>
>
>Still, I'm not sure if we should create a "150 ms silence" keystroke. That
>doesn't sound linux style to me.
>
>The Linux way would be:
>
>fputs("A", fp);
>fflush(fp);
>usleep(150000);
>fputs("B", fp);
>
>That's close to what is done on term apps like minicom.

Sorry, I was being too terse. What I meant with "A" and "B" was actually
"sequence of pulse/space timings corresponding to IR command A/B".

So, if lircd used to do this:

	unsigned cmd_A[] = { 500, 1000, 500, 500 ...};
	unsigned cmd_B[] = { 500, 1000, 500, 1000 ...};

	write_pulsespace(cmd_A, fp);
	usleep(150000);
	write_pulsespace(cmd_B, fp);

it should instead (with a new, non-lirc API) do:

	unsigned cmd_A[] = { 500, 1000, 500, 500 ...};
	unsigned cmd_B[] = { 500, 1000, 500, 1000 ...};

	write_pulsespace(cmd_A, fp);
	write_space(150000, fp);
	write_pulsespace(cmd_B, fp);

And not care a bit about any "gap calculations".

The result would be that the lircd daemon can go about it's business and
that the TX hardware is guaranteed to be busy for the duration it takes
to send the "A" command, silent for 150ms, and yet again busy for the
duration it takes to send the "B" command.

>Ok, currently, all drivers have only "raw" TX. Yet, HDMI CEC provides
>a way to receive/send IR commands from/to the TV set. So, I think we'll
>have soon some drivers that only work on 'non-raw' TX mode.
>
>So, IMO, it makes sense to have a "high end" API that accepts
>writing keystrokes like above, working with both "raw drivers"
>using some kernel IR protocol encoders, and with devices that can
>accept "processed" keystrokes, like HDMI CEC.

Agreed.

>The lirc interface may not be the right device for such usage,
>if changing it would break support for existing devices.

No, the lirc interface is unlikely to be what we want. Instead, I expect
the future API to be modelled along the lines of:

	unsigned cmd_A[] = { 500, 1000, 500, 500 ...};

	fd = open("/dev/some_rc_dev");
	ioctl(fd, RCIOCGTXTYPE, &type);

	switch (type) {
	case RC_DRIVER_SCANCODE:
		write_cmd(KEY_A, fd);
		break;
	case RC_DRIVER_IR_RAW:
		write_pulsespace(cmd_A, fd);
		break;
	...
	default:
		error("Unknown device type\n");
	}

(Some details left out...the type above is probably going to have to be
a bitmask for example).

The lirc layer could trivially be provided by a compat driver (as now)
which supports doing the right thing on the right kinds of hardware
(i.e. not support e.g. HDMI-CEC with keystrokes).


-- 
David Härdeman
