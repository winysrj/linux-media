Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZITJbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 05:31:14 -0400
Date: Sun, 20 Sep 2009 06:30:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <damm@igel.co.jp>
Subject: Re: Diffs between our tree and upstream
Message-ID: <20090920063039.47318a65@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0909201053530.332@axis700.grange>
References: <20090919010602.7e8f2df2@pedra.chehab.org>
	<20090919091644.0219cfba@pedra.chehab.org>
	<Pine.LNX.4.64.0909201053530.332@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 Sep 2009 10:57:34 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi Mauro
> 
> On Sat, 19 Sep 2009, Mauro Carvalho Chehab wrote:
> 
> > Em Sat, 19 Sep 2009 01:06:02 -0300
> > Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> > 
> > > Hi Guennadi,
> > > 
> > > I'm about to send our pull request.
> > > 
> > > While doing my last checks, I noticed a difference between our tree and
> > > upstream. I'm not sure what happens. Could you please check?
> > > 
> > > The enclosed patch is the diff from upstream to -hg.
> > 
> > Ok, I discovered the cause of the conflict: 
> > 	git patch 6d1386c6b8db54ac8d94c01194e0c27cd538532b were applied before the
> > soc_camera conversion to v4l dev/subdev.
> > 
> > I've applied the patch on our development tree. Still, we have a few diffs,
> > probably meaning that I solved it at the wrong way at git.
> 
> No, please, don't change anything in our trees. Pual should have pushed 
> his tree after v4l to Linus, but he has done it before. The idea is we 
> should push our tree as is and then solve the conflict on merge. That 
> should be easy. But if you start patching the v4l tree, that can make 
> things much more complicated. BTW, your patch below is not the correct 
> fix.

That patch bellow is the diff between -hg tree and what we have at -git, after the
conflict solve. If it is wrong, it shows that the conflict were solved in a wrong
direction. Both your and Magnus patch touched at the same context lines of the
code, making the resolution not trivial.

If that patch is not correct, we need to apply it on our tree and write a patch
fixing it. The fix patch should be then added at another git push request.



Cheers,
Mauro
