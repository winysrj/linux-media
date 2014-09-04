Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:44355 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaIDPFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 11:05:46 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBD00BMETXLNUA0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Sep 2014 11:05:45 -0400 (EDT)
Date: Thu, 04 Sep 2014 12:05:40 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/3] [media] tw68: Remove a sparse warning
Message-id: <20140904120540.44e000e7.m.chehab@samsung.com>
In-reply-to: <54087D2E.806@cisco.com>
References: <ce9e1ac1b9becb9481f8492d9ccf713398a07ef8.1409841955.git.m.chehab@samsung.com>
 <fafeea3682cc2da98f05138ec4b1c8ebc6798b5d.1409841955.git.m.chehab@samsung.com>
 <54087D2E.806@cisco.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Sep 2014 16:54:38 +0200
Hans Verkuil <hansverk@cisco.com> escreveu:

> I'll need to review this as well. Perhaps tw_writel should expect a __le32?

There are several other parts where it is using the address as CPU endian.

Anyway, if you have some BE system, then you can test the board there and
see what would work.

Regards,
Mauro

> 
> 	Hans
> 
> On 09/04/14 16:46, Mauro Carvalho Chehab wrote:
> > drivers/media/pci/tw68/tw68-video.c:351:9: warning: incorrect type in argument 1 (different base types)
> > drivers/media/pci/tw68/tw68-video.c:351:9:    expected unsigned int [unsigned] val
> > drivers/media/pci/tw68/tw68-video.c:351:9:    got restricted __le32 [usertype] <noident>
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > 
> > diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
> > index 66fae2345fdd..4dd38578cf1b 100644
> > --- a/drivers/media/pci/tw68/tw68-video.c
> > +++ b/drivers/media/pci/tw68/tw68-video.c
> > @@ -348,7 +348,7 @@ int tw68_video_start_dma(struct tw68_dev *dev, struct tw68_buf *buf)
> >  	 *  a new address can be set.
> >  	 */
> >  	tw_clearl(TW68_DMAC, TW68_DMAP_EN);
> > -	tw_writel(TW68_DMAP_SA, cpu_to_le32(buf->dma));
> > +	tw_writel(TW68_DMAP_SA, (__force u32)cpu_to_le32(buf->dma));
> >  	/* Clear any pending interrupts */
> >  	tw_writel(TW68_INTSTAT, dev->board_virqmask);
> >  	/* Enable the risc engine and the fifo */
> > 
