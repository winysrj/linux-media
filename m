Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B74C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EB4E214C6
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Q4l67xGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfAHQEv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:04:51 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:58804 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfAHQEv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 11:04:51 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9DCB8586;
        Tue,  8 Jan 2019 17:04:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546963488;
        bh=4qi92nTHpQ8BDPTfQlgfuquneZ+cWfAh7g+WOHfhn14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4l67xGk378yRIMGSOI/dzNGo7pm+5r5qa1MqFVGyywUB1Jx/k9fQtwze9Zn3Z1PF
         WBuMIv1mq3XA3Bh5p5nJUOL9pVls+3OPoNoQHoqFwxx5fne3xmWy63WeqD+Z+UaDSz
         p6dlzvhWawCmPMSKPkdggHfO+p/pRmSvi8tqZoVI=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v2 1/3] videobuf2-core: Prevent size alignment wrapping buffer size to 0
Date:   Tue, 08 Jan 2019 18:05:57 +0200
Message-ID: <6971566.pIWyMH2Lze@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20190108123022.5dbead5b@coco.lan>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com> <20190108134046.pxymxscc6cmlwyrq@paasikivi.fi.intel.com> <20190108123022.5dbead5b@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tuesday, 8 January 2019 16:30:22 EET Mauro Carvalho Chehab wrote:
> Em Tue, 8 Jan 2019 15:40:47 +0200
> 
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > On Tue, Jan 08, 2019 at 10:59:55AM -0200, Mauro Carvalho Chehab wrote:
> > > Em Tue, 8 Jan 2019 10:52:12 -0200
> > > 
> > > Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:
> > > > Em Tue,  8 Jan 2019 10:58:34 +0200
> > > > 
> > > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > > > > PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> > > > > checking that the aligned value is not smaller than the unaligned
> > > > > one.
> > > > > 
> > > > > Note on backporting to stable: the file used to be under
> > > > > drivers/media/v4l2-core, it was moved to the current location after
> > > > > 4.14.
> > > > > 
> > > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > > ---
> > > > > 
> > > > >  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
> > > > >  1 file changed, 4 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > b/drivers/media/common/videobuf2/videobuf2-core.c index
> > > > > 0ca81d495bda..0234ddbfa4de 100644
> > > > > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > @@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct
> > > > > vb2_buffer *vb)
> > > > > 
> > > > >  	for (plane = 0; plane < vb->num_planes; ++plane) {
> > > > >  	
> > > > >  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > > > > 
> > > > > +		/* Did it wrap around? */
> > > > > +		if (size < vb->planes[plane].length)
> > > > > +			goto free;
> > > > > +
> > > > 
> > > > Sorry, but I can't see how this could ever happen (except for a very
> > > > serious bug at the compiler or at the hardware).
> > > > 
> > > > See, the definition at PAGE_ALIGN is (from mm.h):
> > > > 	#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> > > > 
> > > > and the macro it uses come from kernel.h:
> > > > 	#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))
(a) -
> > > > 	1)
> > > > 	#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> > > > 	..
> > > > 	#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
> > > > 
> > > > So, this:
> > > > 	size = PAGE_ALIGN(length);
> > > > 
> > > > (assuming PAGE_SIZE= 0x1000)
> > > > 
> > > > becomes:
> > > > 	size = (length + 0x0fff) & ~0xfff;
> > > > 
> > > > so, size will *always* be >= length.
> > > 
> > > Hmm... after looking at patch 2, now I understand what's your concern...
> > > 
> > > If someone indeed uses length = INT_MAX, size will indeed be zero.
> > > 
> > > Please adjust the description accordingly, as it doesn't reflect
> > > that.
> > 
> > How about:
> > 
> > PAGE_ALIGN() may wrap the buffer length around to 0 if the value to be
> > aligned is close to the top of the value range of the type. Prevent this
> > by
> > checking that the aligned value is not smaller than the unaligned one.
> 
> I would be a way more clear, as this is there to prevent a single
> special case: length == ULEN_MAX. Something like:
> 
> 	If one tried to allocate a buffer with sizeof(ULEN_MAX), this will cause
> 	an overflow at PAGE_ALIGN(), making it return zero as the size of the
> 	buffer, causing the code to fail.
> 
> I would even let it clearer at the code itself. So, instead of the
> hunk you proposed, I would do:
> 
> 	unsigned long size = vb->planes[plane].length;
> 
> 	/* Prevent PAGE_ALIGN overflow */
> 	if (WARN_ON(size == ULONG_MAX))
> 		goto free;

ULONG_MAX - PAGE_SIZE + 2 to ULONG_MAX would all cause the same issue.
> 
> 	size = PAGE_ALIGN(vb->planes[plane].length);

-- 
Regards,

Laurent Pinchart



