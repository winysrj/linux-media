Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50006
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750879AbdIOJq5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 05:46:57 -0400
Date: Fri, 15 Sep 2017 06:46:48 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Honza =?UTF-8?B?UGV0cm91xaE=?= <jpetrous@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: Re: [PATCH 2/5] media: stv6110: get rid of a srate dead code
Message-ID: <20170915064648.255b161e@vento.lan>
In-Reply-To: <CAJbz7-3UQntON2hj6=4SCr82G_TrXvU5Voz8OAV=BPw=F+8xeQ@mail.gmail.com>
References: <1f1452d2f07a107e152754559a88166af50a3cbf.1505466580.git.mchehab@s-opensource.com>
        <be4198870b124684d5ce566cb8176e7298eae371.1505466580.git.mchehab@s-opensource.com>
        <CAJbz7-3UQntON2hj6=4SCr82G_TrXvU5Voz8OAV=BPw=F+8xeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 15 Sep 2017 11:30:11 +0200
Honza Petrouš <jpetrous@gmail.com> escreveu:

> Mauro, you are so speedy :)
> 
> 2017-09-15 11:10 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> > The stv6110 has a weird code that checks if get_property
> > and set_property ioctls are defined. If they're, it initializes
> > a "srate" var from properties cache. Otherwise, it sets to
> > 15MBaud, with won't make any sense.
> >
> > Thankfully, it seems that someone already noticed, as the
> > "srate" is not used anywhere!  
> 
> Hehe! "Someone else" :)

Yeah, true!

Just to be clear, I meant to say above that probably someone
noticed it in the past, and got rid of the usage of srate upstream,
but forgot to remove the var :-)

I updated the text. See enclosed.

> 
> >
> > So, get rid of that really weird dead code logic.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> Reported-by: Honza Petrous <jpetrous@gmail.com>

Thanks for reporting it!

Thanks,
Mauro

-

[PATCH] media: stv6110: get rid of a srate dead code

The stv6110 has a weird code that checks if get_property
and set_property ioctls are defined. If they're, it initializes
a "srate" var from properties cache. Otherwise, it sets to
15MBaud, with won't make any sense.

Thankfully, it seems that someone else discovered the issue in
the past, as "srate" is currently not used anywhere!

So, get rid of that really weird dead code logic.

Reported-by: Honza Petrous <jpetrous@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index e4fd9c1b0560..2821f6da6764 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -262,7 +262,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 	u8 ret = 0x04;
 	u32 divider, ref, p, presc, i, result_freq, vco_freq;
 	s32 p_calc, p_calc_opt = 1000, r_div, r_div_opt = 0, p_val;
-	s32 srate;
 
 	dprintk("%s, freq=%d kHz, mclk=%d Hz\n", __func__,
 						frequency, priv->mclk);
@@ -273,13 +272,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 				((((priv->mclk / 1000000) - 16) & 0x1f) << 3);
 
 	/* BB_GAIN = db/2 */
-	if (fe->ops.set_property && fe->ops.get_property) {
-		srate = c->symbol_rate;
-		dprintk("%s: Get Frontend parameters: srate=%d\n",
-							__func__, srate);
-	} else
-		srate = 15000000;
-
 	priv->regs[RSTV6110_CTRL2] &= ~0x0f;
 	priv->regs[RSTV6110_CTRL2] |= (priv->gain & 0x0f);
 
