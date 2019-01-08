Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4286AC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11F48206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546955049;
	bh=9QHUBwkUTviqOTc0kp7EfGUr95WG9Qz8qMointz/eTE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=zDJKDOS0Bk5q8trtD/7UEJK60AUpY/4yYh1YTFLCU3/tzByDZKEelIFwO9t6Q0flI
	 C2oLUTqEAU/W05firJuHIY64Ky5vpPncKwvYrsSBlHL7V35vXVCEEitHDO3wonxgCy
	 RFw6VuY/3fjJldq28ASmUl8r6rdu6EV8/Vg1ft1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfAHNoI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:44:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:53438 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfAHNoI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 08:44:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UkmCYr6eWwV7uqn3szIZ+9ViliEw2kpsytS/XabPB88=; b=jCuyEs9c32LwHfqxp/GeM/YExp
        kHIjzF12SovzUNsqVI2YzrPL6oFaj72lXiKu80Ztvd8f4q1gDtokZVF5DAYQ8bYM8XVrxlANT3xXW
        grmVZf0IdibWhj0jiFDc8HugMU9cgDu0RhpEpGZP2pot/24MhCErWppFskVqLH/0f4Ej/DKWpYjSz
        9PotSPGAnIGRh7VoaFtKXyuRhf3ZnfMUD3kTMbf6Yo17RibXzvDHa16pn9LalYpafevOlZ0tj+6/o
        Zt8zcWTO1RAzJ2Ix+WueF82FTIiOwem52CSZIX2JMGIluoXiHk34d3wMJKFfRAjvqE+qvvhGndPZL
        qruZUVfg==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggrfq-0004mw-3f; Tue, 08 Jan 2019 13:44:06 +0000
Date:   Tue, 8 Jan 2019 11:44:01 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 2/3] videobuf2-dma-sg: Prevent size from overflowing
Message-ID: <20190108114401.10f09372@coco.lan>
In-Reply-To: <20190108132926.fk4rz3tfw6gjuhx7@paasikivi.fi.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
        <20190108085836.9376-3-sakari.ailus@linux.intel.com>
        <20190108110942.7a58d455@coco.lan>
        <20190108132926.fk4rz3tfw6gjuhx7@paasikivi.fi.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 8 Jan 2019 15:29:26 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> On Tue, Jan 08, 2019 at 11:09:42AM -0200, Mauro Carvalho Chehab wrote:
> > Em Tue,  8 Jan 2019 10:58:35 +0200
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> > > buf->size is an unsigned long; casting that to int will lead to an
> > > overflow if buf->size exceeds INT_MAX.
> > > 
> > > Fix this by changing the type to unsigned long instead. This is possible
> > > as the buf->size is always aligned to PAGE_SIZE, and therefore the size
> > > will never have values lesser than 0.
> > > 
> > > Note on backporting to stable: the file used to be under
> > > drivers/media/v4l2-core, it was moved to the current location after 4.14.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > ---
> > >  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > index 015e737095cd..5fdb8d7051f6 100644
> > > --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > @@ -59,7 +59,10 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
> > >  		gfp_t gfp_flags)
> > >  {
> > >  	unsigned int last_page = 0;
> > > -	int size = buf->size;
> > > +	unsigned long size = buf->size;  
> > 
> > OK.
> >   
> > > +
> > > +	if (WARN_ON(size & ~PAGE_MASK))
> > > +		return -ENOMEM;  
> > 
> > Hmm... why do we need a warn on here? This is called by this code:  
> 
> This was suggested as a sanity check in review of v1 of the set.
> 
> Supposing that someone once removed that alignment, things would go rather
> completely haywire. There would probably be lots of other troubles as well
> but this one would probably corrupt system memory (at least).

Well, patch 3 prevents that. See: this is not like something that driver
developers can mess with that, as the only place where the .alloc() ops
is called is by the VB2 core, and it already ensures page alignment.

If one would ever try to remove PAGE_ALIGN() from vb2 core, we'll nack it,
as we know that such change will break things.

Thanks,
Mauro
