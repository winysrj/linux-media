Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910Ab0E0Vmc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 17:42:32 -0400
Date: Thu, 27 May 2010 18:42:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
Message-ID: <20100527184210.3471b7da@pedra>
In-Reply-To: <20100527160548.0f4ae0ab@zombie>
References: <20100507093916.2e2ef8e3@pedra>
	<x2w1a297b361005070610lda8d8d2ve90011bbfff320ee@mail.gmail.com>
	<4BE4BDB5.60509@redhat.com>
	<20100527160548.0f4ae0ab@zombie>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 May 2010 16:05:48 +0200
Guy Martin <gmsoft@tuxicoman.be> escreveu:

> 
> Hi Mauro,
> 
> 
> Sorry for the delay, I was abroad.
> Let me detail the issue a bit more.
> 
> In budget.c, the the frontend is attached this way :
> 
> budget->dvb_frontend = dvb_attach(stv090x_attach,
> &tt1600_stv090x_config, &budget->i2c_adap, STV090x_DEMODULATOR_0);
> 
> This means that the tt1600_stv090x_config structure will be common for
> all the cards.
> 
> Then the tuner is attached to the frontend :
> 
> ctl = dvb_attach(stv6110x_attach, budget->dvb_frontend,
> &tt1600_stv6110x_config, &budget->i2c_adap);
> 
> Once the tuner is attached, the ops are copied to the config :
> tt1600_stv090x_config.tuner_sleep         = ctl->tuner_sleep;
> 
> This results in the ops being set for subsequently attached cards while
> fe->tuner_priv is NULL.
> 
> This is why a check for tuner_priv being set is mandatory when calling
> tuner_sleep(). However as pointed out, it may not be the best fix.

Ok. I'll commit it for now, as it is a simple patch and can be easily be applied
at stable. The proper patch would be to avoid calling the function at the
second board with tuner_priv = NULL.
> 
> Regards,
>   Guy
> 
> 
> 
> On Fri, 07 May 2010 22:26:13 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > Manu Abraham wrote:
> > > On Fri, May 7, 2010 at 4:39 PM, Mauro Carvalho Chehab
> > > <mchehab@redhat.com> wrote:
> > >> Hi,
> > >>
> > > 
> > >> This is the summary of the patches that are currently under review.
> > >> Each patch is represented by its submission date, the subject (up
> > >> to 70 chars) and the patchwork link (if submitted via email).
> > >>
> > >> P.S.: This email is c/c to the developers that some review action
> > >> is expected.
> > >>
> > >> May, 7 2010: [v2] stv6110x Fix kernel null pointer deref when
> > >> plugging two TT s2-16 http://patchwork.kernel.org/patch/97612
> > > 
> > > 
> > > How is this patch going to fix a NULL ptr dereference when more
> > > than 1 card is plugged in ? The patch doesn't seem to do what the
> > > patch title implies. At least the patch title seems to be wrong.
> > > Maybe the patch is supposed to check for a possible NULL ptr
> > > dereference when put to sleep ?
> > 
> > (c/c patch author, to be sure that he'll see your explanation request)
> > 
> > His original patch is at:
> > 	https://patchwork.kernel.org/patch/91929/
> > 
> > The original description with the bug were much better than version 2.
> > 
> > From his OOPS log and description, I suspect that he's facing some
> > sort of race condition with the two cards. 
> > 
> > This fix seems still valid (with an updated comment), as his dump
> > proofed that there are some cases where fe->tuner_priv can be null, 
> > generating an OOPS, but it seems that his patch is combating
> > the effect, and not the cause.
> > 
> > So, I am for adding his patch for now, and then work on a more
> > complete approach for the two cards environment.
> > 
> 


-- 

Cheers,
Mauro
