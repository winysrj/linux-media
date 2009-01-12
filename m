Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZALSO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 13:14:56 -0500
Date: Mon, 12 Jan 2009 16:14:17 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linuxtv-commits@linuxtv.org, Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [hg:v4l-dvb] zoran: Fix a few CodingStyle issues rised by the
 previous patch
Message-ID: <20090112161417.10c57652@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0901120853140.23876@shell2.speakeasy.net>
References: <E1LM1s7-0005zU-JT@www.linuxtv.org>
	<Pine.LNX.4.58.0901111309070.1626@shell2.speakeasy.net>
	<20090111210505.3c675327@pedra.chehab.org>
	<Pine.LNX.4.58.0901120853140.23876@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mon, 12 Jan 2009 09:29:54 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Sun, 11 Jan 2009, Mauro Carvalho Chehab wrote:
> > On Sun, 11 Jan 2009 14:06:01 -0800 (PST)
> > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > On Sun, 11 Jan 2009, Patch from Mauro Carvalho Chehab wrote:
> > > > From: Mauro Carvalho Chehab  <mchehab@redhat.com>
> > > > zoran: Fix a few CodingStyle issues rised by the previous patch
> > >
> > > My first patch wasn't meant to be applied yet, I was going to ask you pull
> > > a series from my repository.  There was a change Jean suggested and that
> > > todo comment at the end wasn't supposed to go in.  And now the patches
> > > after it won't apply cleanly.
> >
> > Ah, I didn't know that you're intending to ask me to pull. I generally try to
> > apply earlier patches that fixes regressions upstream.
> >
> > > Do you intend to fold these two patches into one at git?  If so, then let
> > > me add another patch to fold into it as well.
> >
> > Yes, I can fold The tree patches into one on -git.
> 
> Here is the series.  The first patch should be merged with the other two.
> 
> http://linuxtv.org/hg/~tap/zoran
> 
Committed, thanks.

Please, always c/c linux-media@vger.kernel.org when asking me to pull patches.

Cheers,
Mauro
