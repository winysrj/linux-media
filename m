Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37234 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaIWStF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 14:49:05 -0400
Date: Tue, 23 Sep 2014 15:48:59 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] [media] saa7134: Remove some casting warnings
Message-ID: <20140923154859.6dc959f3@recife.lan>
In-Reply-To: <542154C7.1090802@xs4all.nl>
References: <37b38486a1497804b63482af58a945f0eee8893f.1411469967.git.mchehab@osg.samsung.com>
	<542154C7.1090802@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Sep 2014 13:08:55 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/23/14 12:59, Mauro Carvalho Chehab wrote:
> > drivers/media/pci/saa7134/saa7134-go7007.c:247:17: warning: incorrect type in argument 1 (different base types)
> > drivers/media/pci/saa7134/saa7134-go7007.c:247:17:    expected unsigned int [unsigned] val
> > drivers/media/pci/saa7134/saa7134-go7007.c:247:17:    got restricted __le32 [usertype] <noident>
> > drivers/media/pci/saa7134/saa7134-go7007.c:252:17: warning: incorrect type in argument 1 (different base types)
> > drivers/media/pci/saa7134/saa7134-go7007.c:252:17:    expected unsigned int [unsigned] val
> > drivers/media/pci/saa7134/saa7134-go7007.c:252:17:    got restricted __le32 [usertype] <noident>
> > drivers/media/pci/saa7134/saa7134-go7007.c:299:9: warning: incorrect type in argument 1 (different base types)
> > drivers/media/pci/saa7134/saa7134-go7007.c:299:9:    expected unsigned int [unsigned] val
> > drivers/media/pci/saa7134/saa7134-go7007.c:299:9:    got restricted __le32 [usertype] <noident>
> > drivers/media/pci/saa7134/saa7134-go7007.c:300:9: warning: incorrect type in argument 1 (different base types)
> > drivers/media/pci/saa7134/saa7134-go7007.c:300:9:    expected unsigned int [unsigned] val
> > drivers/media/pci/saa7134/saa7134-go7007.c:300:9:    got restricted __le32 [usertype] <noident>
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> > 
> > diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
> > index 3e9ca4821b8c..d9af6f3dc8af 100644
> > --- a/drivers/media/pci/saa7134/saa7134-go7007.c
> > +++ b/drivers/media/pci/saa7134/saa7134-go7007.c
> > @@ -244,12 +244,12 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
> >  		dma_sync_single_for_cpu(&dev->pci->dev,
> >  					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
> >  		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
> > -		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
> > +		saa_writel(SAA7134_RS_BA2(5), (__force u32)cpu_to_le32(saa->bottom_dma));
> 
> saa_writel is a define for writel, which already does cpu_to_le32. So the correct
> solution is to drop the cpu_to_le32 entirely.
> 
> I should have seen that.
> 
> Will you update your patch or shall I repost my patch with this fix included?

I'll update it.

Thanks,
Mauro
