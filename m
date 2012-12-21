Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:51568 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2LUNnm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 08:43:42 -0500
Received: by mail-la0-f48.google.com with SMTP id m13so5001992lah.21
        for <linux-media@vger.kernel.org>; Fri, 21 Dec 2012 05:43:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHAyoxw34qjQ72+xvOs+5RmLCeLpX2JWsgJg=115kzqkup5vrA@mail.gmail.com>
References: <1355706724-25663-1-git-send-email-mkrufky@linuxtv.org>
	<CAOcJUbxdvHZFqtvv5CEcgrWqof1425O+9Bp=GgE41kDm-QMrKg@mail.gmail.com>
	<CAOcJUbwqihx8NydLR9jqOXCn3Sd8aF7XND+jeGG9mxUHOwfrNw@mail.gmail.com>
	<CAHAyoxw34qjQ72+xvOs+5RmLCeLpX2JWsgJg=115kzqkup5vrA@mail.gmail.com>
Date: Fri, 21 Dec 2012 08:43:40 -0500
Message-ID: <CAOcJUbwQEmSJbivtb5ieVGNPJP64+UErqOgieX+5KJRs8yeEjQ@mail.gmail.com>
Subject: Re: [PATCH] tda10071: make sure both tuner and demod i2c addresses
 are specified
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media <linux-media@vger.kernel.org>
Cc: mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rebased against today's tip, as per your request :-)


pwclient update -s 'superseded' 15923
pwclient update -s 'superseded' 15930


The following changes since commit 1b5901331ff3af4bdc1b998a056a248c9924e2d1:

  [media] exynos-gsc: modify number of output/capture buffers
(2012-12-21 10:26:44 -0200)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/tuners tda10071

for you to fetch changes up to d562d77132333f0a7b1d704edc992a092d6d6bbe:

  tda10071: make sure both tuner and demod i2c addresses are specified
(2012-12-21 08:29:49 -0500)

Cheers,

Mike

