Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1IENQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 09:16:51 -0400
Message-ID: <4E64CBA5.5090808@infradead.org>
Date: Mon, 05 Sep 2011 10:16:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Olivier Grenie <Olivier.Grenie@dibcom.com>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DiBxxxx: fixes for 3.1/3.0
References: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>,<4E62CA12.8020805@infradead.org> <57C38DA176A0A34A9B9F3CCCE33D3C4A0160DC65B0D7@FRPAR1CL009.coe.adi.dibcom.com>
In-Reply-To: <57C38DA176A0A34A9B9F3CCCE33D3C4A0160DC65B0D7@FRPAR1CL009.coe.adi.dibcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-09-2011 05:11, Olivier Grenie escreveu:
> Hello Mauro,
> I agree with you but when I wrote this patch, my concern was  that the read register function (dib0070_read_reg) 
> returns a u16 and so I could not propagate the error. That's why I decided to return 0 and not change the API. 
> But if you have a better idea, I will have no problem to implement it.

Ok, I'll pull from it for 3.0/3.1. For 3.2, the better is to fix it.

What other drivers do when they need to read a 16 bit register is to declare the function as
returning an 'int'. As you know, on Linux, int has 32 bits, so it returns an u16 properly.
It will also return properly the errors.

So, all you need to do is to convert it to something like:

static int dib0070_read_reg(struct dib0070_state *state, u8 reg)
{
	int ret;

	ret = mutex_lock_interruptible(...);
	if (ret < 0)
		return ret;
...
	ret = i2c_transfer(state->i2c, state->msg, 2);
	if (ret < 0)
		goto error;
	if (ret != 2) {
		ret = -EIO;
		goto error;
	}
	ret = (state->i2c_read_buffer[0] << 8)
			| state->i2c_read_buffer[1];

error:
	mutex_unlock(...);
	return ret;
}

You'll need to add a check on all places that calls dib0070_read_reg() (and dib070_write_reg) to do
the right thing when a negative number is returned, like:

static int dib0070_set_bandwidth(struct dvb_frontend *fe, struct dvb_frontend_parameters *ch)
{
	struct dib0070_state *state = fe->tuner_priv;
	int tmp = dib0070_read_reg(state, 0x02);
	if (tmp < 0)
		return tmp;
	tmp |& = 0x3fff;
	
...
}

> For the write register function (dib0070_write_reg), in case of problem with the mutex lock, an error code is returned.

Userspace applications in general handle EAGAIN on a different way, especially if the application
is opening the device on non-blocking mode, as POSIX require that applications should re-try
the ioctl, if EAGAIN is returned, on non-blocking mode. They might also handle EINTR case as well. 
So, using it instead of EINVAL is better.

> The same idea is true for the whole patch.
> 
> regards,
> Olivier
> 
> ________________________________________
> From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab [mchehab@infradead.org]
> Sent: Sunday, September 04, 2011 2:45 AM
> To: Patrick Boettcher
> Cc: Linux Media Mailing List
> Subject: Re: DiBxxxx: fixes for 3.1/3.0
> 
> Em 03-08-2011 12:33, Patrick Boettcher escreveu:
>> Hi Mauro,
> 
> Thanks for the patches!
> 
>> Would you please pull from
>>
>> git://linuxtv.org/pb/media_tree.git for_v3.0
>>
>> for the following to changesets:
>>
>> [media] dib0700: protect the dib0700 buffer access
> 
>> -static uint16_t dib0070_read_reg(struct dib0070_state *state, u8 reg)
>> +static u16 dib0070_read_reg(struct dib0070_state *state, u8 reg)
>>   {
>> +     u16 ret;
>> +
>> +     if (mutex_lock_interruptible(&state->i2c_buffer_lock)<  0) {
>> +             dprintk("could not acquire lock");
>> +             return 0;
> 
> Returning 0 doesn't seem right for me. IMO, it should be return -EAGAIN
> or -EINTR (which is, incidentally, what mutex_lock_interruptible() will
> return).
> 
> The same applies to the similar parts of the code, at the read and write
> routines.
> 
>> [media] DiBcom: protect the I2C bufer access
>>
>> ?
>>
>> Those two changesets are fixing the remaining problems regarding the dma-on-stack-buffer-fix applied for the first time in 2.6.39, IIRC.
>>
>> They should go to stable 3.0 (as they are in my tree) and they can be cherry-picked to 3.1.
>>
>> We are preparing the same thing for 2.6.39 as the patches don't apply cleanly.
>>
>> Thanks to Javier Marcet for his help during the debug-phase.
>>
>> thanks and best regards,
>> --
>>
>> Patrick Boettcher - Kernel Labs
>> http://www.kernellabs.com/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> CONFIDENTIAL NOTICE: The contents of this message, including any attachments, are confidential and are intended solely for the use of the person or entity to whom the message was addressed. If you are not the intended recipient of this message, please be advised that any dissemination, distribution, or use of the contents of this message is strictly prohibited. If you received this message in error, please notify the sender. Please also permanently delete all copies of the original message and any attached documentation. Thank you.

