Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38044 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab3ADNyD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 08:54:03 -0500
Message-ID: <50E6DED4.5050104@iki.fi>
Date: Fri, 04 Jan 2013 15:53:24 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] tda10071: make sure both tuner and demod i2c addresses
 are specified
References: <1355706724-25663-1-git-send-email-mkrufky@linuxtv.org> <50E30336.9040206@iki.fi> <CAOcJUbxA8HbGTxtMM1tYCQ3b=4S4Dtp6SA-cqMKMjNFmeiiM5g@mail.gmail.com>
In-Reply-To: <CAOcJUbxA8HbGTxtMM1tYCQ3b=4S4Dtp6SA-cqMKMjNFmeiiM5g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/04/2013 03:33 PM, Michael Krufky wrote:
> On Tue, Jan 1, 2013 at 10:39 AM, Antti Palosaari <crope@iki.fi> wrote:
>> On 12/17/2012 03:12 AM, Michael Krufky wrote:
>>>
>>> display an error message if either tuner_i2c_addr or demod_i2c_addr
>>> are not specified in the tda10071_config structure
>>
>>
>> Nack.
>>
>> I don't see it necessary at all to check correctness of driver configuration
>> values explicitly like that. Those are values which user cannot never change
>> and when driver developer pass wrong values he will find it out very soon as
>> hardware is not working.
>>
>> Adding comments to configuration struct which says possible values is
>> advisable and enough IMHO.
>>
>> Maybe you should open own topic for discussion if you really would like to
>> add this kind of checks. It is not tda10071 driver specific change, it
>> affects about all drivers.
>
>
> Antti,
>
> I don't believe that your NACK has any technical merit- we are trying
> to enforce good programming practice here, and when we find that a
> piece of silicon has a configurable option, we like to expose that
> option.  We try not to make default values unless its necessary, but
> when there are differing i2c addresses, it is always best to have that
> listed explicitly in the configuration structures.  It's called
> self-documenting code- It's the way we try to write code in the Linux
> kernel.

I am against checking explicitly that kind of I2C address correctness! 
Address is set compile time and cannot change during device operation. 
It is just stupid check, adding few lines more code to driver complexity 
and making bloated binary without a good reason.

It is *logging without a good reason/need*. Someone could put BOG_ON or 
WARN_ON in such places, but really, I would like to leave it totally 
without and let it fail for I/O error. My opinion is we should think if 
we really need to add all kind of logging, if not, do not log.


I could maybe agree that situation if we make general rule to add as 
much as checking for all the configuration parameters for all the 
drivers. I don't like it was added to my driver, whilst about 100% other 
drivers are just without currently.


> In this case, there was one previous user of the tda10071 driver and
> it was a small change to add both tuner and demod i2c addresses to the
> configuration structure.

I was (and I am) fine for those two patches.

> We did speak about this on IRC on the sixteenth of December, and you
> seemed OK with the idea:
>
> [18:21] <mkrufky> dunno if you saw i asked earlier, but.... if you
> want to review the patches, i can include your credentials on the pull
> request
> [18:21] <mkrufky> tda10071 patch:
> http://git.linuxtv.org/mkrufky/hauppauge.git/commitdiff/4244d8155324263df37a8b2e067e7b9b81faec29
> [18:22] <mkrufky> cx23885 patch:
> http://git.linuxtv.org/mkrufky/hauppauge.git/commitdiff/eb658993b7a834911a3e8aabc7729b2505eef7d0
> [18:22] <mkrufky> and i'll add another patch error out if the
> tuner_i2c_addr is not specified, as devin recommended
> [18:22] <mkrufky> (and also change the other tda10071 user to specify
> 0x14 for tuner_i2c_addr)
> [18:23] <crope> Acked-by: Antti Palosaari <crope@iki.fi>
> [18:23] <crope> Reviewed-by: Antti Palosaari <crope@iki.fi>
> [18:23] <mkrufky> cool, thanks :-)
> [18:24] <crope> I think 14 is the default, it is hard to understand
> why ever one wants to use some other address in case of it is
> controlled by demod :] but feel free to do that
> [18:24] <mkrufky> ok
> [18:25] <mkrufky> thats why i'll do it in a separate patch -- no need
> to confuse a board addition with other cleanups
> [18:25] <crope> eg cx24116/cx24118 does not specify tuner address at
> all (as far as I see) => I think it is hard coded even to firmware
> [18:26] <mkrufky> yea ur right
>
> ...the tuner and demod addresses can be changed, so we represent that
> in the configuration structure.  I see no reason why you should have
> any complaints about this patch.
>
> Best regards,
>
> Mike
>
>
>> regards
>> Antti

Antti

