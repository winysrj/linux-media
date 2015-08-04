Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbbHDVYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 17:24:05 -0400
Date: Tue, 4 Aug 2015 14:24:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jens Axboe <axboe@kernel.dk>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2] lib: scatterlist: add sg splitting function
Message-Id: <20150804142403.ce26115ca8da96135e8973f5@linux-foundation.org>
In-Reply-To: <878u9rm1cr.fsf@belgarion.home>
References: <1438435033-7636-1-git-send-email-robert.jarzmik@free.fr>
	<20150803161939.2edd494eb64bc81ea8e91c16@linux-foundation.org>
	<878u9rm1cr.fsf@belgarion.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 04 Aug 2015 19:04:36 +0200 Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> >>  include/linux/scatterlist.h |   5 ++
> >>  lib/scatterlist.c           | 189 ++++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 194 insertions(+)
> >
> > It's quite a bit of code for a fairly specialised thing.  How ugly
> > would it be to put this in a new .c file and have subsystems select it
> > in Kconfig?
> I have no idea about the "ugliness", but why not ...
> 
> If nobody objects, and in order to submit a proper patch, there are decisions to
> make :
>  - what will be the scope of this new .c file ?
>    - only sg_plit() ?
>    - all sg specialized functions, ie. sg_lib.c ?

Just sg_split I'd say.  It's a logical unit.  Other things can be moved
elsewhere later as cleanups/optimisations, but that's all off-topic.

>  - will include/linux/scatterlist.h have an "ifdefed" portion for what X.c
>    offers ?

I prefer to avoid the ifdefs.  This means that the error is reported at
link-time rather than compile-time but that's a pretty small cost and
it's a once-off inconvenience, whereas messy/complex header files are
permanent.

>  - what naming for X.c and the config entry ?

um, CONFIG_SG_SPLIT and sg_split.c?

> What about adding this to lib/Makefile, and one ifdef to scatterlist.h ? :
>      obj-$(CONFIG_SG_LIB) += sg_lib.o

It would be obj-$(CONFIG_SG_SPLIT) += sg_split.o
