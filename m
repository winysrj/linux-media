Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25484 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701Ab1ACXBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 18:01:13 -0500
Subject: Re: Summary of REGRESSIONS which are being ignored?! (Re: Summary
 of the pending patches up to Dec, 31 (26 patches))
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Hendrik Skarpeid <skarp@online.no>, stoth@kernellabs.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org
In-Reply-To: <4D21B7B1.6000608@redhat.com>
References: <4D1DCF6A.2090505@redhat.com>
	 <1293996645.2409.89.camel@localhost>  <4D21B7B1.6000608@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 18:01:39 -0500
Message-ID: <1294095699.10094.68.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, 2011-01-03 at 09:49 -0200, Mauro Carvalho Chehab wrote:
> Em 02-01-2011 17:30, Andy Walls escreveu:
> > I don't see this patch on it's way upstream:
> > 
> > https://patchwork.kernel.org/patch/376612/   (Sent on 5 Dec 2010)
> > http://www.spinics.net/lists/linux-media/msg26649.html (Resent on 19 Dec 2010)
> > 
> > It fixes a regression in IR and Analog video for cx23885 based cards and
> > an intermittent analog video regression in ivtv based cards in 2.6.36
> > and soon in 2.6.37.
> 
> Not sure what happened here. I'm sure I've applied on my fixes tree.
> Anyway, I'm re-applying it.

Thank you.

> > I emailed the LMML, you, and the author, as soon as I verified the root
> > cause on 31 Dec, and haven't heard from from anyone:
> > 
> > http://www.spinics.net/lists/linux-media/msg27261.html 
> 
> Here, Dec, 31 is a national holiday. People work only half of the day.
> Yet, I was finishing some things and preparing patches for the incoming 
> window, until afternoon.

I understand.  But AFAIK the 2.6.37 final is supposed to happen very
soon and the end user effects of the problem are very bad.


> I only noticed your email today, and I'm promptly sending it upstream,
> together with a patch revert for wm8775 regression.
> 
> > Please revert it before the merge window closes.
> 
> I'm sending it right now.

Thank you.


-Andy

