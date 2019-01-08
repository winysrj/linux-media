Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C77C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D8C820827
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546957436;
	bh=sFd/uezyTnavW3E/wKrq1QiTLQ+p6TDD/zRorRZ0KKA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=dWFSQDEdbI5w+ExKOstzCWiiCSYOXbYBektqhnJsoGpc+OZB4r2p0l1hXMIpMM+oD
	 vyUhbomRQAUNTZk59PkqrAP0BXebsYVWVyr9WP2bwuXL0/RXySgwOdPYVx7apGO2xY
	 0JEIjkhw+5C8NNezWstg0ND7WXLPH/mtDbj0Jab4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfAHOXz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:23:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:57322 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbfAHOXz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:23:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4IO/SCJG9DyJm0/XOBECKwNKWIZHCaX7lwiDWRq9mxc=; b=XTW6oryFqRJrOkS6IitmSQlzDJ
        2VNtiyUcoPjQQlWW36+Nw43FuktKPCYrwwIYZonGWqVECHAiR7AhuYiU0dvsad73QQk12ZJyRVX0a
        72jLIk4SjF+P/Kkcn7a8MW2Ns+ClYdxKfwf9+7BbZ8Vc1vIgUlBz2dUUfGZo6vDdEJhlNrcywoYYJ
        nfOBjIi1FtPob1hLOI2riWWpggsal1js0Aff5L2LPVuqTzzYpcvfC4CzBvOp1Qa5+o2EvszyJVILJ
        ngQ/XUDmsamC7mMWKGT6iwCVNX6X7HW+LosW8yoBsfduR/vfXp1Bb/uHCqh5Kxg8chNIV1BPuMrkz
        hPYM9vVw==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggsIL-0006x4-Dy; Tue, 08 Jan 2019 14:23:53 +0000
Date:   Tue, 8 Jan 2019 12:23:49 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 1/3] videobuf2-core: Prevent size alignment wrapping
 buffer size to 0
Message-ID: <20190108122349.15639460@coco.lan>
In-Reply-To: <20190108133832.x23ypnl3zhzyrezi@paasikivi.fi.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
        <20190108085836.9376-2-sakari.ailus@linux.intel.com>
        <20190108105212.66837b9a@coco.lan>
        <20190108105955.68009949@coco.lan>
        <20190108133832.x23ypnl3zhzyrezi@paasikivi.fi.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 8 Jan 2019 15:38:32 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> Thanks for the review.
> 
> On Tue, Jan 08, 2019 at 10:59:55AM -0200, Mauro Carvalho Chehab wrote:
> > Em Tue, 8 Jan 2019 10:52:12 -0200
> > Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:
> >   
> > > Em Tue,  8 Jan 2019 10:58:34 +0200
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > >   
> > > > PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> > > > checking that the aligned value is not smaller than the unaligned one.
> > > > 
> > > > Note on backporting to stable: the file used to be under
> > > > drivers/media/v4l2-core, it was moved to the current location after 4.14.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: stable@vger.kernel.org
> > > > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > ---
> > > >  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > index 0ca81d495bda..0234ddbfa4de 100644
> > > > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > @@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> > > >  	for (plane = 0; plane < vb->num_planes; ++plane) {
> > > >  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > > >  
> > > > +		/* Did it wrap around? */
> > > > +		if (size < vb->planes[plane].length)
> > > > +			goto free;
> > > > +  
> > > 
> > > Sorry, but I can't see how this could ever happen (except for a very serious
> > > bug at the compiler or at the hardware).
> > > 
> > > See, the definition at PAGE_ALIGN is (from mm.h):
> > > 
> > > 	#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> > > 
> > > and the macro it uses come from kernel.h:
> > > 
> > > 	#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
> > > 	#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> > > 	..
> > > 	#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
> > > 
> > > So, this:
> > > 	size = PAGE_ALIGN(length);
> > > 
> > > (assuming PAGE_SIZE= 0x1000)
> > > 
> > > becomes:
> > > 
> > > 	size = (length + 0x0fff) & ~0xfff;
> > > 
> > > so, size will *always* be >= length.  
> > 
> > Hmm... after looking at patch 2, now I understand what's your concern...
> > 
> > If someone indeed uses length = INT_MAX, size will indeed be zero.
> > 
> > Please adjust the description accordingly, as it doesn't reflect
> > that.
> > 
> > Btw, in this particular case, I would use a WARN_ON(), as this is
> > something that indicates not only a driver bug (as the driver is
> > letting someone to request a buffer a way too big), but probably  
> 
> What's the maximum size a driver should allow? I guess this could be seen
> be a failure from the driver's part to limit the size of the buffer, but
> it's not trivial either to define that.
> 
> Hardware typically has maximum dimensions it can support, but the user may
> want to add padding at the end of the lines. Perhaps a helper macro could
> be used for this purpose: most likely there's no need to be more padding
> than there's image data per line. If that turns out to be too restrictive,
> the macro could be changed. That's probably unlikely, admittedly.
> 
> For some hardware these numbers could still be more than a 32-bit unsigned
> integer can hold, so the check is still needed.

I guess that, by changing from "int" to "unsigned long", we ensure that the 
number should be big enough to be able to represent the maximum allocation
size.

On Linux, sizeof(long) is usually assumed to be sizeof(void *). Such
assumption is used, for example, when we pass a structure pointer to
ioctl's, instead of passing a long integer.

I mean, on a 64 bits system, long has 64 bits. AFAIKT, even the latest
Xeon CPUs, the address space is lower than 64 bits. So, if one tries to
allocate a memory with sizeof(ULONG_MAX), this will fail with ENOMEM.

On any (true) 32 bits system, the physical address is to 32 bits.
So, if one tries to allocate a memory with ULONG_MAX, this should
also fail, as there won't be memory for anything else.

There are some special cases, like X86_PAE (and ARM_LPAE). There, the 
physical address space is 64 bits, but instruction set is the 32 bits one.
Yet, I'm almost sure that (at least on x86) a single memory block there 
can't be bigger than 32 bits.

What I'm trying to say is that I strongly suspect that we won't have 
any cases where someone using would need a buffer with more than 
32 bits size on a non-64 architecture.

> 
> > also an attempt from a hacker to try to crack the system.  
> 
> This could be also v4l2-compliance setting the length field to -1. A
> warning is worth it only if there's good chance there's e.g. a kernel bug
> involved.
> 



Thanks,
Mauro
