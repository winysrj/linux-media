Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZELVfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:35:16 -0400
Date: Tue, 12 May 2009 18:35:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: akpm@linux-foundation.org, linux-media@vger.kernel.org,
	roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@redhat.com
Subject: Re: [patch 4/4] zoran: fix &&/|| error
Message-ID: <20090512183507.5967f336@pedra.chehab.org>
In-Reply-To: <829197380905121418o5e86d474n3ef38e91850ff818@mail.gmail.com>
References: <200905122058.n4CKwj2I004399@imap1.linux-foundation.org>
	<829197380905121418o5e86d474n3ef38e91850ff818@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 May 2009 17:18:20 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Tue, May 12, 2009 at 4:39 PM,  <akpm@linux-foundation.org> wrote:
> > From: Roel Kluin <roel.kluin@gmail.com>
> >
> > Fix &&/|| typo. `default_norm' can be 0 (PAL), 1 (NTSC) or 2 (SECAM),
> > the condition tested was impossible.
> >
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> 
> Hello,
> 
> Was the patch actually tested against the hardware in question?  While
> I agree that it looks ok, it can result in the default logic being
> inverted in some cases, which could expose other bugs and result in a
> regression.
> 
> I just want to be confident that this patch was tested by somebody
> with the hardware and it isn't going into the codebase because "it
> obviously cannot be right".

Hans and Jean worked on it. Both are at PAL area, so they won't notice such
error without a standards generator, since the default is to assume that the
signal is PAL.

With this patch, PAL should keep working, but I can't see how NTSC or SECAM
would work without it.

Anyway, this patch were already committed on our tree, and it is on my
linux-next tree since yesterday night.

Hans,

Could you please confirm that the patch is ok with your standards generator?



Cheers,
Mauro
