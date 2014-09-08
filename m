Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49895 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaIHNSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 09:18:06 -0400
Received: by mail-pa0-f46.google.com with SMTP id kq14so49019pab.19
        for <linux-media@vger.kernel.org>; Mon, 08 Sep 2014 06:18:05 -0700 (PDT)
Message-ID: <540DAC88.3040802@gmail.com>
Date: Mon, 08 Sep 2014 22:18:00 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v3 1/4] mxl301rf: add driver for MaxLinear MxL301RF OFDM
 tuner
References: <1410093690-5674-1-git-send-email-tskd08@gmail.com> <1410093690-5674-2-git-send-email-tskd08@gmail.com> <540D6077.7030709@iki.fi>
In-Reply-To: <540D6077.7030709@iki.fi>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi!,
thanks for the review.

>> +static int reg_read(struct mxl301rf_state *state, u8 reg, u8 *val)
.......
>> +    ret = i2c_transfer(state->i2c->adapter, msgs, ARRAY_SIZE(msgs));
>> +    if (ret >= 0 && ret < ARRAY_SIZE(msgs))
>> +        ret = -EIO;
>> +    return (ret == ARRAY_SIZE(msgs)) ? 0 : ret;
>> +}
> 
> Could you really implement that as a I2C write with STOP and I2C read
> with STOP. I don't like you abuse, without any good reason,
> i2c_transfer() with REPEATED START even we know chip does not do it.
> 
> You should use
> i2c_master_send()
> i2c_master_recv()

Though it's woking with this REPEATED_START style reads,
(and my reference win driver also uses REPEATED_START),
I'll incorporate this in the next version.

>> +static int mxl301rf_get_status(struct dvb_frontend *fe, u32 *status)
.....
> And whole function is quite useless in any case. It was aimed for analog
> radio driver originally, where was audio demod integrated. We usually
> just program tuner first, then demod, without waiting tuner lock, as
> tuner locks practically immediately to given freq. It is demod which
> locking then has any sense.
> 
> Tuner PLL lock bits could be interesting only when you want to test if
> you are in a frequency whole tuner is able to receive. Some corner case
> when tuner is driven over its limits to see if it locks or not.

I understand. I'll remove .get_status().

>> +static int mxl301rf_init(struct dvb_frontend *fe)
.......
>> +    /* tune to the initial freq */
.......
> This looks odd. Why it is tuned here to some freq? What happens if you
> don't do it and it will be tuned to requested freq. Sometimes that kind
> of things are used to initialize badly written driven...

In a PT3 board, mxl301rf is packaged into a canned tuner module
(Sharp	VA4M6JC2103) with another mxl301rf and two qm1d1c0042's.
A reference win driver says that it is to avoid "interference"
between mxl301rf and qm1d1c0042, so I added a config parameter
of initial freq.
I could have moved those initial tunings to the PCI driver,
but I don't know if it is a corner case that applys just to PT3.

I must admit that my code is written pretty badly,
but it is partly;) because the available/disclosed information is
very limited to the reference win driver kit, it hides lots of
register settings including those for init/config,
and is badly written not separating demod/tuner modules well.

>> +static const struct dvb_tuner_ops mxl301rf_ops = {
......
>> +    .init = mxl301rf_init,
>> +    .sleep = mxl301rf_sleep,
>> +
>> +    .set_params = mxl301rf_set_params,
>> +    .get_status = mxl301rf_get_status,
>> +    .get_rf_strength = mxl301rf_get_rf_strength,
> 
> get IF frequency is missing. That is tuner using IF so you will need to
> know IF in order to get demod working.

As the product guide of TC90522 says it can accept
3-6MHz low IF or 44/57MHz direct IF, so there must be
the register setting to select/set/get one of these configs.
But I don't have the data sheets of mxl301rf,
and cannot know which demod/tuner reigsters are set during
init/config phase (as I said above it's not disclosed), 
so I don't know the registers to set/get IF.

The tuner/demod drivers I wrote are certainly imcomplete ones
that lack init/config of the chips,
but currently they are used just by PT3 and
when someone gets to use them in other products,
I expect that [s]he would have more info and update my code.

regards,
akihiro
