Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59765
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752315AbcKSMOY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 07:14:24 -0500
Date: Sat, 19 Nov 2016 10:14:14 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH 09/35] [media] cx88: make checkpatch happier
Message-ID: <20161119101414.6f90db46@vento.lan>
In-Reply-To: <20161118222532.GA19697@dell-m4800.home>
References: <cover.1479314177.git.mchehab@s-opensource.com>
        <d2948045c2dee0ea4b0e5f20fdd8facdd99e37a2.1479314177.git.mchehab@s-opensource.com>
        <20161118222532.GA19697@dell-m4800.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Nov 2016 22:25:32 +0000
Andrey Utkin <andrey_utkin@fastmail.com> escreveu:

> On Wed, Nov 16, 2016 at 02:42:41PM -0200, Mauro Carvalho Chehab wrote:
> > This driver is old, and have lots of checkpatch violations.
> > As we're touching a lot on this driver due to the printk
> > conversions, let's run checkpatch --fix on it, in order to
> > solve some of those issues. Also, let's remove the FSF
> > address and use the usual coding style for the initial comments.  
> 
> Good idea to give checkpatch a run.
> Good job by checkpatch, really powerful tool.
> 
> Have proofread, no weirdness except for few places where vertical
> "table-alike" alignment across lines got broken.
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> Reviewed-by: Andrey Utkin <andrey_utkin@fastmail.com>
> 
> > --- a/drivers/media/pci/cx88/cx88-cards.c
> > +++ b/drivers/media/pci/cx88/cx88-cards.c  
> 
> > @@ -2911,33 +2906,33 @@ static const struct {
> >  	int  fm;
> >  	const char *name;
> >  } gdi_tuner[] = {
> > -	[ 0x01 ] = { .id   = UNSET,
> > +	[0x01] = { .id   = UNSET,
> >  		     .name = "NTSC_M" },  
> 
> Alignment got broken
> 
> > --- a/drivers/media/pci/cx88/cx88-vbi.c
> > +++ b/drivers/media/pci/cx88/cx88-vbi.c  
> 
> > @@ -57,9 +57,9 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
> >  	cx88_sram_channel_setup(dev->core, &cx88_sram_channels[SRAM_CH24],
> >  				VBI_LINE_LENGTH, buf->risc.dma);
> >  
> > -	cx_write(MO_VBOS_CONTROL, ( (1 << 18) |  // comb filter delay fixup
> > +	cx_write(MO_VBOS_CONTROL, ((1 << 18) |  // comb filter delay fixup  
> 
> Alignment got broken.
> 
> > --- a/drivers/media/pci/cx88/cx88.h
> > +++ b/drivers/media/pci/cx88/cx88.h  
> 
> > @@ -385,8 +381,8 @@ struct cx88_core {
> >  	/* state info */
> >  	struct task_struct         *kthread;
> >  	v4l2_std_id                tvnorm;
> > -	unsigned		   width, height;
> > -	unsigned		   field;
> > +	unsigned int width, height;
> > +	unsigned int field;  
> 
> Alignment got broken
> 
> > @@ -591,23 +587,23 @@ struct cx8802_dev {
> >  /* ----------------------------------------------------------- */
> >  
> >  #define cx_read(reg)             readl(core->lmmio + ((reg)>>2))
> > -#define cx_write(reg,value)      writel((value), core->lmmio + ((reg)>>2))
> > -#define cx_writeb(reg,value)     writeb((value), core->bmmio + (reg))
> > +#define cx_write(reg, value)      writel((value), core->lmmio + ((reg)>>2))
> > +#define cx_writeb(reg, value)     writeb((value), core->bmmio + (reg))  
> 
> Alignment got broken
> 
> >  
> > -#define cx_andor(reg,mask,value) \
> > +#define cx_andor(reg, mask, value) \
> >    writel((readl(core->lmmio+((reg)>>2)) & ~(mask)) |\
> >    ((value) & (mask)), core->lmmio+((reg)>>2))
> > -#define cx_set(reg,bit)          cx_andor((reg),(bit),(bit))
> > -#define cx_clear(reg,bit)        cx_andor((reg),(bit),0)
> > +#define cx_set(reg, bit)          cx_andor((reg), (bit), (bit))
> > +#define cx_clear(reg, bit)        cx_andor((reg), (bit), 0)  
> 
> Alignment got broken

Thanks for the review. I wrote a fixup patch for this and the other
problems you mentioned on your second e-mail. Please review.


Thanks,
Mauro
