Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45749 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbcKSV3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 16:29:16 -0500
Date: Sat, 19 Nov 2016 19:29:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH] [media] cx88: make checkpatch.pl happy
Message-ID: <20161119192910.51183aa5@vento.lan>
In-Reply-To: <20161119191839.36a22f2c@vento.lan>
References: <8729e94b8ef1fd4a17631d6a0c81b8a10b7d3a54.1479557581.git.mchehab@s-opensource.com>
        <20161119195850.GA11418@dell-m4800.home>
        <20161119191839.36a22f2c@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 19 Nov 2016 19:18:39 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Sat, 19 Nov 2016 19:58:50 +0000
> Andrey Utkin <andrey_utkin@fastmail.com> escreveu:
> 
> > This is from checkpatch run on cx88 source files with "-f", not your
> > patch files, right? I guess it might produce less changes if run on
> > patches.  
> 
> Yes, I know.
> 
> > On Sat, Nov 19, 2016 at 10:14:05AM -0200, Mauro Carvalho Chehab wrote:  
> > > Usually, I don't like fixing coding style issues on non-staging
> > > drivers, as it could be a mess pretty easy, and could become like
> > > a snow ball. That's the case of recent changes on two changesets:
> > > they disalign some statements.    
> > 
> > In my understanding, commits dedicated to style fixes on non-staging are
> > discouraged because they clutter git log and "git blame" view. But new
> > commits are encouraged to be style-perfect.  
> 
> Yes, that's the usual policy. The main reason is not due to git log:
> when you do lots of changes on a file, the maintainer's live become
> very hard, as he needs to fix conflicts of patches affecting the file,
> or ask everybody to rebase their patches.
> 
> However, when we do large reformats for some other reason, though,
> it sometimes makes sense to take the opportunity and fix the style
> on the file, as bisect, blame and patch handling will be affected
> anyway.
> 
> > 
> > And in case of discussed alignment breakage, I expected that you make
> > this your fixup (the current patch) really a git-ish fixup and just
> > merge it into 09/35 patch.  
> 
> Too late for that, as your review came after applying the patch
> reached media upstream. I don't rebase the main media development
> tree (except when something really bad happened at the tree, and
> if I notice a few minutes after pushing something).
> 
> > As I see it's published in media tree master
> > already and you are not going to force-push there; maybe a bit of
> > latency in pushing patches to media tree after publishing them for
> > review would prevent this sort of inconvenience.  
> 
> I usually wait for some time before applying upstream. The time
> I wait is based on my own good sense if either people will comment
> the patch or silently ignore.
> 
> > 
> > P. S. (Running away from rotten tomatoes) another way to avoid such
> > painful alignment issues is to legalize "one-more-tab" indentation for
> > trailing parts of lines, alignment on opening brace is brittle IMHO.
> > 
> >   
> > > --- a/drivers/media/pci/cx88/cx88-blackbird.c
> > > +++ b/drivers/media/pci/cx88/cx88-blackbird.c    
> >   
> > > @@ -1061,7 +1092,8 @@ static int cx8802_blackbird_advise_acquire(struct cx8802_driver *drv)
> > >  
> > >  	switch (core->boardnr) {
> > >  	case CX88_BOARD_HAUPPAUGE_HVR1300:
> > > -		/* By default, core setup will leave the cx22702 out of reset, on the bus.
> > > +		/* By default, core setup will leave the cx22702 out of reset,
> > > +		 * on the bus.
> > >  		 * We left the hardware on power up with the cx22702 active.
> > >  		 * We're being given access to re-arrange the GPIOs.
> > >  		 * Take the bus off the cx22702 and put the cx23416 on it.    
> > 
> > Let first line with "/*" be empty :)
> >   
> > > --- a/drivers/media/pci/cx88/cx88-core.c
> > > +++ b/drivers/media/pci/cx88/cx88-core.c    
> >   
> > > @@ -102,28 +104,29 @@ static __le32 *cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
> > >  			sol = RISC_SOL | RISC_IRQ1 | RISC_CNT_INC;
> > >  		else
> > >  			sol = RISC_SOL;
> > > -		if (bpl <= sg_dma_len(sg)-offset) {
> > > +		if (bpl <= sg_dma_len(sg) - offset) {
> > >  			/* fits into current chunk */
> > > -			*(rp++) = cpu_to_le32(RISC_WRITE|sol|RISC_EOL|bpl);
> > > -			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
> > > +			*(rp++) = cpu_to_le32(RISC_WRITE | sol |
> > > +					      RISC_EOL | bpl);
> > > +			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
> > >  			offset += bpl;
> > >  		} else {
> > >  			/* scanline needs to be split */
> > >  			todo = bpl;
> > > -			*(rp++) = cpu_to_le32(RISC_WRITE|sol|
> > > -					    (sg_dma_len(sg)-offset));
> > > -			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
> > > -			todo -= (sg_dma_len(sg)-offset);
> > > +			*(rp++) = cpu_to_le32(RISC_WRITE | sol |
> > > +					    (sg_dma_len(sg) - offset));    
> > 
> > This is strange, but checkpatch --strict is really happy on this,
> > however there is a misalignment in added lines. Going to look into this
> > later.
> >   
> > > --- a/drivers/media/pci/cx88/cx88-input.c
> > > +++ b/drivers/media/pci/cx88/cx88-input.c
> > > @@ -62,11 +62,15 @@ static int ir_debug;
> > >  module_param(ir_debug, int, 0644);	/* debug level [IR] */
> > >  MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
> > >  
> > > -#define ir_dprintk(fmt, arg...)	if (ir_debug) \
> > > -	printk(KERN_DEBUG "%s IR: " fmt, ir->core->name, ##arg)
> > > +#define ir_dprintk(fmt, arg...)	do {					\    
> > 
> > Backslash stands out.  
> 
> Sorry, but I didn't understand what you're meaning here.
> 
> ...
> > Everything else seems fine.  
> 
> The other comments are OK. I'm sending a version 2 of this patch.
> To make easier to review, I'm enclosing the diff against version 1
> here.

I actually added two more hunks, removing FSF address and converting
the initial comment to the new format.

Thanks,
Mauro
