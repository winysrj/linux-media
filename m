Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:36012 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZJCH17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 03:27:59 -0400
Date: Sat, 3 Oct 2009 09:28:00 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Cc: James Blanford <jhblanford@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Race in gspca main or missing lock in stv06xx subdriver?
Message-ID: <20091003092800.27fbafb8@tele>
In-Reply-To: <62e5edd40910010623w58232a7cnf77a2e0c3679aab3@mail.gmail.com>
References: <20090914111757.543c7e77@blackbart.localnet.prv>
	<20090915124106.35ad1382@tele>
	<62e5edd40910010623w58232a7cnf77a2e0c3679aab3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Oct 2009 15:23:29 +0200
Erik Andrén <erik.andren@gmail.com> wrote:

> 2009/9/15 Jean-Francois Moine <moinejf@free.fr>:
	[snip]
> > I think you may have found a big problem, and this one should exist
> > in all drivers!
> >
> > As I understood, you say that the URB completion routine (isoc_irq)
> > may be run many times at the same time.
	[snip]
> > Then, to fix this problem, I see only one solution: have a private
> > tasklet to do the video streaming, as this is done for some bulk
> > transfer...
	[snip]
> Are you currently working on anything addressing this issue or do we
> need some further discussion?

Hi Erik,

No, I am not working on this problem: I cannot reproduce it (easy test:
have a static variable which is incremented in the irq function -
isoc_irq() in gspca.c - and warn when it is non null at entry).

May you (or anyone) check it?

Then, the simplest solution is not a tasklet, but to use only one URB
(change the '#define DEF_NURBS' to 1 instead of 3 in gspca.c).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
