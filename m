Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59927 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754336AbdKAMhl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 08:37:41 -0400
Date: Wed, 1 Nov 2017 10:37:35 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Michael Ira Krufky <mkrufky@linuxtv.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv3 1/2] tda18250: support for new silicon tuner
Message-ID: <20171101103735.59e9c77c@vento.lan>
In-Reply-To: <CAAZRmGwuHRHxzvfQCBc+uTq+FCo6Z_2f_oT=H70TCpwQfouLvA@mail.gmail.com>
References: <CAAZRmGwuHRHxzvfQCBc+uTq+FCo6Z_2f_oT=H70TCpwQfouLvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Oct 2017 05:31:40 +0200
Olli Salonen <olli.salonen@iki.fi> escreveu:

> Hello Michael,
> 
> Many thanks for taking the time to review the patches.
> 
> On 27 October 2017 at 13:27, Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
> >> +static int tda18250_sleep(struct dvb_frontend *fe)
> >> +{
> >> +       struct i2c_client *client = fe->tuner_priv;
> >> +       struct tda18250_dev *dev = i2c_get_clientdata(client);
> >> +       int ret;
> >> +
> >> +       dev_dbg(&client->dev, "\n");
> >> +
> >> +       /* power down LNA */
> >> +       ret = regmap_write_bits(dev->regmap, R0C_AGC11, 0x80, 0x00);
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       ret = tda18250_power_control(fe, TDA18250_POWER_STANDBY);
> >> +       return ret;
> >> +}  
> >
> > Do we know for sure if the IF_FREQUENCY is preserved after returning
> > from a sleep?   It might be a good idea to set `dev->if_frequency = 0`
> > within `tda18250_sleep` to be sure that it gets set again on the next
> > tune, but you may want to check the specification first, if its
> > available.
> >
> > This is not a show-stopper -- We can merge this as-is and this can be
> > handled in a follow-up patch.  
> 
> I will look into this and send a patch on top of this one if needed.
> 
> Thank you for pointing it out.

There is a show-stopper issue here, though: it lacks adding an
entry for the driver at MAINTAINERS file :-)

Please add it.

While here, please look at the checkpatch warnings:

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
#746: FILE: drivers/media/tuners/tda18250.c:678:
+ msleep(5);

and the 80 column ones. I was unable to see, at the places it complained,
a reason why not limit the lines to 80 columns.

Regards,

Thanks,
Mauro
