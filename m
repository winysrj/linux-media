Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63263 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2ISTZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 15:25:14 -0400
Received: by lbbgj3 with SMTP id gj3so1395952lbb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 12:25:12 -0700 (PDT)
Message-ID: <505A1C16.40507@gmail.com>
Date: Wed, 19 Sep 2012 21:25:10 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com> <5054C521.1090200@gmail.com> <20120915192530.74aedaa6@redhat.com> <50559241.6070408@gmail.com> <505844A0.30001@redhat.com> <5059C242.3010902@gmail.com> <5059F68F.4050009@redhat.com>
In-Reply-To: <5059F68F.4050009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-19 18:45, Mauro Carvalho Chehab wrote:
> Em 19-09-2012 10:01, Anders Thomson escreveu:
> >  On 2012-09-18 11:53, Mauro Carvalho Chehab wrote:
> >>  Em 16-09-2012 05:48, Anders Thomson escreveu:
> >>  >   It doesn't make any difference though :-( I still have the layer of noise...
> >>
> >>  That's weird. Hmm... perhaps priv->cfg.config is being initialized
> >>  latter. Maybe you can then do, instead:
> >>
> >>                    return -EREMOTEIO;
> >>            }
> >>
> >>  +        priv->cfg.switch_addr = priv->i2c_props.addr;
> >>            if ((data == 0x83) || (data == 0x84)) {
> >>                    priv->ver |= TDA18271;
> >>                    tda829x_tda18271_config.config = priv->cfg.config;
> >>
> >>
> >  No dice:
> >   $ git diff | cat
> >  diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
> >  index 8c48521..16d7ff7 100644
> >  --- a/drivers/media/common/tuners/tda8290.c
> >  +++ b/drivers/media/common/tuners/tda8290.c
> >  @@ -627,6 +627,9 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> >                  return -EREMOTEIO;
> >          }
> >
> >  +       tuner_info("ANDERS: old priv->cfg.switch_addr %x\n", priv->cfg.switch_addr);
> >  +       priv->cfg.switch_addr = priv->i2c_props.addr;
> >  +       tuner_info("ANDERS: new priv->cfg.switch_addr %x\n", priv->cfg.switch_addr);
> >          if ((data == 0x83) || (data == 0x84)) {
> >                  priv->ver |= TDA18271;
> >                  tda829x_tda18271_config.config = priv->cfg.config;
> >  @@ -640,7 +643,6 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> >
> >                  dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
> >                             priv->i2c_props.adap,&priv->cfg);
> >  -               priv->cfg.switch_addr = priv->i2c_props.addr;
> >          }
> >          if (fe->ops.tuner_ops.init)
> >                  fe->ops.tuner_ops.init(fe);
> >  anders@tv /usr/src/linux $ dmesg | grep ANDERS
> >  [    5.667022] tda829x 4-004b: ANDERS: old priv->cfg.switch_addr 0
> >  [    5.667025] tda829x 4-004b: ANDERS: new priv->cfg.switch_addr 4b
>
> switch_addr got properly filled here.
Well, it got filled with 4b, but that it not what is needed. Recall my 
own patch:
# cat /TV_CARD.diff
diff --git a/drivers/media/common/tuners/tda8290.c 
b/drivers/media/common/tuners/tda8290.c
index 064d14c..498cc7b 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)

                 dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
                            priv->i2c_props.adap, &priv->cfg);
+               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new 
0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
                 priv->cfg.switch_addr = priv->i2c_props.addr;
+               priv->cfg.switch_addr = 0xc2 / 2;
+               tuner_info("ANDERS: new 0x%02x\n",priv->cfg.switch_addr);
+
         }
         if (fe->ops.tuner_ops.init)
                 fe->ops.tuner_ops.init(fe);
It needs to be filled with 0xc2 / 2. I'm not sure where I got that 
expression from, but it is the sum of my efforts tracing code changes 
around 2.6.26.
> >
> >  Whereas to work, I need:
> >  anders@tv /usr/src/linux $ grep ANDERS /3.3.8-d.patched
> >  [    6.565254] tda829x 5-004b: ANDERS: setting switch_addr. was 0x00, new 0x4b
>
> What looks weird here is that the device number changed from 4 to 5.
I have a webcam permanently on USB, so it ends up as two v4l2 devices 
(with device enumeration changing between boots)
>
> Do you have more than one board on your machine?
>
> >  [    6.565265] tda829x 5-004b: ANDERS: new 0x61
>
>
> The 0x61 address should be filled already by the existing code, otherwise
> you wouldn't be able to switch from one channel to another one.
>
> If you're in doubt, you could add an extra printk at the initialization code,
> in order to see what's happening there.
Not sure I follow here. Which code should set the ox61 address? I'd be 
more than happy to add printks. Where? I recall getting lost in how this 
stuff uses the i2c code in the past.
