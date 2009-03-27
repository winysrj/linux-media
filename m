Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZC0KLy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 06:11:54 -0400
Date: Fri, 27 Mar 2009 07:11:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Alessio Igor Bogani <abogani@texware.it>,
	LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Subject: Re: [PATCH] radio-mr800.c: Missing mutex include
Message-ID: <20090327071143.59619399@pedra.chehab.org>
In-Reply-To: <1237326128.2141.17.camel@tux.localhost>
References: <1237323618-6464-1-git-send-email-abogani@texware.it>
	<1237326128.2141.17.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Mar 2009 00:42:08 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> On Tue, 2009-03-17 at 22:00 +0100, Alessio Igor Bogani wrote:
> > radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> > pulled in indirectly by one of the headers it already includes, the
> > right thing is to include it directly.
> 
> 
> Hello, Alessio
> 
> Patch looks okay for my eyes.
> If it useful it should be applied.
> 
> Thank you!
> 
> Mauro, if patch is okay please apply it.
> If you need my ack - here it is:
> Acked-by: Alexey Klimov <klimov.linux@gmail.com>

If the mutex.h were already included by another kernel header, I don't see why
to include it again. If a later patch remove the mutex.h from the header, then
the patch author should take care of this change anyway.

Cheers,
Mauro
