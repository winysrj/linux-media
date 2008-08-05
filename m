Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Wed, 6 Aug 2008 07:55:18 +1000
From: Anton Blanchard <anton@samba.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080805215518.GB7314@kryten>
References: <20080804131051.GA7241@kryten>
	<37219a840808040935o3cf613bdvd644bb0e592c8430@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <37219a840808040935o3cf613bdvd644bb0e592c8430@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DViCO FusionHDTV DVB-T Dual Digital 4
	(rev	2)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi Mike,

Thanks for the review! I will incorporate your suggestions and get a new
patch out in a day or so.

> > Index: v4l-dvb/linux/drivers/media/dvb/frontends/dib7000p.c
> > ===================================================================
> > --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/dib7000p.c   2008-08-04 18:10:30.000000000 +1000
> > +++ v4l-dvb/linux/drivers/media/dvb/frontends/dib7000p.c        2008-08-04 18:10:46.000000000 +1000
> > @@ -1359,7 +1359,8 @@
> >        /* Ensure the output mode remains at the previous default if it's
> >         * not specifically set by the caller.
> >         */
> > -       if (st->cfg.output_mode != OUTMODE_MPEG2_SERIAL)
> > +       if ((st->cfg.output_mode != OUTMODE_MPEG2_SERIAL) &&
> > +           (st->cfg.output_mode != OUTMODE_MPEG2_PAR_GATED_CLK))
> >                st->cfg.output_mode = OUTMODE_MPEG2_FIFO;
> 
> 
> 
> There doesnt look to be anything wrong with this, but I don't know
> very much about this -- why is this needed?  Have you tested on other
> devices that use dib7000p to confirm that it doesn't break anything?

This got introduced with the patch to allow the output mode to be
configured:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a38d6e37c0bc073bae5eff37c939978974ea9712

It looks to be making sure the patch didnt regress anything at the time.
Unfortunately it means we always set it to OUTMODE_MPEG2_FIFO. The patch
above just allows both OUTMODE_MPEG2_FIFO and
OUTMODE_MPEG2_PAR_GATED_CLK to be set.

We could shuffle the output modes around and make 0 the default
(OUTMODE_MPEG2_FIFO), or just go in and add initialise the output_mode
field in all dib7000p based drivers.

Anton

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
