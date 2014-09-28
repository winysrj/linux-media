Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38284 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaI1Mfb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 08:35:31 -0400
Date: Sun, 28 Sep 2014 09:35:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140928093526.17dca341@recife.lan>
In-Reply-To: <20140928115405.GA30490@linuxtv.org>
References: <20140926122721.GA11597@linuxtv.org>
	<20140926101222.778ebcaf@recife.lan>
	<20140926132513.GA30084@linuxtv.org>
	<20140926142543.GA3806@linuxtv.org>
	<54257888.90802@osg.samsung.com>
	<20140926150602.GA15766@linuxtv.org>
	<20140926152228.GA21876@linuxtv.org>
	<20140926124309.558c8682@recife.lan>
	<20140928105540.GA28748@linuxtv.org>
	<20140928081211.4b26aa18@recife.lan>
	<20140928115405.GA30490@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Sep 2014 13:54:05 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Sun, Sep 28, 2014 at 08:12:11AM -0300, Mauro Carvalho Chehab wrote:
> > Em Sun, 28 Sep 2014 12:55:40 +0200
> > Johannes Stezenbach <js@linuxtv.org> escreveu:
> > 
> > > I tried again both with and without the patch.  The issue above
> > > odesn't reproduce, but after hibernate it fails to tune
> > > (while it works after suspend-to-ram).  Restarting dvbv5-zap
> > > does not fix it.  All I get is:
> > > 
> > > [  500.299216] drxk: Error -22 on dvbt_sc_command
> > > [  500.301012] drxk: Error -22 on set_dvbt
> > > [  500.301967] drxk: Error -22 on start
> > 
> > Just to be 100% sure if I understood well: you're having exactly
> > the same behavior with and without my patch, right?
> 
> Yes, no observable difference in my tests.

Ok.

> > I'll see if I can work on another patch for you today. If not,
> > I won't be able to touch on it until the end of the week, as I'm
> > traveling next week.
> 
> no need to hurry
> 
> (BTW, I still think you should make sure the hang-on-resume fix,
> revert of b89193e0b06f, goes into 3.17, but it's your call.)

Well, it is simply too late. Linus will likely release 3.17 today.
Before sending a pull request to him, I need to send it to -next,
but, AFAIKT, there is no new -next release since Friday. The next one 
will be on Tuesday.

If this were some really bad regression, like a bug at DVB core that
would be preventing the entire subsystem to work, then I would be
overriding the rule of passing everything to -next before merging,
but this is not the case.

So, let's not rush it and prepare a proper suspend/resume patchset
for 3.17.1.

> > > On rmmod it Oopsed:
> ...
> > Please try this change:
> > 
> > [media] em28xx: remove firmware before releasing xc5000 priv state
> > 
> > hybrid_tuner_release_state() can free the priv state, so we need to
> > release the firmware before calling it.
> > 
> > Signed-off-by: Mauro Carvalho Chehab
> > 
> > diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> > index e44c8aba6074..803a0e63d47e 100644
> > --- a/drivers/media/tuners/xc5000.c
> > +++ b/drivers/media/tuners/xc5000.c
> > @@ -1333,9 +1333,9 @@ static int xc5000_release(struct dvb_frontend *fe)
> >  
> >  	if (priv) {
> >  		cancel_delayed_work(&priv->timer_sleep);
> > -		hybrid_tuner_release_state(priv);
> >  		if (priv->firmware)
> >  			release_firmware(priv->firmware);
> > +		hybrid_tuner_release_state(priv);
> >  	}
> >  
> >  	mutex_unlock(&xc5000_list_mutex);
> > 
> 
> Works.  And after module reload, dvbv5-zap can work again.

Good! One less bug.

Regards,
Mauro
