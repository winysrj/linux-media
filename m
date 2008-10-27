Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.10])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1KuY6z-0002Qc-PK
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 20:50:52 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Mon, 27 Oct 2008 20:50:42 +0100
References: <200810272023.23513.zzam@gentoo.org> <49061983.3070800@gmail.com>
In-Reply-To: <49061983.3070800@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810272050.43535.zzam@gentoo.org>
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] commit 9344:aa3a67b658e8 (DVB-Core update) breaks
	tuning of cx24123
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

On Montag, 27. Oktober 2008, Manu Abraham wrote:
> Hi Mathias,
>
Hi Manu!

> Matthias Schwarzott wrote:
> > Hi Manu, hi Steven!
> >
> > It seems an update of dvb-core breaks tuning of cx24123.
> > After updating to latest v4l-dvb the nova-s plus card just did no longer
> > lock to any channel. So I bisected it, and found this commit:
> >
> > changeset:   9344:aa3a67b658e8
> > parent:      9296:e2a8b9b9c294
> > user:        Manu Abraham <manu@linuxtv.org>
> > date:        Tue Oct 14 23:34:07 2008 +0400
> > summary:     DVB-Core update
> >
> > http://linuxtv.org/hg/v4l-dvb/rev/aa3a67b658e8
> >
> > It basically did update the dvb-kernel-thread and enhanced the code using
> > get_frontend_algo.
> >
> > The codepath when get_frontend_algo returns *_ALGO_HW stayed the same,
> > only one line got removed: params = &fepriv->parameter
> >
> > Just re-adding that line made my card working again. Either this was
> > lost, or the last two lines using "params" should also be converted to
> > directly use "&fepriv->parameters".
>
> True. In the port, the one line got missed out. Thanks for taking the
> time to look at it.
>
> BTW, i don't see any reason why cx24123 should be using HW_ALGO as it is
> a standard demodulator. When we have a dedicated microcontroller
> employed to do that check, we might like to use HW_ALGO, since it would
> simply handle it. Not in the case of standard demodulators. As an
> example i could say cinergyT2, dst etc would be candidates for HW_ALGO,
> where tuning is offloaded to a onboard microcontroller.
>
I dont have much insight in what these algo settings do. Only idea I have 
about this is: cx24123 may not need software zigzag.
If that gives a larger gain in lock-speed, then mt312 may also be a candidate 
for ALGO_HW as it can lock to signals not exactly centered to the IF.
But I doubt, as that hw then should lock at the first try and not even trigger 
zigzag steps.

> But overall, the fix looks fine though, for the devices that make use of
> HW_ALGO
>
>
> Please do have a Signed-off-by line so that it can be applied.
>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

> Reviewed-by: Manu Abraham <manu@linuxtv.org>
>
> Thanks,
> Manu
>
> > ------------------------------------------------------------------------
> >
> > --- v4l-dvb.orig/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> > +++ v4l-dvb/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> > @@ -584,6 +584,7 @@ restart:
> >
> >  				if (fepriv->state & FESTATE_RETUNE) {
> >  					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
> > +					params = &fepriv->parameters;
> >  					fepriv->state = FESTATE_TUNED;
> >  				}



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
