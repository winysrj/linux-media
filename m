Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:56107 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbdJ3Dbm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 23:31:42 -0400
Received: by mail-qt0-f172.google.com with SMTP id v41so14723749qtv.12
        for <linux-media@vger.kernel.org>; Sun, 29 Oct 2017 20:31:41 -0700 (PDT)
Received: from mail-qt0-f182.google.com (mail-qt0-f182.google.com. [209.85.216.182])
        by smtp.gmail.com with ESMTPSA id y29sm9360001qtk.64.2017.10.29.20.31.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Oct 2017 20:31:41 -0700 (PDT)
Received: by mail-qt0-f182.google.com with SMTP id h4so14756132qtk.8
        for <linux-media@vger.kernel.org>; Sun, 29 Oct 2017 20:31:40 -0700 (PDT)
MIME-Version: 1.0
From: Olli Salonen <olli.salonen@iki.fi>
Date: Mon, 30 Oct 2017 05:31:40 +0200
Message-ID: <CAAZRmGwuHRHxzvfQCBc+uTq+FCo6Z_2f_oT=H70TCpwQfouLvA@mail.gmail.com>
Subject: Re: [PATCHv3 1/2] tda18250: support for new silicon tuner
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Michael,

Many thanks for taking the time to review the patches.

On 27 October 2017 at 13:27, Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
>> +static int tda18250_sleep(struct dvb_frontend *fe)
>> +{
>> +       struct i2c_client *client = fe->tuner_priv;
>> +       struct tda18250_dev *dev = i2c_get_clientdata(client);
>> +       int ret;
>> +
>> +       dev_dbg(&client->dev, "\n");
>> +
>> +       /* power down LNA */
>> +       ret = regmap_write_bits(dev->regmap, R0C_AGC11, 0x80, 0x00);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = tda18250_power_control(fe, TDA18250_POWER_STANDBY);
>> +       return ret;
>> +}
>
> Do we know for sure if the IF_FREQUENCY is preserved after returning
> from a sleep?   It might be a good idea to set `dev->if_frequency = 0`
> within `tda18250_sleep` to be sure that it gets set again on the next
> tune, but you may want to check the specification first, if its
> available.
>
> This is not a show-stopper -- We can merge this as-is and this can be
> handled in a follow-up patch.

I will look into this and send a patch on top of this one if needed.

Thank you for pointing it out.

Cheers,
-olli
