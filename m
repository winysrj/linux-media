Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZDTRCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 13:02:25 -0400
Date: Mon, 20 Apr 2009 14:01:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [0904_1] Siano: core header - update license and
 include files
Message-ID: <20090420140145.2f92d380@pedra.chehab.org>
In-Reply-To: <51433.28968.qm@web110811.mail.gq1.yahoo.com>
References: <51433.28968.qm@web110811.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009 09:40:42 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> 
> 
> --- On Mon, 4/20/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > From: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Subject: Re: [PATCH] [0904_1] Siano: core header - update license and include files
> > To: "Uri Shkolnik" <urishk@yahoo.com>
> > Cc: linux-media@vger.kernel.org
> > Date: Monday, April 20, 2009, 5:42 PM
> > On Sun, 5 Apr 2009 01:09:16 -0700
> > (PDT)
> > Uri Shkolnik <urishk@yahoo.com>
> > wrote:
> > 
> > > 
> > > # HG changeset patch
> > > # User Uri Shkolnik <uris@siano-ms.com>
> > > # Date 1238689930 -10800
> > > # Node ID c3f0f50d46058f07fb355d8e5531f35cfd0ca37e
> > > # Parent 
> > 7311d23c3355629b617013cd51223895a2423770
> > > [PATCH] [0904_1] Siano: core header - update license
> > and included files
> > > 
> > > From: Uri Shkolnik <uris@siano-ms.com>
> > > 
> > > This patch does not include any implementation
> > changes.
> > > It update the smscoreapi.h license to be identical to
> > 
> > > other Siano's headers and the #include files list.
> > 
> > s/update/updates/
> > 
> > >  #include <linux/version.h>
> > >  #include <linux/device.h>
> > > @@ -28,15 +28,23 @@
> > >  #include <linux/mm.h>
> > >  #include <linux/scatterlist.h>
> > >  #include <linux/types.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/compat.h>
> > > +#include <linux/wait.h>
> > > +#include <linux/timer.h>
> > > +
> > >  #include <asm/page.h>
> > > -#include <linux/mutex.h>
> > > -#include "compat.h"
> > 
> > Hmm... Why do you need the above changes? Also, #include
> > "compat.h" is
> > required, in order to compile inside the out-of-tree kernel
> > tree.
> > 
> > Also, the header changes should be on a different
> > changeset, since they aren't
> > related to what's described, e. g. this has nothing to do
> > with licensing change.
> > 
> > 
> > Cheers,
> > Mauro
> > 
> 
> 1) "compat.h" became <linux/compat.h> as result of old ML review
> ---> +#include <linux/compat.h>

I have no idea when do you need to include linux/compat.h. However, as
compilation is currently fine, I see no reasons why to add it. I also don't
have any idea why do you need to add other include files, since it is properly
compiling without adding any other header.

In the case of "compat.h", this is local to the out-of-tree compilation, having
some needed defines to compile against older kernel versions. This header it is
automatically stripped from upstream changes. 

> 2) There were a mail exchanged, back in mid-summer 2008, regarding the license. One template has been approved both by Siano and the reviewers back then, and the patch comes the align this particular file with that old decision.  

This seems fine to my eyes.

> Regarding the change-set - since there were no implementation changes (only license text modification and re-arranging the include files list (I hadn't counted "compat.h" --> <linux/compat.h> as an implementation change) I decided to put them in one patch. If higher resolution is needed, I'll do so,

If all you're doing is rearranging, it would be fine to add it at the same
changeset, but you should explicitly mention this at the description.

Also, fyi, the proper include sequence is:

1) Include all kernel headers that aren't at -hg (no particular order here - I
generally use some alphabetic order, but this is just my personal preference);

2) #include "compat.h"

3) The other v4l/dvb core headers and local headers.

 Cheers,
Mauro
