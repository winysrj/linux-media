Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:45302 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751729AbdLLLmg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 06:42:36 -0500
Message-ID: <1513078952.3036.36.camel@perches.com>
Subject: Re: [PATCH] tuners: tda8290: reduce stack usage with kasan
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 12 Dec 2017 03:42:32 -0800
In-Reply-To: <CAK8P3a01sOsWSw4t-x6rv+9pzbfhZtEMc6iwV54Xq-48h6CN=Q@mail.gmail.com>
References: <20171211120612.3775893-1-arnd@arndb.de>
         <1513020868.3036.0.camel@perches.com>
         <CAOcJUbyARps1CeRFvLau3w-rBvn2QLbsY2PHGymbpUyuFCJ2HA@mail.gmail.com>
         <CAK8P3a01sOsWSw4t-x6rv+9pzbfhZtEMc6iwV54Xq-48h6CN=Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-12-12 at 11:24 +0100, Arnd Bergmann wrote:
> On Mon, Dec 11, 2017 at 10:17 PM, Michael Ira Krufky
> <mkrufky@linuxtv.org> wrote:
> > On Mon, Dec 11, 2017 at 2:34 PM, Joe Perches <joe@perches.com> wrote:
> > > On Mon, 2017-12-11 at 13:06 +0100, Arnd Bergmann wrote:
> > > > With CONFIG_KASAN enabled, we get a relatively large stack frame in one function
> > > > 
> > > > drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
> > > > drivers/media/tuners/tda8290.c:310:1: warning: the frame size of 1520 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > > > 
> > > > With CONFIG_KASAN_EXTRA this goes up to
> > > > 
> > > > drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
> > > > drivers/media/tuners/tda8290.c:310:1: error: the frame size of 3200 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> > > > 
> > > > We can significantly reduce this by marking local arrays as 'static const', and
> > > > this should result in better compiled code for everyone.
> > > 
> > > []
> > > > diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
> > > 
> > > []
> > > > @@ -63,8 +63,8 @@ static int tda8290_i2c_bridge(struct dvb_frontend *fe, int close)
> > > >  {
> > > >       struct tda8290_priv *priv = fe->analog_demod_priv;
> > > > 
> > > > -     unsigned char  enable[2] = { 0x21, 0xC0 };
> > > > -     unsigned char disable[2] = { 0x21, 0x00 };
> > > > +     static unsigned char  enable[2] = { 0x21, 0xC0 };
> > > > +     static unsigned char disable[2] = { 0x21, 0x00 };
> > > 
> > > Doesn't match commit message.
> > > 
> > > static const or just static?
> > > 
> > > > @@ -84,9 +84,9 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
> > > >  {
> > > >       struct tda8290_priv *priv = fe->analog_demod_priv;
> > > > 
> > > > -     unsigned char  enable[2] = { 0x45, 0xc1 };
> > > > -     unsigned char disable[2] = { 0x46, 0x00 };
> > > > -     unsigned char buf[3] = { 0x45, 0x01, 0x00 };
> > > > +     static unsigned char  enable[2] = { 0x45, 0xc1 };
> > > > +     static unsigned char disable[2] = { 0x46, 0x00 };
> > > 
> > > etc.
> > > 
> > > 
> > 
> > 
> > Joe is correct - they can be CONSTified. My bad -- a lot of the code I
> > wrote many years ago has this problem -- I wasn't so stack-conscious
> > back then.
> > 
> > The bytes in `enable` / `disable` don't get changed, but they may be
> > copied to another byte array that does get changed.  If would be best
> > to make these `static const`
> 
> Right. This was an older patch of mine that I picked up again
> after running into a warning that I had been ignoring for a while,
> and I didn't double-check the message.
> 
> I actually thought about marking them 'const' here before sending
> (without noticing the changelog text) and then ran into what must
> have led me to drop the 'const' originally: tuner_i2c_xfer_send()
> takes a non-const pointer. This can be fixed but it requires
> an ugly cast:

Casting away const is always a horrible hack.

Until it could be changed, my preference would
be to update the changelog and perhaps add to
the changelog the reason why it can not be const
as detailed below.

ie: xfer_send and xfer_xend_recv both take a
    non-const unsigned char *

> diff --git a/drivers/media/tuners/tuner-i2c.h b/drivers/media/tuners/tuner-i2c.h
> index bda67a5a76f2..809466eec780 100644
> --- a/drivers/media/tuners/tuner-i2c.h
> +++ b/drivers/media/tuners/tuner-i2c.h
> @@ -34,10 +34,10 @@ struct tuner_i2c_props {
>  };
> 
>  static inline int tuner_i2c_xfer_send(struct tuner_i2c_props *props,
> -                                     unsigned char *buf, int len)
> +                                     const unsigned char *buf, int len)
>  {
>         struct i2c_msg msg = { .addr = props->addr, .flags = 0,
> -                              .buf = buf, .len = len };
> +                              .buf = (unsigned char *)buf, .len = len };
>         int ret = i2c_transfer(props->adap, &msg, 1);
> 
>         return (ret == 1) ? len : ret;
> @@ -54,11 +54,11 @@ static inline int tuner_i2c_xfer_recv(struct
> tuner_i2c_props *props,
>  }
> 
>  static inline int tuner_i2c_xfer_send_recv(struct tuner_i2c_props *props,
> -                                          unsigned char *obuf, int olen,
> +                                          const unsigned char *obuf, int olen,
>                                            unsigned char *ibuf, int ilen)
>  {
>         struct i2c_msg msg[2] = { { .addr = props->addr, .flags = 0,
> -                                   .buf = obuf, .len = olen },
> +                                   .buf = (unsigned char *)obuf, .len = olen },
>                                   { .addr = props->addr, .flags = I2C_M_RD,
>                                     .buf = ibuf, .len = ilen } };
>         int ret = i2c_transfer(props->adap, msg, 2);
> 
> Should I submit it as a two-patch series with that added in, or update
> the changelog to not mention 'const' instead?
> 
>        Arnd
