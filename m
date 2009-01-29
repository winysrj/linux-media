Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbZA2KKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 05:10:36 -0500
Date: Thu, 29 Jan 2009 08:10:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: morimoto.kuninori@renesas.com,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
Message-ID: <20090129081002.793e2341@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0901291057470.5474@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0901250245440.4969@axis700.grange>
	<uzlheep1l.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0901260854010.4236@axis700.grange>
	<uk58hcp3k.wl%morimoto.kuninori@renesas.com>
	<alpine.DEB.2.00.0901270851280.4618@axis700.grange>
	<20090129075127.6dd3340c@caramujo.chehab.org>
	<Pine.LNX.4.64.0901291057470.5474@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009 11:00:41 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:
> 
> > On Tue, 27 Jan 2009 08:53:23 +0100 (CET)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > 
> > Hi Guennadi,
> > 
> > I'm understanding that you're reviewing this patch and other ones for
> > soc_camera and will send me a PULL request after reviewing those stuff.
> 
> Yes, I'm (going to be) reviewing them, as soon as I find some time. Then 
> I'll send you two pull requests - fixes for 2.6.29 and 2.6.30 material. 
> AFAIK, unfortunately, mercurial doesn't support branches, so, I probably 
> will end up first sending you a pull request with fixes, and after some 
> time I'll also add 2.6.30 further development to the same tree and send 
> another pull request. No idea what I do, if after that more 2.6.29 fixes 
> come...

Yes, this is another drawback of hg. For fixes, please add: 
	Priority: high

At the body of the description. My scripts will understand this as fix patches.

Cheers,
Mauro
