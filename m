Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35112 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbcAMBga (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 20:36:30 -0500
Date: Tue, 12 Jan 2016 23:36:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.5-rc1] media controller next gen patch series
Message-ID: <20160112233623.7053f4bc@recife.lan>
In-Reply-To: <20160113080716.6b38f2f3@canb.auug.org.au>
References: <20160112084328.2194ec49@recife.lan>
	<20160113075431.711be9e0@canb.auug.org.au>
	<CA+55aFwWe7mcpQUBqX==REiwaeA4TEN7jX5kXrYvjwuuiP5wEQ@mail.gmail.com>
	<20160113080716.6b38f2f3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 13 Jan 2016 08:07:16 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Linus,
> 
> On Tue, 12 Jan 2016 12:58:45 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > On Tue, Jan 12, 2016 at 12:54 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:  
> > >
> > > This contains 117 commits (of 381) that only turned up in linux-next
> > > yesterday, but I see that Linus has already merged it.    

The patches were actually merged earlier at -next, but it was rebased in
order to merge some patches that would otherwise cause compilation
breakages if MEDIA_CONTROLLER is not defined, as requested:
	https://lkml.org/lkml/2015/12/22/660

The version that was previously at next (next-20151223) is this one:

commit f9139b43c2ee637b0ec9258716d221abdf94ffeb
Merge: abb5032f9258 40e950dbb6a3
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Fri Dec 18 15:35:01 2015 -0200

    Merge branch 'devel/media-controller-rc4' into to_next

Regards,
Mauro
