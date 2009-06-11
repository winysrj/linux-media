Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZFKAgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 20:36:05 -0400
Date: Wed, 10 Jun 2009 21:36:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	linux-media@vger.kernel.org, abogani@texware.it
Subject: Re: [patch 1/6] radio-mr800.c: missing mutex include
Message-ID: <20090610213600.09d592cd@pedra.chehab.org>
In-Reply-To: <20090610162344.3f29de3c.akpm@linux-foundation.org>
References: <200906101944.n5AJiIKQ031735@imap1.linux-foundation.org>
	<208cbae30906101621v6ba12fbbsf29c0d6ec35768d8@mail.gmail.com>
	<20090610162344.3f29de3c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Jun 2009 16:23:44 -0700
Andrew Morton <akpm@linux-foundation.org> escreveu:

> On Thu, 11 Jun 2009 03:21:36 +0400 Alexey Klimov <klimov.linux@gmail.com> wrote:
> 
> > On Wed, Jun 10, 2009 at 11:44 PM, <akpm@linux-foundation.org> wrote:
> > > From: Alessio Igor Bogani <abogani@texware.it>
> > >
> > > radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> > > pulled in indirectly by one of the headers it already includes, the right
> > > thing is to include it directly.
> > 
> > It was already applied to v4l-dvb tree (and probably to v4l git tree).
> 
> It isn't in today's linux-next.

Hi Andrew,

Thanks for remind us about those 6 patches. I'll double check if those are
already on my staging tree. If they aren't I'll apply or comment.

Since I'm currently in the proccess updating my trees, I should be adding 
several pending patches on my -git tree, probably in time for tomorrow's
linux-next tree.



Cheers,
Mauro
