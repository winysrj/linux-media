Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:23954 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932238AbeDKTRw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 15:17:52 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23246.24049.973442.655668@morden.metzler>
Date: Wed, 11 Apr 2018 21:11:45 +0200
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: ddbridge: better handle optional spin locks at
 the code
In-Reply-To: <20180411133302.4382174d@vento.lan>
References: <5156a3b987ae3698ff4c650a6395997f93ba093e.1523448215.git.mchehab@s-opensource.com>
        <20180411180315.74c3a1bd@perian.wuest.de>
        <20180411133302.4382174d@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab writes:
 > Em Wed, 11 Apr 2018 18:03:15 +0200
 > Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
 > 
 > > Am Wed, 11 Apr 2018 08:03:37 -0400
 > > schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
 > > 
 > > > Currently, ddbridge produces 4 warnings on sparse:
 > > > 	drivers/media/pci/ddbridge/ddbridge-core.c:495:9: warning: context imbalance in 'ddb_output_start' - different lock contexts for basic block
 > > > 	drivers/media/pci/ddbridge/ddbridge-core.c:510:9: warning: context imbalance in 'ddb_output_stop' - different lock contexts for basic block
 > > > 	drivers/media/pci/ddbridge/ddbridge-core.c:525:9: warning: context imbalance in 'ddb_input_stop' - different lock contexts for basic block
 > > > 	drivers/media/pci/ddbridge/ddbridge-core.c:560:9: warning: context imbalance in 'ddb_input_start' - different lock contexts for basic block
 > > > 
 > > > Those are all false positives, but they result from the fact that
 > > > there could potentially have some troubles at the locking schema,
 > > > because the lock depends on a var (output->dma).
 > > > 

Yeah, there were false positives on other parts of the driver where it was obvious to anybody
that the bad case cannot happen ...


 > > > I discussed that in priv with Sparse author and with the current
 > > > maintainer. Both believe that sparse is doing the right thing, and
 > > > that the proper fix would be to change the code to make it clearer
 > > > that, when spin_lock_irq() is called, spin_unlock_irq() will be
 > > > also called.
 > > > 
 > > > That help not only static analyzers to better understand the code,
 > > > but also humans that could need to take a look at the code.
 > > > 
 > > > It was also pointed that gcc would likely be smart enough to
 > > > optimize the code and produce the same result. I double
 > > > checked: indeed, the size of the driver didn't change after
 > > > this patch.
 > > > 
 > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
 > > > ---
 > > >  drivers/media/pci/ddbridge/ddbridge-core.c | 43 ++++++++++++++++++++----------
 > > >  1 file changed, 29 insertions(+), 14 deletions(-)
 > > > 
 > > > diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
 > > > index 4a2819d3e225..080e2189ca7f 100644
 > > > --- a/drivers/media/pci/ddbridge/ddbridge-core.c
 > > > +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
 > > > @@ -458,13 +458,12 @@ static void calc_con(struct ddb_output *output, u32 *con, u32 *con2, u32 flags)
 > > >  	*con2 = (nco << 16) | gap;
 > > >  }
 > > >  
 > > > -static void ddb_output_start(struct ddb_output *output)
 > > > +static void __ddb_output_start(struct ddb_output *output)
 > > >  {
 > > >  	struct ddb *dev = output->port->dev;
 > > >  	u32 con = 0x11c, con2 = 0;
 > > >  
 > > >  	if (output->dma) {
 > > > -		spin_lock_irq(&output->dma->lock);
 > > >  		output->dma->cbuf = 0;
 > > >  		output->dma->coff = 0;
 > > >  		output->dma->stat = 0;
 > > > @@ -492,9 +491,18 @@ static void ddb_output_start(struct ddb_output *output)
 > > >  
 > > >  	ddbwritel(dev, con | 1, TS_CONTROL(output));
 > > >  
 > > > -	if (output->dma) {
 > > > +	if (output->dma)
 > > >  		output->dma->running = 1;
 > > > +}
 > > > +
 > > > +static void ddb_output_start(struct ddb_output *output)
 > > > +{
 > > > +	if (output->dma) {
 > > > +		spin_lock_irq(&output->dma->lock);
 > > > +		__ddb_output_start(output);
 > > >  		spin_unlock_irq(&output->dma->lock);
 > > > +	} else {
 > > > +		__ddb_output_start(output);
 > > >  	}
 > > >  }  

What does it say if you do:

struct ddb_dma *dma = output->dma;

if (dma) 
     lock;

...

if (dma)
     unlock;

?

If that does not work, what if you make dma const?

 > > 
 > > This makes things look rather strange (at least to my eyes), especially
 > > when simply trying to satisfy automated checkers, which in this case is
 > > useless since both lock and unlock will always happen based on the same
 > > condition ([input|output]->dma != NULL). Though I agree having the
 > > locking inside a condition in it's current form isn't optimal, too, and
 > > I also already thought about this in the past.
 > > 
 > > I'd rather try to fix this by checking for the dma ptrs at the
 > > beginning of the four functions and immediately return if the ptr is
 > > invalid. Though I don't know if this may cause side effects as there's
 > > data written to the regs pointed by the TS_CONTROL() macros even if
 > > there's no dma ptr present.

TS_CONTROL only controls the output itself and does not need to have DMA.


 > > 
 > > I'd like to hear Ralph's opinion on this, and also like to have this
 > > changed (in whatever way) in the upstream (dddvb) repository, too.
 > > 
 > > Please refrain from applying this patch until we agreed on a proper
 > > solution that works for everyone.
 > 
 > Yeah, sure. 
 > 
 > Btw, does ddbridge driver works without DMA? On a quick look, it
 > seems that it is enabled all the times.
 > 

DMA is not used with the OctopusNet and only partially on the OctopusNetPro.
Both are ARM based network streaming devices.

The OctopusNet has no DMA at all and can only stream directly to CI or network.
The Pro version has DMA and will support streaming and/or DMA on the each 
channel. DMA channel assignment was at one point planned to be done dynamically.
It also is PCIe based. So, this is part of ddbridge-main.c and not octonet-main.c.

But support for those devices and some PCIe cards is not part of the kernel driver
anyway. So, you could of course through all of this DMA checking out of the
kernel version. It might have to be added back in for future/other cards. But that
problems already exists with other features.


Regards,
Ralph
