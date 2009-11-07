Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZKGOtW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 09:49:22 -0500
Date: Sat, 7 Nov 2009 12:49:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: e9hack <e9hack@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: bug in changeset 13239:54535665f94b ?
Message-ID: <20091107124922.7fbf8445@pedra.chehab.org>
In-Reply-To: <4AF57E8E.5070109@googlemail.com>
References: <4AEDB05E.1090704@googlemail.com>
	<20091107104113.0df4593b@pedra.chehab.org>
	<4AF57E8E.5070109@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 07 Nov 2009 15:05:02 +0100
e9hack <e9hack@googlemail.com> escreveu:

> Mauro Carvalho Chehab schrieb:
> 
> > I agree. We need first to stop DMA activity, and then release the page tables.
> > 
> > Could you please test if the enclosed patch fixes the issue?
> 
> Hi Mauro,
> 
> your patch doesn't solve the problem, because saa7146_dma_free() doesn't stop a running
> dma transfer of the saa7146.

Well, it should be stopping it. The logic is to wait for an incoming dma
transfer and then disable dma transfers:

void saa7146_dma_free(struct saa7146_dev *dev,struct videobuf_queue *q,
                                                struct saa7146_buf *buf)
{
        struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
        DEB_EE(("dev:%p, buf:%p\n",dev,buf));

        BUG_ON(in_interrupt());

        videobuf_waiton(&buf->vb,0,0);
        videobuf_dma_unmap(q, dma);
        videobuf_dma_free(dma);
        buf->vb.state = VIDEOBUF_NEEDS_INIT;
}

Maybe the code for dma_unmap is incomplete?

> Since last weekend, I'm using the attached patch. I'm not
> sure, if the functionality of video_end() must be split. Maybe the last part of
> video_end() must be execute at the end of vidioc_streamoff().

It is not safe to stop at streamoff(), since applications may close the device
without calling streamoff. The kernel driver should be able to handle such
situations as well.

So, if my patch doesn't work, we'll need to add more bits at saa7146_dma_free().

-- 

Cheers,
Mauro
