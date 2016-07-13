Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:22042 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037AbcGMNXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:23:20 -0400
Message-ID: <1468416155.20788.2.camel@mtksdaap41>
Subject: Re: [PATCH v2] [media] mtk-vcodec: fix more type mismatches
From: pochun lin <pochun.lin@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	<linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	<linux-mediatek@lists.infradead.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	<linux-media@vger.kernel.org>
Date: Wed, 13 Jul 2016 21:22:35 +0800
In-Reply-To: <9022784.B8ChAA686D@wuerfel>
References: <20160713084916.2765651-1-arnd@arndb.de>
	 <1468407163.3555.1.camel@mtksdaap41> <9022784.B8ChAA686D@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, 2016-07-13 at 15:17 +0200, Arnd Bergmann wrote:
> On Wednesday, July 13, 2016 6:52:43 PM CEST pochun lin wrote:
> > > diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > > index f4e18bb44cb9..9a600525b3c1 100644
> > > --- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > > +++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > > @@ -295,9 +295,9 @@ static int h264_enc_alloc_work_buf(struct venc_h264_inst *inst)
> > >               wb[i].iova = inst->work_bufs[i].dma_addr;
> > >  
> > >               mtk_vcodec_debug(inst,
> > > -                              "work_buf[%d] va=0x%p iova=0x%p size=%zu",
> > > +                              "work_buf[%d] va=0x%p iova=%pad size=%zu",
> > >                                i, inst->work_bufs[i].va,
> > > -                              (void *)inst->work_bufs[i].dma_addr,
> > > +                              &inst->work_bufs[i].dma_addr,
> > >                                inst->work_bufs[i].size);
> > >       }
> > >  
> > 
> > This modified will dump dma_addr's address, not dma_addr value.
> > In actually, we need to dump dma_addr value.
> 
> According to Documentation/printk-formats.txt, it gets passed by
> reference:
> 
> | DMA addresses types dma_addr_t:
> |
> |        %pad    0x01234567 or 0x0123456789abcdef
> |
> |        For printing a dma_addr_t type which can vary based on build options,
> |        regardless of the width of the CPU data path. Passed by reference.
> 
> The whole point of the %pad/%pr/%pM/... format strings is to print
> something that cannot be passed by value because the type is not
> a fixed-size integer.
> 
> 	Arnd

Got it. And sorry I was wrong.
Thanks your explain clearly.

Best Regards
PoChun

