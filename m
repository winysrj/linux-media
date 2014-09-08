Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42064 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbaIHNwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Sep 2014 09:52:23 -0400
Message-ID: <540DB494.3030806@iki.fi>
Date: Mon, 08 Sep 2014 16:52:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v3 1/4] mxl301rf: add driver for MaxLinear MxL301RF OFDM
 tuner
References: <1410093690-5674-1-git-send-email-tskd08@gmail.com> <1410093690-5674-2-git-send-email-tskd08@gmail.com> <540D6077.7030709@iki.fi> <540DAC88.3040802@gmail.com>
In-Reply-To: <540DAC88.3040802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/08/2014 04:18 PM, Akihiro TSUKADA wrote:
> Moi!,
> thanks for the review.
>
>>> +static int reg_read(struct mxl301rf_state *state, u8 reg, u8 *val)
> .......
>>> +    ret = i2c_transfer(state->i2c->adapter, msgs, ARRAY_SIZE(msgs));
>>> +    if (ret >= 0 && ret < ARRAY_SIZE(msgs))
>>> +        ret = -EIO;
>>> +    return (ret == ARRAY_SIZE(msgs)) ? 0 : ret;
>>> +}
>>
>> Could you really implement that as a I2C write with STOP and I2C read
>> with STOP. I don't like you abuse, without any good reason,
>> i2c_transfer() with REPEATED START even we know chip does not do it.
>>
>> You should use
>> i2c_master_send()
>> i2c_master_recv()
>
> Though it's woking with this REPEATED_START style reads,
> (and my reference win driver also uses REPEATED_START),
> I'll incorporate this in the next version.

It is not style, it is how bits and bytes are transferred in a I2C bus. 
It is not surprise it is wrong as reading register using START + WRITE 
(reg val) + REPEATED START + READ (reg val) + STOP, I2C transaction is 
most common. And may cases I2C adapter implementation is also broken, 
you need to fix it too if it does not support plain I2C reads.

http://www.i2c-bus.org/repeated-start-condition/


>
>>> +static int mxl301rf_get_status(struct dvb_frontend *fe, u32 *status)
> .....
>> And whole function is quite useless in any case. It was aimed for analog
>> radio driver originally, where was audio demod integrated. We usually
>> just program tuner first, then demod, without waiting tuner lock, as
>> tuner locks practically immediately to given freq. It is demod which
>> locking then has any sense.
>>
>> Tuner PLL lock bits could be interesting only when you want to test if
>> you are in a frequency whole tuner is able to receive. Some corner case
>> when tuner is driven over its limits to see if it locks or not.
>
> I understand. I'll remove .get_status().
>
>>> +static int mxl301rf_init(struct dvb_frontend *fe)
> .......
>>> +    /* tune to the initial freq */
> .......
>> This looks odd. Why it is tuned here to some freq? What happens if you
>> don't do it and it will be tuned to requested freq. Sometimes that kind
>> of things are used to initialize badly written driven...
>
> In a PT3 board, mxl301rf is packaged into a canned tuner module
> (Sharp	VA4M6JC2103) with another mxl301rf and two qm1d1c0042's.
> A reference win driver says that it is to avoid "interference"
> between mxl301rf and qm1d1c0042, so I added a config parameter
> of initial freq.
> I could have moved those initial tunings to the PCI driver,
> but I don't know if it is a corner case that applys just to PT3.
>
> I must admit that my code is written pretty badly,
> but it is partly;) because the available/disclosed information is
> very limited to the reference win driver kit, it hides lots of
> register settings including those for init/config,
> and is badly written not separating demod/tuner modules well.

I didn't say your code is badly written :P I meant usually when I see 
some driver is dummy calling itself to initialize driver. And that can 
be seen very often when you read some sniffs. You plug TV stick in and 
it tunes to some frequency then goes sleep.

According to comment, that does not belong to tuner driver - but for 
bridge. All device specific hacks should be on bridge driver, leaving 
demod and tuner drivers clean.

>
>>> +static const struct dvb_tuner_ops mxl301rf_ops = {
> ......
>>> +    .init = mxl301rf_init,
>>> +    .sleep = mxl301rf_sleep,
>>> +
>>> +    .set_params = mxl301rf_set_params,
>>> +    .get_status = mxl301rf_get_status,
>>> +    .get_rf_strength = mxl301rf_get_rf_strength,
>>
>> get IF frequency is missing. That is tuner using IF so you will need to
>> know IF in order to get demod working.
>
> As the product guide of TC90522 says it can accept
> 3-6MHz low IF or 44/57MHz direct IF, so there must be
> the register setting to select/set/get one of these configs.
> But I don't have the data sheets of mxl301rf,
> and cannot know which demod/tuner reigsters are set during
> init/config phase (as I said above it's not disclosed),
> so I don't know the registers to set/get IF.

Low-IF is preferred over direct IF. I don't know which is used bandwidth 
of your ISDB system, but good guess is that 12MHz (2*6MHz) and less it 
is Low-IF. Both tuner and demod must support same IF. If demod does not 
support Low-IF, then it must be normal IF.

But if demod IF regs are also programmed by firmware, you could not even 
do reverse-calculation to find out IF :-( Error and trial testing is not 
worth in that case, so there is good reason to not implement it not. You 
could leave it without implementation.

> The tuner/demod drivers I wrote are certainly imcomplete ones
> that lack init/config of the chips,
> but currently they are used just by PT3 and
> when someone gets to use them in other products,
> I expect that [s]he would have more info and update my code.

Yeah, it is not your problem. Just add comment those are missing and it 
is OK. Driver does not need to be 100% full featured. Bugs, wrong 
implementations, hacks, are worse as many times it is very hard to fix 
those later.

regards
Antti

-- 
http://palosaari.fi/