>>
>>
>>
>>>
>>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>> ---
>>>    drivers/media/dvb-frontends/tda10071.c  |   18 +++++++++++++++---
>>>    drivers/media/dvb-frontends/tda10071.h  |    4 ++--
>>>    drivers/media/pci/cx23885/cx23885-dvb.c |    2 +-
>>>    drivers/media/usb/em28xx/em28xx-dvb.c   |    3 ++-
>>>    4 files changed, 20 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/media/dvb-frontends/tda10071.c
>>> b/drivers/media/dvb-frontends/tda10071.c
>>> index 7103629..02f9234 100644
>>> --- a/drivers/media/dvb-frontends/tda10071.c
>>> +++ b/drivers/media/dvb-frontends/tda10071.c
>>> @@ -30,7 +30,7 @@ static int tda10071_wr_regs(struct tda10071_priv *priv,
>>> u8 reg, u8 *val,
>>>          u8 buf[len+1];
>>>          struct i2c_msg msg[1] = {
>>>                  {
>>> -                       .addr = priv->cfg.i2c_address,
>>> +                       .addr = priv->cfg.demod_i2c_addr,
>>>                          .flags = 0,
>>>                          .len = sizeof(buf),
>>>                          .buf = buf,
>>> @@ -59,12 +59,12 @@ static int tda10071_rd_regs(struct tda10071_priv
>>> *priv, u8 reg, u8 *val,
>>>          u8 buf[len];
>>>          struct i2c_msg msg[2] = {
>>>                  {
>>> -                       .addr = priv->cfg.i2c_address,
>>> +                       .addr = priv->cfg.demod_i2c_addr,
>>>                          .flags = 0,
>>>                          .len = 1,
>>>                          .buf = &reg,
>>>                  }, {
>>> -                       .addr = priv->cfg.i2c_address,
>>> +                       .addr = priv->cfg.demod_i2c_addr,
>>>                          .flags = I2C_M_RD,
>>>                          .len = sizeof(buf),
>>>                          .buf = buf,
>>> @@ -1202,6 +1202,18 @@ struct dvb_frontend *tda10071_attach(const struct
>>> tda10071_config *config,
>>>                  goto error;
>>>          }
>>>
>>> +       /* make sure demod i2c address is specified */
>>> +       if (!config->demod_i2c_addr) {
>>> +               dev_dbg(&i2c->dev, "%s: invalid demod i2c address!\n",
>>> __func__);
>>> +               goto error;
>>> +       }
>>> +
>>> +       /* make sure tuner i2c address is specified */
>>> +       if (!config->tuner_i2c_addr) {
>>> +               dev_dbg(&i2c->dev, "%s: invalid tuner i2c address!\n",
>>> __func__);
>>> +               goto error;
>>> +       }
>>> +
>>>          /* setup the priv */
>>>          priv->i2c = i2c;
>>>          memcpy(&priv->cfg, config, sizeof(struct tda10071_config));
>>> diff --git a/drivers/media/dvb-frontends/tda10071.h
>>> b/drivers/media/dvb-frontends/tda10071.h
>>> index a20d5c4..bff1c38 100644
>>> --- a/drivers/media/dvb-frontends/tda10071.h
>>> +++ b/drivers/media/dvb-frontends/tda10071.h
>>> @@ -28,10 +28,10 @@ struct tda10071_config {
>>>           * Default: none, must set
>>>           * Values: 0x55,
>>>           */
>>> -       u8 i2c_address;
>>> +       u8 demod_i2c_addr;
>>>
>>>          /* Tuner I2C address.
>>> -        * Default: 0x14
>>> +        * Default: none, must set
>>>           * Values: 0x14, 0x54, ...
>>>           */
>>>          u8 tuner_i2c_addr;
>>> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c
>>> b/drivers/media/pci/cx23885/cx23885-dvb.c
>>> index cf84c53..a1aae56 100644
>>> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
>>> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
>>> @@ -662,7 +662,7 @@ static struct mt2063_config terratec_mt2063_config[] =
>>> {
>>>    };
>>>
>>>    static const struct tda10071_config hauppauge_tda10071_config = {
>>> -       .i2c_address = 0x05,
>>> +       .demod_i2c_addr = 0x05,
>>>          .tuner_i2c_addr = 0x54,
>>>          .i2c_wr_max = 64,
>>>          .ts_mode = TDA10071_TS_SERIAL,
>>> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c
>>> b/drivers/media/usb/em28xx/em28xx-dvb.c
>>> index 63f2e70..e800881 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>>> @@ -714,7 +714,8 @@ static struct tda18271_config
>>> em28xx_cxd2820r_tda18271_config = {
>>>    };
>>>
>>>    static const struct tda10071_config em28xx_tda10071_config = {
>>> -       .i2c_address = 0x55, /* (0xaa >> 1) */
>>> +       .demod_i2c_addr = 0x55, /* (0xaa >> 1) */
>>> +       .tuner_i2c_addr = 0x14,
>>>          .i2c_wr_max = 64,
>>>          .ts_mode = TDA10071_TS_SERIAL,
>>>          .spec_inv = 0,
>>>
>>
>>
>> --
>> http://palosaari.fi/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
