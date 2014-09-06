Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:44270 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaIFRgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 13:36:20 -0400
Received: by mail-we0-f179.google.com with SMTP id t60so13052268wes.38
        for <linux-media@vger.kernel.org>; Sat, 06 Sep 2014 10:36:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGx6d4ch2BY7Q5obPtjp3H2qy9YjW6UYcHLag5RN_eqEKg@mail.gmail.com>
References: <1408990024-1642-1-git-send-email-olli.salonen@iki.fi>
	<1408990024-1642-3-git-send-email-olli.salonen@iki.fi>
	<540975F0.8070407@iki.fi>
	<CAAZRmGx6d4ch2BY7Q5obPtjp3H2qy9YjW6UYcHLag5RN_eqEKg@mail.gmail.com>
Date: Sat, 6 Sep 2014 20:36:19 +0300
Message-ID: <CAAZRmGzhNUhajfBM_-CanNTrJpqKmuLddLU2PZMYx2S+8NqevA@mail.gmail.com>
Subject: Re: [PATCH 3/3] si2168: avoid firmware loading if it has been loaded previously
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moro Antti,

Tried removing the command 85 after resume, but the result is that the
demod doesn't lock after sleep. Curiously this only impacts HD or
DVB-T2 channels. DVB-T SD channels are fine even after resume.

Log of the testing here:
http://paste.ubuntu.com/8271949/

Same thing happens after applying the "si2157: sleep hack" patch: my
TT CT2-4400 does not lock on the second tune, ie. after sleep.

Log of the testing of that patch is here:
http://paste.ubuntu.com/8271869/

Cheers,
-olli

On 5 September 2014 21:54, Olli Salonen <olli.salonen@iki.fi> wrote:
> Moro,
>
> I'll test it once more when testing the "si2157 sleep hack" you
> posted. Though I remember that the command 85 seemed to be the magic
> trick that finally made it work - I agree it sounds a bit strange
> considering it's run later on anyway. The proprietary driver seems to
> do a command 85 after wake up, but of course that's not a guarantee of
> anything.
>
> My sniff using the proprietary driver is here:
> http://trsqr.net/olli/ct2-4400/ct2-4400-wakeup-tune-sleep.txt
>
> Cheers,
> -olli
>
> On 5 September 2014 11:36, Antti Palosaari <crope@iki.fi> wrote:
>> Moikka
>> Did you really need command 85 here? It will be given later in any case. For
>> my Si2168 B40 there was no need for it.
>>
>> regards
>> Antti
>>
>> On 08/25/2014 09:07 PM, Olli Salonen wrote:
>>>
>>> Add a variable to keep track if firmware is loaded or not and skip parts
>>> of the
>>> initialization if fw is already loaded. Resume from sleep with a different
>>> command compared to initial power up and run command 85 after resume
>>> command.
>>> This behaviour is observed when using manufacturer provided binary-only
>>> si2168
>>> driver for TechnoTrend CT2-4400.
>>>
>>> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>>> ---
>>>   drivers/media/dvb-frontends/si2168.c      | 31
>>> ++++++++++++++++++++++++++++---
>>>   drivers/media/dvb-frontends/si2168_priv.h |  1 +
>>>   2 files changed, 29 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/dvb-frontends/si2168.c
>>> b/drivers/media/dvb-frontends/si2168.c
>>> index 55a4212..a0797fd 100644
>>> --- a/drivers/media/dvb-frontends/si2168.c
>>> +++ b/drivers/media/dvb-frontends/si2168.c
>>> @@ -363,6 +363,7 @@ static int si2168_init(struct dvb_frontend *fe)
>>>
>>>         dev_dbg(&s->client->dev, "\n");
>>>
>>> +       /* initialize */
>>>         memcpy(cmd.args,
>>> "\xc0\x12\x00\x0c\x00\x0d\x16\x00\x00\x00\x00\x00\x00", 13);
>>>         cmd.wlen = 13;
>>>         cmd.rlen = 0;
>>> @@ -370,6 +371,26 @@ static int si2168_init(struct dvb_frontend *fe)
>>>         if (ret)
>>>                 goto err;
>>>
>>> +       if (s->fw_loaded) {
>>> +               /* resume */
>>> +               memcpy(cmd.args, "\xc0\x06\x08\x0f\x00\x20\x21\x01", 8);
>>> +               cmd.wlen = 8;
>>> +               cmd.rlen = 1;
>>> +               ret = si2168_cmd_execute(s, &cmd);
>>> +               if (ret)
>>> +                       goto err;
>>> +
>>> +               memcpy(cmd.args, "\x85", 1);
>>> +               cmd.wlen = 1;
>>> +               cmd.rlen = 1;
>>> +               ret = si2168_cmd_execute(s, &cmd);
>>> +               if (ret)
>>> +                       goto err;
>>> +
>>> +               goto warm;
>>> +       }
>>> +
>>> +       /* power up */
>>>         memcpy(cmd.args, "\xc0\x06\x01\x0f\x00\x20\x20\x01", 8);
>>>         cmd.wlen = 8;
>>>         cmd.rlen = 1;
>>> @@ -466,9 +487,6 @@ static int si2168_init(struct dvb_frontend *fe)
>>>         if (ret)
>>>                 goto err;
>>>
>>> -       dev_info(&s->client->dev, "found a '%s' in warm state\n",
>>> -                       si2168_ops.info.name);
>>> -
>>>         /* set ts mode */
>>>         memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
>>>         cmd.args[4] |= s->ts_mode;
>>> @@ -478,6 +496,12 @@ static int si2168_init(struct dvb_frontend *fe)
>>>         if (ret)
>>>                 goto err;
>>>
>>> +       s->fw_loaded = true;
>>> +
>>> +warm:
>>> +       dev_info(&s->client->dev, "found a '%s' in warm state\n",
>>> +                       si2168_ops.info.name);
>>> +
>>>         s->active = true;
>>>
>>>         return 0;
>>> @@ -645,6 +669,7 @@ static int si2168_probe(struct i2c_client *client,
>>>         *config->i2c_adapter = s->adapter;
>>>         *config->fe = &s->fe;
>>>         s->ts_mode = config->ts_mode;
>>> +       s->fw_loaded = false;
>>>
>>>         i2c_set_clientdata(client, s);
>>>
>>> diff --git a/drivers/media/dvb-frontends/si2168_priv.h
>>> b/drivers/media/dvb-frontends/si2168_priv.h
>>> index 0f83284..e13983e 100644
>>> --- a/drivers/media/dvb-frontends/si2168_priv.h
>>> +++ b/drivers/media/dvb-frontends/si2168_priv.h
>>> @@ -36,6 +36,7 @@ struct si2168 {
>>>         fe_delivery_system_t delivery_system;
>>>         fe_status_t fe_status;
>>>         bool active;
>>> +       bool fw_loaded;
>>>         u8 ts_mode;
>>>   };
>>>
>>>
>>
>> --
>> http://palosaari.fi/
