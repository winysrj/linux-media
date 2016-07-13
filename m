Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:43339 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbcGMN4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:56:16 -0400
Message-ID: <1468418121.32454.19.camel@mtksdaap41>
Subject: Re: [PATCH] [media] mtk-vcodec: fix type mismatches
From: tiffany lin <tiffany.lin@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>,
	"Hans Verkuil" <hans.verkuil@cisco.com>,
	PoChun Lin <pochun.lin@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	<linux-mediatek@lists.infradead.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	<linux-media@vger.kernel.org>
Date: Wed, 13 Jul 2016 21:55:21 +0800
In-Reply-To: <4915511.9pXBipIRF8@wuerfel>
References: <20160711213959.2481081-1-arnd@arndb.de>
	 <1468403786.32454.16.camel@mtksdaap41> <4915511.9pXBipIRF8@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, 2016-07-13 at 15:08 +0200, Arnd Bergmann wrote:
> On Wednesday, July 13, 2016 5:56:26 PM CEST tiffany lin wrote:
> > > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > > index 6dcae0a0a1f2..0b25a8700877 100644
> > > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > > @@ -1028,15 +1028,15 @@ static void mtk_venc_worker(struct work_struct *work)
> > >       bs_buf.size = (size_t)dst_buf->planes[0].length;
> > >  
> > >       mtk_v4l2_debug(2,
> > > -                     "Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=%zu",
> > > +                     "Framebuf VA=%p PA=%pad Size=0x%zx;VA=%p PA=%pad Size=0x%zx;VA=%p PA=%pad Size=0x%zx",
> > >                       frm_buf.fb_addr[0].va,
> > > -                     (u64)frm_buf.fb_addr[0].dma_addr,
> > > +                     &frm_buf.fb_addr[0].dma_addr,
> > >                       frm_buf.fb_addr[0].size,
> > >                       frm_buf.fb_addr[1].va,
> > > -                     (u64)frm_buf.fb_addr[1].dma_addr,
> > > +                     &frm_buf.fb_addr[1].dma_addr,
> > >                       frm_buf.fb_addr[1].size,
> > >                       frm_buf.fb_addr[2].va,
> > > -                     (u64)frm_buf.fb_addr[2].dma_addr,
> > > +                     &frm_buf.fb_addr[2].dma_addr,
> > >                       frm_buf.fb_addr[2].size);
> > This change will make debug message dump address of dma_addr field but
> > not the value of the dma_addr we want.
> > How about change it from
> > PA=%llx -> PA=%u
> > (u64)frm_buf.fb_addr[0].dma_addr -> (u32)frm_buf.fb_addr[0].dma_addr,
> > 
> 
> The %llx works fine with the cast to u64, the change above is mainly for the "%lx"
> on a size_t causing a warning.
> 
> The change to %pad is done in order to use a consistent output for the
> dma_addr_t, which had a leading "0x" in two cases but not in the first
> one.
> 
> printk interprets %pad as a pointer to a dma_addr_t and prints the
> address, not the pointer to it, see Documentation/printk-formats.txt,
> which lets you avoid the type cast as well as the 0x.
> 
I understood now, I will check Documentation/printk-formats.txt.
Thanks for your explanation.


best regards,
Tiffany

> 	Arnd


