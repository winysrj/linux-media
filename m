Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE91C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD62220849
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:07:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD62220849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbeLMNHb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:07:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:52632 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728875AbeLMNHb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:07:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 05:07:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,349,1539673200"; 
   d="scan'208";a="118505444"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 13 Dec 2018 05:07:26 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 51F36207AF; Thu, 13 Dec 2018 15:07:25 +0200 (EET)
Date:   Thu, 13 Dec 2018 15:07:25 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 2/3] videobuf2-dma-sg: Prevent size from overflowing
Message-ID: <20181213130725.x3jxsyrcge553evx@paasikivi.fi.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
 <4785676.KSXsKKKZGc@avalon>
 <20181213130023.zjklxfracxrlg7qp@paasikivi.fi.intel.com>
 <21457558.JR2c3sqZFE@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21457558.JR2c3sqZFE@avalon>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 03:03:47PM +0200, Laurent Pinchart wrote:
> On Thursday, 13 December 2018 15:00:23 EET Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > On Thu, Dec 13, 2018 at 02:57:46PM +0200, Laurent Pinchart wrote:
> > > Hi Sakari,
> > > 
> > > Thank you for the patch.
> > > 
> > > On Thursday, 13 December 2018 12:40:05 EET Sakari Ailus wrote:
> > > > buf->size is an unsigned long; casting that to int will lead to an
> > > > overflow if buf->size exceeds INT_MAX.
> > > > 
> > > > Fix this by changing the type to unsigned long instead. This is possible
> > > > as the buf->size is always aligned to PAGE_SIZE, and therefore the size
> > > > will never have values lesser than 0.
> > > 
> > > This feels a bit fragile to me. We at least need a big comment in the code
> > > to explain this. Another option would be a size -= min(..., size) just to
> > > make sure.
> > 
> > I was thinking of something like:
> > 
> > 	if (WARN_ON(size & ~PAGE_MASK))
> > 		return -ENOMEM;
> > 
> > But I opted to writing the third patch as this is not the only place where
> > the page alignment could be relevant.
> > 
> > What do you think?
> 
> I'd do both :-)

Then my next question is: as this is relevant elsewhere, too, where else
should I add a similar check?

This is just the SG DMA implementation...

> 
> > > > Note on backporting to stable: the file used to be under
> > > > drivers/media/v4l2-core, it was moved to the current location after
> > > > 4.14.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > > 
> > > >  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > > b/drivers/media/common/videobuf2/videobuf2-dma-sg.c index
> > > > 015e737095cdd..e9bfea986cc47 100644
> > > > --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > > +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > > @@ -59,7 +59,7 @@ static int vb2_dma_sg_alloc_compacted(struct
> > > > vb2_dma_sg_buf *buf, gfp_t gfp_flags)
> > > > 
> > > >  {
> > > >  
> > > >  	unsigned int last_page = 0;
> > > > 
> > > > -	int size = buf->size;
> > > > +	unsigned long size = buf->size;
> > > > 
> > > >  	while (size > 0) {
> > > >  	
> > > >  		struct page *pages;
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
