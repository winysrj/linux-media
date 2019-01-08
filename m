Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6B2C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2E6D21019
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfAHN5c (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:57:32 -0500
Received: from mga05.intel.com ([192.55.52.43]:43548 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbfAHN5b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 08:57:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2019 05:57:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,454,1539673200"; 
   d="scan'208";a="136386217"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 08 Jan 2019 05:57:30 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 3FCE620948; Tue,  8 Jan 2019 15:57:29 +0200 (EET)
Date:   Tue, 8 Jan 2019 15:57:29 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 2/3] videobuf2-dma-sg: Prevent size from overflowing
Message-ID: <20190108135728.gkvojslvuyqrpitn@paasikivi.fi.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
 <20190108085836.9376-3-sakari.ailus@linux.intel.com>
 <20190108110942.7a58d455@coco.lan>
 <20190108132926.fk4rz3tfw6gjuhx7@paasikivi.fi.intel.com>
 <20190108114401.10f09372@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108114401.10f09372@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 08, 2019 at 11:44:01AM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 8 Jan 2019 15:29:26 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > On Tue, Jan 08, 2019 at 11:09:42AM -0200, Mauro Carvalho Chehab wrote:
> > > Em Tue,  8 Jan 2019 10:58:35 +0200
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > >   
> > > > buf->size is an unsigned long; casting that to int will lead to an
> > > > overflow if buf->size exceeds INT_MAX.
> > > > 
> > > > Fix this by changing the type to unsigned long instead. This is possible
> > > > as the buf->size is always aligned to PAGE_SIZE, and therefore the size
> > > > will never have values lesser than 0.
> > > > 
> > > > Note on backporting to stable: the file used to be under
> > > > drivers/media/v4l2-core, it was moved to the current location after 4.14.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: stable@vger.kernel.org
> > > > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > ---
> > > >  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > > index 015e737095cd..5fdb8d7051f6 100644
> > > > --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > > +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > > @@ -59,7 +59,10 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
> > > >  		gfp_t gfp_flags)
> > > >  {
> > > >  	unsigned int last_page = 0;
> > > > -	int size = buf->size;
> > > > +	unsigned long size = buf->size;  
> > > 
> > > OK.
> > >   
> > > > +
> > > > +	if (WARN_ON(size & ~PAGE_MASK))
> > > > +		return -ENOMEM;  
> > > 
> > > Hmm... why do we need a warn on here? This is called by this code:  
> > 
> > This was suggested as a sanity check in review of v1 of the set.
> > 
> > Supposing that someone once removed that alignment, things would go rather
> > completely haywire. There would probably be lots of other troubles as well
> > but this one would probably corrupt system memory (at least).
> 
> Well, patch 3 prevents that. See: this is not like something that driver
> developers can mess with that, as the only place where the .alloc() ops
> is called is by the VB2 core, and it already ensures page alignment.
> 
> If one would ever try to remove PAGE_ALIGN() from vb2 core, we'll nack it,
> as we know that such change will break things.

Indeed. I'm certainly fine with dropping the sanity check; I think there
are enough warnings elsewhere plus common sense to avoid making such a
change.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
