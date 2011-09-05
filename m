Return-path: <linux-media-owner@vger.kernel.org>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:35595 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753802Ab1IENse (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 09:48:34 -0400
Date: Mon, 5 Sep 2011 15:48:29 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Olivier Grenie <Olivier.Grenie@dibcom.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DiBxxxx: fixes for 3.1/3.0
In-Reply-To: <4E64CBA5.5090808@infradead.org>
Message-ID: <alpine.LRH.2.00.1109051538150.13873@pub6.ifh.de>
References: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>,<4E62CA12.8020805@infradead.org> <57C38DA176A0A34A9B9F3CCCE33D3C4A0160DC65B0D7@FRPAR1CL009.coe.adi.dibcom.com> <4E64CBA5.5090808@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 5 Sep 2011, Mauro Carvalho Chehab wrote:

> Em 05-09-2011 05:11, Olivier Grenie escreveu:
>> Hello Mauro,
>> I agree with you but when I wrote this patch, my concern was  that the read register function (dib0070_read_reg)
>> returns a u16 and so I could not propagate the error. That's why I decided to return 0 and not change the API.
>> But if you have a better idea, I will have no problem to implement it.
>
> Ok, I'll pull from it for 3.0/3.1. For 3.2, the better is to fix it.
>
> What other drivers do when they need to read a 16 bit register is to declare the function as
> returning an 'int'. As you know, on Linux, int has 32 bits, so it returns an u16 properly.
> It will also return properly the errors.
>
> So, all you need to do is to convert it to something like:
>
> static int dib0070_read_reg(struct dib0070_state *state, u8 reg)
> {
> 	int ret;
>
> 	ret = mutex_lock_interruptible(...);
> 	if (ret < 0)
> 		return ret;
> ...
> 	ret = i2c_transfer(state->i2c, state->msg, 2);
> 	if (ret < 0)
> 		goto error;
> 	if (ret != 2) {
> 		ret = -EIO;
> 		goto error;
> 	}
> 	ret = (state->i2c_read_buffer[0] << 8)
> 			| state->i2c_read_buffer[1];
>
> error:
> 	mutex_unlock(...);
> 	return ret;
> }
>
> You'll need to add a check on all places that calls dib0070_read_reg() (and dib070_write_reg) to do
> the right thing when a negative number is returned, like:
>
> static int dib0070_set_bandwidth(struct dvb_frontend *fe, struct dvb_frontend_parameters *ch)
> {
> 	struct dib0070_state *state = fe->tuner_priv;
> 	int tmp = dib0070_read_reg(state, 0x02);
> 	if (tmp < 0)
> 		return tmp;
> 	tmp |& = 0x3fff;
>
> ...
> }
>
>> For the write register function (dib0070_write_reg), in case of problem with the mutex lock, an error code is returned.
>
> Userspace applications in general handle EAGAIN on a different way, especially if the application
> is opening the device on non-blocking mode, as POSIX require that applications should re-try
> the ioctl, if EAGAIN is returned, on non-blocking mode. They might also handle EINTR case as well.
> So, using it instead of EINVAL is better.

While I agree with you in principle I think the time we would need and the 
risk we would take to do what you're asking here is too high.

I agree the drivers are quite huge and ugly but now adding hundreds of 
if's and returns won't make them better.

Right now if a read fails it returns 0 which in some cases might be even 
correct.

Fixing the error-handling in the drivers will most likely break things 
unless it is not done automagically - IOW not by a human being.

I quickly checked some other sources in dvb/frontends/ and the Dibbies are 
not the only ones where the error-path would need to be fixed.

I'd appreciate if we could restrict this requirement to new drivers which 
certainly will arrive. Of course, if there is a volunteer I'm ready to 
have a look.

What do you think?

regards,

--
Patrick