On Fri, Dec 21, 2012 at 8:32 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> rebased against today's tip, as per your request :-)
>
>
> pwclient update -s 'superseded' 15923
> pwclient update -s 'superseded' 15930
>
>
> The following changes since commit 1b5901331ff3af4bdc1b998a056a248c9924e2d1:
>
>   [media] exynos-gsc: modify number of output/capture buffers
> (2012-12-21 10:26:44 -0200)
>
> are available in the git repository at:
>
>   git://git.linuxtv.org/mkrufky/tuners tda10071
>
> for you to fetch changes up to d562d77132333f0a7b1d704edc992a092d6d6bbe:
>
>   tda10071: make sure both tuner and demod i2c addresses are specified
> (2012-12-21 08:29:49 -0500)
>
> ----------------------------------------------------------------
> Michael Krufky (1):
>       tda10071: make sure both tuner and demod i2c addresses are specified
>
>  drivers/media/dvb-frontends/tda10071.c  |   18 +++++++++++++++---
>  drivers/media/dvb-frontends/tda10071.h  |    4 ++--
>  drivers/media/pci/cx23885/cx23885-dvb.c |    2 +-
>  drivers/media/usb/em28xx/em28xx-dvb.c   |    3 ++-
>  4 files changed, 20 insertions(+), 7 deletions(-)
>
> Cheers,
>
> Mike
>
> On Mon, Dec 17, 2012 at 10:10 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> As discussed on irc, the following pwclient commands should update the
>> status of the patches in patchwork to correspond with this merge
>> request:
>>
>> pwclient update -s 'superseded' 15923
>> pwclient update -s 'accepted' 15930
>>
>>
>> Cheers,
>>
>> Mike
>>
>> On Mon, Dec 17, 2012 at 10:09 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>>> Mauro,
>>>
>>> Please merge:
>>>
>>> The following changes since commit 4c8e64232d4a71e68d68b9093506966c0244a526:
>>>
>>>   cx23885: add basic DVB-S2 support for Hauppauge HVR-4400 (2012-12-16
>>> 12:27:25 -0500)
>>>
>>> are available in the git repository at:
>>>
>>>   git://linuxtv.org/mkrufky/tuners tda10071
>>>
>>> for you to fetch changes up to 326e65af0104faf8a243e534eb8bfdb35b73f4ed:
>>>
>>>   tda10071: make sure both tuner and demod i2c addresses are specified
>>> (2012-12-16 18:05:02 -0500)
>>>
>>> ----------------------------------------------------------------
>>> Michael Krufky (1):
>>>       tda10071: make sure both tuner and demod i2c addresses are specified
>>>
>>>  drivers/media/dvb-frontends/tda10071.c  |   18 +++++++++++++++---
>>>  drivers/media/dvb-frontends/tda10071.h  |    4 ++--
>>>  drivers/media/pci/cx23885/cx23885-dvb.c |    2 +-
>>>  drivers/media/usb/em28xx/em28xx-dvb.c   |    3 ++-
>>>  4 files changed, 20 insertions(+), 7 deletions(-)
>>>
>>> Cheers,
>>>
>>> Mike
>>>
>>> On Sun, Dec 16, 2012 at 8:12 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>>>> display an error message if either tuner_i2c_addr or demod_i2c_addr
>>>> are not specified in the tda10071_config structure
>>>>
>>>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>>> ---
>>>>  drivers/media/dvb-frontends/tda10071.c  |   18 +++++++++++++++---
>>>>  drivers/media/dvb-frontends/tda10071.h  |    4 ++--
>>>>  drivers/media/pci/cx23885/cx23885-dvb.c |    2 +-
>>>>  drivers/media/usb/em28xx/em28xx-dvb.c   |    3 ++-
>>>>  4 files changed, 20 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
>>>> index 7103629..02f9234 100644
>>>> --- a/drivers/media/dvb-frontends/tda10071.c
>>>> +++ b/drivers/media/dvb-frontends/tda10071.c
>>>> @@ -30,7 +30,7 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
>>>>         u8 buf[len+1];
>>>>         struct i2c_msg msg[1] = {
>>>>                 {
>>>> -                       .addr = priv->cfg.i2c_address,
>>>> +                       .addr = priv->cfg.demod_i2c_addr,
>>>>                         .flags = 0,
>>>>                         .len = sizeof(buf),
>>>>                         .buf = buf,
>>>> @@ -59,12 +59,12 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
>>>>         u8 buf[len];
>>>>         struct i2c_msg msg[2] = {
>>>>                 {
>>>> -                       .addr = priv->cfg.i2c_address,
>>>> +                       .addr = priv->cfg.demod_i2c_addr,
>>>>                         .flags = 0,
>>>>                         .len = 1,
>>>>                         .buf = &reg,
>>>>                 }, {
>>>> -                       .addr = priv->cfg.i2c_address,
>>>> +                       .addr = priv->cfg.demod_i2c_addr,
>>>>                         .flags = I2C_M_RD,
>>>>                         .len = sizeof(buf),
>>>>                         .buf = buf,
>>>> @@ -1202,6 +1202,18 @@ struct dvb_frontend *tda10071_attach(const struct tda10071_config *config,
>>>>                 goto error;
>>>>         }
>>>>
>>>> +       /* make sure demod i2c address is specified */
>>>> +       if (!config->demod_i2c_addr) {
>>>> +               dev_dbg(&i2c->dev, "%s: invalid demod i2c address!\n", __func__);
>>>> +               goto error;
>>>> +       }
>>>> +
>>>> +       /* make sure tuner i2c address is specified */
>>>> +       if (!config->tuner_i2c_addr) {
>>>> +               dev_dbg(&i2c->dev, "%s: invalid tuner i2c address!\n", __func__);
>>>> +               goto error;
>>>> +       }
>>>> +
>>>>         /* setup the priv */
>>>>         priv->i2c = i2c;
>>>>         memcpy(&priv->cfg, config, sizeof(struct tda10071_config));
>>>> diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
>>>> index a20d5c4..bff1c38 100644
>>>> --- a/drivers/media/dvb-frontends/tda10071.h
>>>> +++ b/drivers/media/dvb-frontends/tda10071.h
>>>> @@ -28,10 +28,10 @@ struct tda10071_config {
>>>>          * Default: none, must set
>>>>          * Values: 0x55,
>>>>          */
>>>> -       u8 i2c_address;
>>>> +       u8 demod_i2c_addr;
>>>>
>>>>         /* Tuner I2C address.
>>>> -        * Default: 0x14
>>>> +        * Default: none, must set
>>>>          * Values: 0x14, 0x54, ...
>>>>          */
>>>>         u8 tuner_i2c_addr;
>>>> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
>>>> index cf84c53..a1aae56 100644
>>>> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
>>>> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
>>>> @@ -662,7 +662,7 @@ static struct mt2063_config terratec_mt2063_config[] = {
>>>>  };
>>>>
>>>>  static const struct tda10071_config hauppauge_tda10071_config = {
>>>> -       .i2c_address = 0x05,
>>>> +       .demod_i2c_addr = 0x05,
>>>>         .tuner_i2c_addr = 0x54,
>>>>         .i2c_wr_max = 64,
>>>>         .ts_mode = TDA10071_TS_SERIAL,
>>>> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
>>>> index 63f2e70..e800881 100644
>>>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>>>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>>>> @@ -714,7 +714,8 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
>>>>  };
>>>>
>>>>  static const struct tda10071_config em28xx_tda10071_config = {
>>>> -       .i2c_address = 0x55, /* (0xaa >> 1) */
>>>> +       .demod_i2c_addr = 0x55, /* (0xaa >> 1) */
>>>> +       .tuner_i2c_addr = 0x14,
>>>>         .i2c_wr_max = 64,
>>>>         .ts_mode = TDA10071_TS_SERIAL,
>>>>         .spec_inv = 0,
>>>> --
>>>> 1.7.10.4
>>>>
