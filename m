Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166D7C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8FC520849
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8FC520849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbeLMNGh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:06:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:4443 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728875AbeLMNGh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:06:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 05:06:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,349,1539673200"; 
   d="scan'208";a="109240943"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 13 Dec 2018 05:06:35 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id C570D207AF; Thu, 13 Dec 2018 15:06:34 +0200 (EET)
Date:   Thu, 13 Dec 2018 15:06:34 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 1/3] videobuf2-core: Prevent size alignment wrapping
 buffer size to 0
Message-ID: <20181213130634.zetfe6z74v67hdl6@paasikivi.fi.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
 <20181213104006.401-2-sakari.ailus@linux.intel.com>
 <11116293.zm9aLRIdQE@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11116293.zm9aLRIdQE@avalon>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 02:49:44PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday, 13 December 2018 12:40:04 EET Sakari Ailus wrote:
> > PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> > checking that the aligned value is not smaller than the unaligned one.
> > 
> > Note on backporting to stable: the file used to be under
> > drivers/media/v4l2-core, it was moved to the current location after 4.14.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> > b/drivers/media/common/videobuf2/videobuf2-core.c index
> > 0ca81d495bdaf..0234ddbfa4de2 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> >  	for (plane = 0; plane < vb->num_planes; ++plane) {
> >  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > 
> > +		/* Did it wrap around? */
> > +		if (size < vb->planes[plane].length)
> > +			goto free;
> > +
> >  		mem_priv = call_ptr_memop(vb, alloc,
> >  				q->alloc_devs[plane] ? : q->dev,
> >  				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
> 
> Wouldn't it be better to reject length > INT_MAX (or some variations of that) 
> a few steps before, for instance just before calling __vb2_queue_alloc() ? 
> There's already a check in vb2_core_reqbufs():
> 
>         /* Check that driver has set sane values */
>         if (WARN_ON(!num_planes))
>                 return -EINVAL;
> 
>         for (i = 0; i < num_planes; i++)
>                 if (WARN_ON(!plane_sizes[i]))
>                         return -EINVAL;
> 
> It could be extended to validate the sizes against wrap-around, and moved to a 
> separate function to be called in vb2_core_create_bufs() as well (as those 
> checks are missing there). Alternatively, the checks could be moved to the 
> beginning of __vb2_queue_alloc().

I'd hate to distribute the aligning to PAGE_SIZE in the two functions. An
alternative would be to add a new function argument for the aligned size,
but I like that even less. I think it might be better as-is.

I don't have a strong opinion either way though, and you certainly have a
point as well. What do you think?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
