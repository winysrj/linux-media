Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:44027 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755852Ab0EaDVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 23:21:50 -0400
Subject: Re: What ever happened to standardizing signal level?
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Markus Rechberger <mrechberger@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <4C0326C6.7020800@linuxtv.org>
References: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com>
	 <1275198741.3213.50.camel@pc07.localdom.local>
	 <AANLkTilIrG5cwlLv_iAI7E7XX5117qh4AHof80pRRYSs@mail.gmail.com>
	 <AANLkTin97BxcUYCUvUt_UiXJUUKdbYNoAqFtqX1rf-EE@mail.gmail.com>
	 <4C02826A.6010207@linuxtv.org>
	 <AANLkTimRDtZiUxJLMI7ftx6e6Ouwe5bqZbElgAgtGgE-@mail.gmail.com>
	 <4C0326C6.7020800@linuxtv.org>
Content-Type: text/plain
Date: Mon, 31 May 2010 05:21:42 +0200
Message-Id: <1275276102.3174.25.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 30.05.2010, 23:02 -0400 schrieb Michael Krufky:
> Markus Rechberger wrote:
> > On Sun, May 30, 2010 at 5:21 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> >> Markus Rechberger wrote:
> >>> Hi,
> >>>
> >>> A little bit more "ontopic", did anyone get around to read the
> >>> signallevel of the tda18721?
> >>> I wonder the register does not return any signallevel as indicated in
> >>> the specifications.
> >>>
> >>> Markus
> >> There is a "power level" value that can be read from the tda18271 -- I had a
> >> patch that enabled reading of this value, for testing purposes, but it
> >> wasn't as useful as I had hoped, so I never bothered to merge it.
> >>
> >> If you'd like to play with it, I pushed up some code last year:
> >>
> >> http://kernellabs.com/hg/~mkrufky/tda18271-pl/rev/4373874cff29
> >>
> >> Let me know how this works for you, or if you choose to change it.  I If you
> >> find it valuable, we can merge it in somehow.
> >>
> > 
> > hmm.. I somewhat tried the same but the register kept flipping back
> > and the powerlevel register returned 0.
> > 
> > Markus
> 
> ...I think it only works on the c2 rev silicon.  Not sure about that, 
> though.
> 
> -Mike
> 

that is such stuff that really happens and nobody has any "intentions"
to hide better signal/SNR measurements from the users.

Some multiple subscribed trolls may take it for a next round, but it is
_nowhere_ any better.

Even worse, on S2, the whole previous model of doing so, will come under
pressure, if I'm not totally blind.

Best,
Hermann


