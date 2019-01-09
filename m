Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53BAC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8357D2075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547036030;
	bh=nIGWwD0klcXnbcLAvxM6/dCplJl11L1HQKEl3jZsPp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=e9rxuip5T31SUxU2JE254Xj6LdsCP1HJZPcjWL+8GEcndWKENDh/ikbe3tUdTNgF6
	 N8nGhtZmPcLO48aHEu91DcSzEGs/hM95jBNNajcWchYYhbzFXhO+NsswFLtFyT8F0g
	 kSJDP1N1zNXiy1ZJVcIeEnO61pVaWqvX+7CT6oNA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfAIMNu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 07:13:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:58738 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730481AbfAIMNt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 07:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Cv4R96iykOaNa1kUSjLrXfKxwhDS33yToWCf/sw0PZA=; b=LEuZzfLvLWbCBZXJyEEoos+gSL
        JEqyl+rHLwn58F+rJ74jC6gcWE9ByPPaNc4IZ3qQ93Ep6RRutRwJM7v7I7NQu17NpTH8vno5AGjiK
        zM3ZweMhaRcfNAD6ct8sAb6JRA+7pTsK+CYDvmEcAHipLg0gmkWnkVw83YvT6C6W06ZW78lUmG51K
        2G7wxHd3JnBWojhVlyUWrFYqy0ch38XLCVeeZFALnuhFUgr6c9EYpnx/6vq68iXD1lft+H8dRGdpB
        tUZKczaF0kaipvmRFhCNqncBRsge7AC8NaGJ54s3UxVJ6xyYN/QVhxXckkEWtacEbUShZz2y5imPl
        vx1+AScQ==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghCjy-0000Js-TV; Wed, 09 Jan 2019 12:13:47 +0000
Date:   Wed, 9 Jan 2019 10:13:42 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v2 1/3] videobuf2-core: Prevent size alignment wrapping
 buffer size to 0
Message-ID: <20190109101342.54aa1373@coco.lan>
In-Reply-To: <6971566.pIWyMH2Lze@avalon>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
        <20190108134046.pxymxscc6cmlwyrq@paasikivi.fi.intel.com>
        <20190108123022.5dbead5b@coco.lan>
        <6971566.pIWyMH2Lze@avalon>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 08 Jan 2019 18:05:57 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> On Tuesday, 8 January 2019 16:30:22 EET Mauro Carvalho Chehab wrote:
> > Em Tue, 8 Jan 2019 15:40:47 +0200
> > 
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:  
> > > On Tue, Jan 08, 2019 at 10:59:55AM -0200, Mauro Carvalho Chehab wrote:  
> > > > Em Tue, 8 Jan 2019 10:52:12 -0200
> > > > 
> > > > Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:  
> > > > > Em Tue,  8 Jan 2019 10:58:34 +0200
> > > > > 
> > > > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:  
> > > > > > PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> > > > > > checking that the aligned value is not smaller than the unaligned
> > > > > > one.
> > > > > > 
> > > > > > Note on backporting to stable: the file used to be under
> > > > > > drivers/media/v4l2-core, it was moved to the current location after
> > > > > > 4.14.
> > > > > > 
> > > > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > > > ---
> > > > > > 
> > > > > >  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
> > > > > >  1 file changed, 4 insertions(+)
> > > > > > 
> > > > > > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > > b/drivers/media/common/videobuf2/videobuf2-core.c index
> > > > > > 0ca81d495bda..0234ddbfa4de 100644
> > > > > > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > > @@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct
> > > > > > vb2_buffer *vb)
> > > > > > 
> > > > > >  	for (plane = 0; plane < vb->num_planes; ++plane) {
> > > > > >  	
> > > > > >  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > > > > > 
> > > > > > +		/* Did it wrap around? */
> > > > > > +		if (size < vb->planes[plane].length)
> > > > > > +			goto free;
> > > > > > +  
> > > > > 
> > > > > Sorry, but I can't see how this could ever happen (except for a very
> > > > > serious bug at the compiler or at the hardware).
> > > > > 
> > > > > See, the definition at PAGE_ALIGN is (from mm.h):
> > > > > 	#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> > > > > 
> > > > > and the macro it uses come from kernel.h:
> > > > > 	#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))  
> (a) -
> > > > > 	1)
> > > > > 	#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> > > > > 	..
> > > > > 	#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
> > > > > 
> > > > > So, this:
> > > > > 	size = PAGE_ALIGN(length);
> > > > > 
> > > > > (assuming PAGE_SIZE= 0x1000)
> > > > > 
> > > > > becomes:
> > > > > 	size = (length + 0x0fff) & ~0xfff;
> > > > > 
> > > > > so, size will *always* be >= length.  
> > > > 
> > > > Hmm... after looking at patch 2, now I understand what's your concern...
> > > > 
> > > > If someone indeed uses length = INT_MAX, size will indeed be zero.
> > > > 
> > > > Please adjust the description accordingly, as it doesn't reflect
> > > > that.  
> > > 
> > > How about:
> > > 
> > > PAGE_ALIGN() may wrap the buffer length around to 0 if the value to be
> > > aligned is close to the top of the value range of the type. Prevent this
> > > by
> > > checking that the aligned value is not smaller than the unaligned one.  
> > 
> > I would be a way more clear, as this is there to prevent a single
> > special case: length == ULEN_MAX. Something like:
> > 
> > 	If one tried to allocate a buffer with sizeof(ULEN_MAX), this will cause
> > 	an overflow at PAGE_ALIGN(), making it return zero as the size of the
> > 	buffer, causing the code to fail.
> > 
> > I would even let it clearer at the code itself. So, instead of the
> > hunk you proposed, I would do:
> > 
> > 	unsigned long size = vb->planes[plane].length;
> > 
> > 	/* Prevent PAGE_ALIGN overflow */
> > 	if (WARN_ON(size == ULONG_MAX))
> > 		goto free;  
> 
> ULONG_MAX - PAGE_SIZE + 2 to ULONG_MAX would all cause the same issue.

True. The actual check should be:

	if (WARN_ON(size > ULONG_MAX - PAGE_SIZE + 1))

Not that the original proposal of checking after the overflow is wrong, but, 
IMHO, something linking the size to ULONG_MAX makes clearer about what kind
of issue the code is meant to solve. A good comment before that would work
fine.

Thanks,
Mauro
