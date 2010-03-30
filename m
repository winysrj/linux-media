Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:53697
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3K2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 06:28:11 -0400
From: Arnout Vandecappelle <arnout@mind.be>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen
Date: Tue, 30 Mar 2010 12:27:49 +0200
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
References: <1268866385-15692-1-git-send-email-arnout@mind.be> <1268866385-15692-2-git-send-email-arnout@mind.be> <4BA9A67A.3070004@maxwell.research.nokia.com>
In-Reply-To: <4BA9A67A.3070004@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301227.49671.arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Wednesday 24 March 2010 06:43:22, Sakari Ailus wrote:
> Hi Arnout,
> 
> Thanks for the patch.
> 
> Arnout Vandecappelle wrote:
[snip]
> > -	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->nr_pages, dma->direction); 
> > +	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->sglen, dma->direction);
> 
> I think the same problem still exists --- dma->sglen is not initialised
> anywhere, is it?

 Yes it is.
 In videobuf_dma_map (where dma->sglist is set), there are two conditions:

        if (dma->bus_addr) {
                dma->sglist = kmalloc(sizeof(struct scatterlist), GFP_KERNEL);
                if (NULL != dma->sglist) {
                        dma->sglen  = 1;
...
                }
        }
...
        if (!dma->bus_addr) {
                dma->sglen = dma_map_sg(q->dev, dma->sglist,
                                        dma->nr_pages, dma->direction);
...
        }


 Regards,
 Arnout
-- 
Arnout Vandecappelle                               arnout at mind be
Senior Embedded Software Architect                 +32-16-286540
Essensium/Mind                                     http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium                BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint:  31BB CF53 8660 6F88 345D  54CC A836 5879 20D7 CF43
