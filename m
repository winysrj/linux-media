Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZAWRH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 12:07:59 -0500
Date: Fri, 23 Jan 2009 15:07:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [hg:v4l-dvb] Merge from master v4l-dvb repo
Message-ID: <20090123150728.45d8a486@caramujo.chehab.org>
In-Reply-To: <1232729949.3907.5.camel@palomino.walls.org>
References: <E1LQ7g8-00078n-SU@www.linuxtv.org>
	<1232729949.3907.5.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Jan 2009 11:59:09 -0500
Andy Walls <awalls@radix.net> wrote:

> On Thu, 2009-01-22 at 23:05 +0100, Patch added by Andy Walls wrote:
> > The patch number 10282 was added via Andy Walls <awalls@radix.net>
> > to http://linuxtv.org/hg/v4l-dvb master development tree.
> > 
> > Kernel patches in this development tree may be modified to be backward
> > compatible with older kernels. Compatibility modifications will be
> > removed before inclusion into the mainstream Kernel
> > 
> > If anyone has any objections, please let us know by sending a message to:
> > 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> No objection per se, just a concern:
> 
> This was a "make pull" I unwittingly did on my ~awalls/v4l-dvb repo that
> I mentioned.  Hopefully hg is smart enough not to have this merge back
> to the main v4l-dvb repo and cause unintentional reverts.
> 

Mercurial will add your merges on its story. The only drawback is to have
mercurial history more dirty.

> ------
> 
> Merge from master v4l-dvb repo
> 
> 
Instead, please use:
merge: <some description>

Since my scripts get the string "merge:" on the subject to discard the patches
when porting to -git tree.


Cheers,
Mauro
