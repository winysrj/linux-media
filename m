Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:49189 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbcGMNTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:19:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: pochun lin <pochun.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-mediatek@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] mtk-vcodec: fix more type mismatches
Date: Wed, 13 Jul 2016 15:17:17 +0200
Message-ID: <9022784.B8ChAA686D@wuerfel>
In-Reply-To: <1468407163.3555.1.camel@mtksdaap41>
References: <20160713084916.2765651-1-arnd@arndb.de> <1468407163.3555.1.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, July 13, 2016 6:52:43 PM CEST pochun lin wrote:
> > diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > index f4e18bb44cb9..9a600525b3c1 100644
> > --- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > +++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > @@ -295,9 +295,9 @@ static int h264_enc_alloc_work_buf(struct venc_h264_inst *inst)
> >               wb[i].iova = inst->work_bufs[i].dma_addr;
> >  
> >               mtk_vcodec_debug(inst,
> > -                              "work_buf[%d] va=0x%p iova=0x%p size=%zu",
> > +                              "work_buf[%d] va=0x%p iova=%pad size=%zu",
> >                                i, inst->work_bufs[i].va,
> > -                              (void *)inst->work_bufs[i].dma_addr,
> > +                              &inst->work_bufs[i].dma_addr,
> >                                inst->work_bufs[i].size);
> >       }
> >  
> 
> This modified will dump dma_addr's address, not dma_addr value.
> In actually, we need to dump dma_addr value.

According to Documentation/printk-formats.txt, it gets passed by
reference:

| DMA addresses types dma_addr_t:
|
|        %pad    0x01234567 or 0x0123456789abcdef
|
|        For printing a dma_addr_t type which can vary based on build options,
|        regardless of the width of the CPU data path. Passed by reference.

The whole point of the %pad/%pr/%pM/... format strings is to print
something that cannot be passed by value because the type is not
a fixed-size integer.

	Arnd
