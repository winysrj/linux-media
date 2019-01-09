Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42896C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 13:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16912206B7
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 13:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfAIN40 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 08:56:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:37776 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbfAIN4Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 08:56:24 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 05:56:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,457,1539673200"; 
   d="scan'208";a="124576032"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jan 2019 05:56:22 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 254B8209CA; Wed,  9 Jan 2019 15:56:21 +0200 (EET)
Date:   Wed, 9 Jan 2019 15:56:20 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v2 1/3] videobuf2-core: Prevent size alignment wrapping
 buffer size to 0
Message-ID: <20190109135620.flzzp2a2a7pz43ea@paasikivi.fi.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
 <20190108134046.pxymxscc6cmlwyrq@paasikivi.fi.intel.com>
 <20190108123022.5dbead5b@coco.lan>
 <6971566.pIWyMH2Lze@avalon>
 <20190109101342.54aa1373@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109101342.54aa1373@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Wed, Jan 09, 2019 at 10:13:42AM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 08 Jan 2019 18:05:57 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > On Tuesday, 8 January 2019 16:30:22 EET Mauro Carvalho Chehab wrote:
> > > Em Tue, 8 Jan 2019 15:40:47 +0200
> > > 
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:  
> > > > On Tue, Jan 08, 2019 at 10:59:55AM -0200, Mauro Carvalho Chehab wrote:  
> > > > > Em Tue, 8 Jan 2019 10:52:12 -0200
> > > > > 
> > > > > Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:  
> > > > > > Em Tue,  8 Jan 2019 10:58:34 +0200
> > > > > > 
> > > > > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:  
> > > > > > > PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> > > > > > > checking that the aligned value is not smaller than the unaligned
> > > > > > > one.
> > > > > > > 
> > > > > > > Note on backporting to stable: the file used to be under
> > > > > > > drivers/media/v4l2-core, it was moved to the current location after
> > > > > > > 4.14.
> > > > > > > 
> > > > > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > > > > ---
> > > > > > > 
> > > > > > >  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
> > > > > > >  1 file changed, 4 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > > > b/drivers/media/common/videobuf2/videobuf2-core.c index
> > > > > > > 0ca81d495bda..0234ddbfa4de 100644
> > > > > > > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > > > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > > > @@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct
> > > > > > > vb2_buffer *vb)
> > > > > > > 
> > > > > > >  	for (plane = 0; plane < vb->num_planes; ++plane) {
> > > > > > >  	
> > > > > > >  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > > > > > > 
> > > > > > > +		/* Did it wrap around? */
> > > > > > > +		if (size < vb->planes[plane].length)
> > > > > > > +			goto free;
> > > > > > > +  
> > > > > > 
> > > > > > Sorry, but I can't see how this could ever happen (except for a very
> > > > > > serious bug at the compiler or at the hardware).
> > > > > > 
> > > > > > See, the definition at PAGE_ALIGN is (from mm.h):
> > > > > > 	#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> > > > > > 
> > > > > > and the macro it uses come from kernel.h:
> > > > > > 	#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))  
> > (a) -
> > > > > > 	1)
> > > > > > 	#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> > > > > > 	..
> > > > > > 	#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
> > > > > > 
> > > > > > So, this:
> > > > > > 	size = PAGE_ALIGN(length);
> > > > > > 
> > > > > > (assuming PAGE_SIZE= 0x1000)
> > > > > > 
> > > > > > becomes:
> > > > > > 	size = (length + 0x0fff) & ~0xfff;
> > > > > > 
> > > > > > so, size will *always* be >= length.  
> > > > > 
> > > > > Hmm... after looking at patch 2, now I understand what's your concern...
> > > > > 
> > > > > If someone indeed uses length = INT_MAX, size will indeed be zero.
> > > > > 
> > > > > Please adjust the description accordingly, as it doesn't reflect
> > > > > that.  
> > > > 
> > > > How about:
> > > > 
> > > > PAGE_ALIGN() may wrap the buffer length around to 0 if the value to be
> > > > aligned is close to the top of the value range of the type. Prevent this
> > > > by
> > > > checking that the aligned value is not smaller than the unaligned one.  
> > > 
> > > I would be a way more clear, as this is there to prevent a single
> > > special case: length == ULEN_MAX. Something like:
> > > 
> > > 	If one tried to allocate a buffer with sizeof(ULEN_MAX), this will cause
> > > 	an overflow at PAGE_ALIGN(), making it return zero as the size of the
> > > 	buffer, causing the code to fail.
> > > 
> > > I would even let it clearer at the code itself. So, instead of the
> > > hunk you proposed, I would do:
> > > 
> > > 	unsigned long size = vb->planes[plane].length;
> > > 
> > > 	/* Prevent PAGE_ALIGN overflow */
> > > 	if (WARN_ON(size == ULONG_MAX))
> > > 		goto free;  
> > 
> > ULONG_MAX - PAGE_SIZE + 2 to ULONG_MAX would all cause the same issue.
> 
> True. The actual check should be:
> 
> 	if (WARN_ON(size > ULONG_MAX - PAGE_SIZE + 1))

That is also wrong: aligning ULONG_MAX - PAGE_SIZE + 1 to page is 0, too.

> 
> Not that the original proposal of checking after the overflow is wrong, but, 
> IMHO, something linking the size to ULONG_MAX makes clearer about what kind
> of issue the code is meant to solve. A good comment before that would work
> fine.

I find the original test more simple to grasp: it is independent of how the
alignment is done, to PAGE_SIZE or to something else. It was also right
from the start unlike the two other checks that have been proposed so far.
Therefore my preference to stick to that. The slight downside is that it is
not apparent from the problem is related to aligning to page, but that is
mitigated by the comment added by this patch.

This property of PAGE_ALIGN() is not usually relevant as typically it's not
used to align addresses on the last page (of the value range).

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
