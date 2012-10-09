Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2JIWpB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 18:45:01 -0400
Date: Tue, 9 Oct 2012 19:44:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org
Subject: Re: [git:v4l-dvb/for_v3.7] [media] tda18271-common: hold the I2C
 adapter during write transfers
Message-ID: <20121009194446.1c652e72@redhat.com>
In-Reply-To: <CAOcJUbzHUA4bCc2FRfThC80BjBc2RkT25-LuYZzQMANjtTTy2w@mail.gmail.com>
References: <E1TKqkK-0005vN-Nl@www.linuxtv.org>
	<CAOcJUbzHUA4bCc2FRfThC80BjBc2RkT25-LuYZzQMANjtTTy2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 7 Oct 2012 09:19:51 -0400
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> umm, again, i didn't actually ACK the patch, I verbally said "ok, i guess"
> 
> You shouldn't forge someone's signature, Mauro.  :-(

First of all, acked-by is not a signature. Those tags (acked, reviewed, tested,
reported, etc) are pure indications of the status of the patch, e. g.
if someone looked into the issue. 

In this specific case, what you said, instead was, literally: "So, I retract my NACK."

Well, you're the driver maintainer, so I expected your considerations.

You firstly reviewed it and gave a NACK. Then, you reviewed it again
and reverted a NACK. The opposite of a NACK is an ACK. This is pure boolean.

If you had, instead asked me for more time to review, I would have kept
it in hold.

Now that it got merged, what we can do is to revert it, if you have good
reasons for that, or to keep it. 

Your call.

Regards,
Mauro

> 
> On Sun, Oct 7, 2012 at 8:43 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > This is an automatic generated email to let you know that the following patch were queued at the
> > http://git.linuxtv.org/media_tree.git tree:
> >
> > Subject: [media] tda18271-common: hold the I2C adapter during write transfers
> > Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
> > Date:    Fri Sep 28 11:04:21 2012 -0300
> >
> > The tda18271 datasheet says:
> >         "The image rejection calibration and RF tracking filter
> >          calibration must be launched exactly as described in the
> >          flowchart, otherwise bad calibration or even blocking of the
> >          TDA18211HD can result making it impossible to communicate
> >          via the I2C-bus."
> > (yeah, tda18271 refers there to tda18211 - likely a typo at their
> >  datasheets)
> > That likely explains why sometimes tda18271 stops answering. That
> > is now happening more often on designs with drx-k chips, as the
> > firmware is now loaded asyncrousnly there.
> > While the above text doesn't explicitly tell that the I2C bus
> > couldn't be used by other devices during such initialization,
> > that seems to be a requirement there.
> > So, let's explicitly use the I2C lock there, avoiding I2C bus
> > share during those critical moments.
> > Compile-tested only. Please test.
> >
> > Acked-by: Michael Krufky <mkrufky@linuxtv.org>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >
> >  drivers/media/tuners/tda18271-common.c |  104 ++++++++++++++++++++++----------
> >  1 files changed, 71 insertions(+), 33 deletions(-)
> >
> > ---
> >
> > http://git.linuxtv.org/media_tree.git?a=commitdiff;h=78ef81f6ea9649fd09d1fafcfa0ad68763172c42
> >
> > diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
> > index 221171e..18c77af 100644
> > --- a/drivers/media/tuners/tda18271-common.c
> > +++ b/drivers/media/tuners/tda18271-common.c
> > @@ -187,7 +187,8 @@ int tda18271_read_extended(struct dvb_frontend *fe)
> >         return (ret == 2 ? 0 : ret);
> >  }
> >
> > -int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> > +static int __tda18271_write_regs(struct dvb_frontend *fe, int idx, int len,
> > +                       bool lock_i2c)
> >  {
> >         struct tda18271_priv *priv = fe->tuner_priv;
> >         unsigned char *regs = priv->tda18271_regs;
> > @@ -198,7 +199,6 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> >
> >         BUG_ON((len == 0) || (idx + len > sizeof(buf)));
> >
> > -
> >         switch (priv->small_i2c) {
> >         case TDA18271_03_BYTE_CHUNK_INIT:
> >                 max = 3;
> > @@ -214,7 +214,19 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> >                 max = 39;
> >         }
> >
> > -       tda18271_i2c_gate_ctrl(fe, 1);
> > +
> > +       /*
> > +        * If lock_i2c is true, it will take the I2C bus for tda18271 private
> > +        * usage during the entire write ops, as otherwise, bad things could
> > +        * happen.
> > +        * During device init, several write operations will happen. So,
> > +        * tda18271_init_regs controls the I2C lock directly,
> > +        * disabling lock_i2c here.
> > +        */
> > +       if (lock_i2c) {
> > +               tda18271_i2c_gate_ctrl(fe, 1);
> > +               i2c_lock_adapter(priv->i2c_props.adap);
> > +       }
> >         while (len) {
> >                 if (max > len)
> >                         max = len;
> > @@ -226,14 +238,17 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> >                 msg.len = max + 1;
> >
> >                 /* write registers */
> > -               ret = i2c_transfer(priv->i2c_props.adap, &msg, 1);
> > +               ret = __i2c_transfer(priv->i2c_props.adap, &msg, 1);
> >                 if (ret != 1)
> >                         break;
> >
> >                 idx += max;
> >                 len -= max;
> >         }
> > -       tda18271_i2c_gate_ctrl(fe, 0);
> > +       if (lock_i2c) {
> > +               i2c_unlock_adapter(priv->i2c_props.adap);
> > +               tda18271_i2c_gate_ctrl(fe, 0);
> > +       }
> >
> >         if (ret != 1)
> >                 tda_err("ERROR: idx = 0x%x, len = %d, "
> > @@ -242,10 +257,16 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> >         return (ret == 1 ? 0 : ret);
> >  }
> >
> > +int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> > +{
> > +       return __tda18271_write_regs(fe, idx, len, true);
> > +}
> > +
> >  /*---------------------------------------------------------------------*/
> >
> > -int tda18271_charge_pump_source(struct dvb_frontend *fe,
> > -                               enum tda18271_pll pll, int force)
> > +static int __tda18271_charge_pump_source(struct dvb_frontend *fe,
> > +                                        enum tda18271_pll pll, int force,
> > +                                        bool lock_i2c)
> >  {
> >         struct tda18271_priv *priv = fe->tuner_priv;
> >         unsigned char *regs = priv->tda18271_regs;
> > @@ -255,9 +276,16 @@ int tda18271_charge_pump_source(struct dvb_frontend *fe,
> >         regs[r_cp] &= ~0x20;
> >         regs[r_cp] |= ((force & 1) << 5);
> >
> > -       return tda18271_write_regs(fe, r_cp, 1);
> > +       return __tda18271_write_regs(fe, r_cp, 1, lock_i2c);
> > +}
> > +
> > +int tda18271_charge_pump_source(struct dvb_frontend *fe,
> > +                               enum tda18271_pll pll, int force)
> > +{
> > +       return __tda18271_charge_pump_source(fe, pll, force, true);
> >  }
> >
> > +
> >  int tda18271_init_regs(struct dvb_frontend *fe)
> >  {
> >         struct tda18271_priv *priv = fe->tuner_priv;
> > @@ -267,6 +295,13 @@ int tda18271_init_regs(struct dvb_frontend *fe)
> >                 i2c_adapter_id(priv->i2c_props.adap),
> >                 priv->i2c_props.addr);
> >
> > +       /*
> > +        * Don't let any other I2C transfer to happen at adapter during init,
> > +        * as those could cause bad things
> > +        */
> > +       tda18271_i2c_gate_ctrl(fe, 1);
> > +       i2c_lock_adapter(priv->i2c_props.adap);
> > +
> >         /* initialize registers */
> >         switch (priv->id) {
> >         case TDA18271HDC1:
> > @@ -352,28 +387,28 @@ int tda18271_init_regs(struct dvb_frontend *fe)
> >         regs[R_EB22] = 0x48;
> >         regs[R_EB23] = 0xb0;
> >
> > -       tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
> > +       __tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS, false);
> >
> >         /* setup agc1 gain */
> >         regs[R_EB17] = 0x00;
> > -       tda18271_write_regs(fe, R_EB17, 1);
> > +       __tda18271_write_regs(fe, R_EB17, 1, false);
> >         regs[R_EB17] = 0x03;
> > -       tda18271_write_regs(fe, R_EB17, 1);
> > +       __tda18271_write_regs(fe, R_EB17, 1, false);
> >         regs[R_EB17] = 0x43;
> > -       tda18271_write_regs(fe, R_EB17, 1);
> > +       __tda18271_write_regs(fe, R_EB17, 1, false);
> >         regs[R_EB17] = 0x4c;
> > -       tda18271_write_regs(fe, R_EB17, 1);
> > +       __tda18271_write_regs(fe, R_EB17, 1, false);
> >
> >         /* setup agc2 gain */
> >         if ((priv->id) == TDA18271HDC1) {
> >                 regs[R_EB20] = 0xa0;
> > -               tda18271_write_regs(fe, R_EB20, 1);
> > +               __tda18271_write_regs(fe, R_EB20, 1, false);
> >                 regs[R_EB20] = 0xa7;
> > -               tda18271_write_regs(fe, R_EB20, 1);
> > +               __tda18271_write_regs(fe, R_EB20, 1, false);
> >                 regs[R_EB20] = 0xe7;
> > -               tda18271_write_regs(fe, R_EB20, 1);
> > +               __tda18271_write_regs(fe, R_EB20, 1, false);
> >                 regs[R_EB20] = 0xec;
> > -               tda18271_write_regs(fe, R_EB20, 1);
> > +               __tda18271_write_regs(fe, R_EB20, 1, false);
> >         }
> >
> >         /* image rejection calibration */
> > @@ -391,21 +426,21 @@ int tda18271_init_regs(struct dvb_frontend *fe)
> >         regs[R_MD2] = 0x08;
> >         regs[R_MD3] = 0x00;
> >
> > -       tda18271_write_regs(fe, R_EP3, 11);
> > +       __tda18271_write_regs(fe, R_EP3, 11, false);
> >
> >         if ((priv->id) == TDA18271HDC2) {
> >                 /* main pll cp source on */
> > -               tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 1);
> > +               __tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 1, false);
> >                 msleep(1);
> >
> >                 /* main pll cp source off */
> > -               tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 0);
> > +               __tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 0, false);
> >         }
> >
> >         msleep(5); /* pll locking */
> >
> >         /* launch detector */
> > -       tda18271_write_regs(fe, R_EP1, 1);
> > +       __tda18271_write_regs(fe, R_EP1, 1, false);
> >         msleep(5); /* wanted low measurement */
> >
> >         regs[R_EP5] = 0x85;
> > @@ -413,11 +448,11 @@ int tda18271_init_regs(struct dvb_frontend *fe)
> >         regs[R_CD1] = 0x66;
> >         regs[R_CD2] = 0x70;
> >
> > -       tda18271_write_regs(fe, R_EP3, 7);
> > +       __tda18271_write_regs(fe, R_EP3, 7, false);
> >         msleep(5); /* pll locking */
> >
> >         /* launch optimization algorithm */
> > -       tda18271_write_regs(fe, R_EP2, 1);
> > +       __tda18271_write_regs(fe, R_EP2, 1, false);
> >         msleep(30); /* image low optimization completion */
> >
> >         /* mid-band */
> > @@ -428,11 +463,11 @@ int tda18271_init_regs(struct dvb_frontend *fe)
> >         regs[R_MD1] = 0x73;
> >         regs[R_MD2] = 0x1a;
> >
> > -       tda18271_write_regs(fe, R_EP3, 11);
> > +       __tda18271_write_regs(fe, R_EP3, 11, false);
> >         msleep(5); /* pll locking */
> >
> >         /* launch detector */
> > -       tda18271_write_regs(fe, R_EP1, 1);
> > +       __tda18271_write_regs(fe, R_EP1, 1, false);
> >         msleep(5); /* wanted mid measurement */
> >
> >         regs[R_EP5] = 0x86;
> > @@ -440,11 +475,11 @@ int tda18271_init_regs(struct dvb_frontend *fe)
> >         regs[R_CD1] = 0x66;
> >         regs[R_CD2] = 0xa0;
> >
> > -       tda18271_write_regs(fe, R_EP3, 7);
> > +       __tda18271_write_regs(fe, R_EP3, 7, false);
> >         msleep(5); /* pll locking */
> >
> >         /* launch optimization algorithm */
> > -       tda18271_write_regs(fe, R_EP2, 1);
> > +       __tda18271_write_regs(fe, R_EP2, 1, false);
> >         msleep(30); /* image mid optimization completion */
> >
> >         /* high-band */
> > @@ -456,30 +491,33 @@ int tda18271_init_regs(struct dvb_frontend *fe)
> >         regs[R_MD1] = 0x71;
> >         regs[R_MD2] = 0xcd;
> >
> > -       tda18271_write_regs(fe, R_EP3, 11);
> > +       __tda18271_write_regs(fe, R_EP3, 11, false);
> >         msleep(5); /* pll locking */
> >
> >         /* launch detector */
> > -       tda18271_write_regs(fe, R_EP1, 1);
> > +       __tda18271_write_regs(fe, R_EP1, 1, false);
> >         msleep(5); /* wanted high measurement */
> >
> >         regs[R_EP5] = 0x87;
> >         regs[R_CD1] = 0x65;
> >         regs[R_CD2] = 0x50;
> >
> > -       tda18271_write_regs(fe, R_EP3, 7);
> > +       __tda18271_write_regs(fe, R_EP3, 7, false);
> >         msleep(5); /* pll locking */
> >
> >         /* launch optimization algorithm */
> > -       tda18271_write_regs(fe, R_EP2, 1);
> > +       __tda18271_write_regs(fe, R_EP2, 1, false);
> >         msleep(30); /* image high optimization completion */
> >
> >         /* return to normal mode */
> >         regs[R_EP4] = 0x64;
> > -       tda18271_write_regs(fe, R_EP4, 1);
> > +       __tda18271_write_regs(fe, R_EP4, 1, false);
> >
> >         /* synchronize */
> > -       tda18271_write_regs(fe, R_EP1, 1);
> > +       __tda18271_write_regs(fe, R_EP1, 1, false);
> > +
> > +       i2c_unlock_adapter(priv->i2c_props.adap);
> > +       tda18271_i2c_gate_ctrl(fe, 0);
> >
> >         return 0;
> >  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
