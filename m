Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:45121 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1FCNdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 09:33:31 -0400
Subject: Re: [GIT PULL FOR 2.6.40] PCTV nanoStick T2 290e (Sony CXD2820R
 DVB-T/T2/C)
From: Steve Kerrison <steve@stevekerrison.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-media@vger.kernel.org
In-Reply-To: <8762onxcuc.fsf@nemi.mork.no>
References: <4DDD69AE.3070606@iki.fi> <4DE63E43.1090208@redhat.com>
	 <4DE8D4CD.7070708@iki.fi>  <8762onxcuc.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 14:33:27 +0100
Message-ID: <1307108007.2341.2.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Here in the UK the mux strengths and parameters are all over the place.

I have had situations in the past (with dib0700 I think) where I've had
to twiddle the force_lna setting one way or the other depending on how
they've decided to reconfigure my local transmitter.

So I'd be cautious about flat-out enabling it the whole time.
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Fri, 2011-06-03 at 15:29 +0200, Bjørn Mork wrote:
> Antti Palosaari <crope@iki.fi> writes:
> > On 06/01/2011 04:27 PM, Mauro Carvalho Chehab wrote:
> >> Em 25-05-2011 17:42, Antti Palosaari escreveu:
> >>> Antti Palosaari (7):
> >>>        em28xx-dvb: add module param "options" and use it for LNA
> >>
> >> That patch is ugly, for several reasons:
> >>
> >> 1) we don't want a generic "options" parameter, whose meaning changes from
> >>     device to devices;
> >
> > I agree it is not proper solution, but in my mind it is better to
> > offer some solution than no solution at all.
> >
> >> 2) what happens if someone has two em28xx devices plugged?
> >
> > It depends depends devices, currently only nanoStick T2 only looks
> > that param, other just ignore. If there is two nanoStics then both
> > have same LNA settings.
> >
> > That's just like same behaviour as for example remote controller
> > polling. Or for example DiBcom driver LNA, since it does have similar
> > module param already. Will you you commit it if I rename it similarly
> > as DiBcom?
> >
> >> 3) the better would be to detect if LNA is needed, or to add a DVBS2API
> >>     call to enable/disable LNA.
> >
> > True, but it needs some research. There is many hardware which gets
> > signal input from demod or tuner and makes some fine tune according to
> > that. We need to define some new callbacks for demod and tuner in
> > order to do this kind of actions.
> > Or just add new LNA param to API use it manually.
> 
> 
> Or option 
> 4) just enable the LNA unconditionally.  
> 
> I did some testing in my environment, and I was unable to tune anything
> on either DVB-T or DVB-C without the LNA enabled.  I'm of course aware
> that this depends on your signal, but have you actually seen a real life
> signal where tuning fails with the LNA enabled and works without it?
> 
> I do believe that my DVB-C signal at least is pretty strong.
> 
> 
> 
> Bjørn
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

