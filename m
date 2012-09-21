Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab2IUOtM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 10:49:12 -0400
Message-ID: <505C7E64.4040507@redhat.com>
Date: Fri, 21 Sep 2012 11:49:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Anders Eriksson <aeriksson2@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com> <5054C521.1090200@gmail.com> <20120915192530.74aedaa6@redhat.com> <50559241.6070408@gmail.com> <505844A0.30001@redhat.com> <5059C242.3010902@gmail.com> <5059F68F.4050009@redhat.com> <505A1C16.40507@gmail.com> <CAGncdOae+VoAAUWz3x84zUA-TCMeMmNONf_ktNFd1p7c-o5H_A@mail.gmail.com>
In-Reply-To: <CAGncdOae+VoAAUWz3x84zUA-TCMeMmNONf_ktNFd1p7c-o5H_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-09-2012 10:59, Anders Eriksson escreveu:
> 
> 
> On Wed, Sep 19, 2012 at 9:25 PM, Anders Thomson <aeriksson2@gmail.com <mailto:aeriksson2@gmail.com>> wrote:
> 
>     diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
>     index 064d14c..498cc7b 100644
>     --- a/drivers/media/common/tuners/__tda8290.c
>     +++ b/drivers/media/common/tuners/__tda8290.c
>     @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> 
> 
>                     dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
>                                priv->i2c_props.adap, &priv->cfg);
>     +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new 0x%02x\n",priv->cfg.switch___addr,priv->i2c_props.addr);
>                     priv->cfg.switch_addr = priv->i2c_props.addr;
>     +               priv->cfg.switch_addr = 0xc2 / 2;
>     +               tuner_info("ANDERS: new 0x%02x\n",priv->cfg.switch___addr);
>     +
>             }
>             if (fe->ops.tuner_ops.init)
>                     fe->ops.tuner_ops.init(fe);
>     It needs to be filled with 0xc2 / 2. I'm not sure where I got that expression from, but it is the sum of my efforts tracing code changes around 2.6.26.
> 
>         >
>         >  Whereas to work, I need:
>         >  anders@tv /usr/src/linux $ grep ANDERS /3.3.8-d.patched
>         >  [    6.565254] tda829x 5-004b: ANDERS: setting switch_addr. was 0x00, new 0x4b
> 
>         What looks weird here is that the device number changed from 4 to 5.
> 
> 
>         If you're in doubt, you could add an extra printk at the initialization code,
>         in order to see what's happening there.
> 
>     Not sure I follow here. Which code should set the ox61 address? I'd be more than happy to add printks. Where? I recall getting lost in how this stuff uses the i2c code in the past.
> 
> 
> Hi,
> Dusting off my memory, I realized that there was a thread on this way back when I discovered the breakage:
> You can find the archived thread here:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg05332.html
> 
> Still puzzled as to how I can pursue this further.

Are you using the active antena that came with this device[1]?


[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg07234.html

> 
> -Anders

