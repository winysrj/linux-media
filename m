Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DABAC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3D23214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfAIIlK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 03:41:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:37859 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbfAIIlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 03:41:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 00:41:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,456,1539673200"; 
   d="scan'208";a="290096346"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 09 Jan 2019 00:41:08 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 43D5A20948; Wed,  9 Jan 2019 10:41:07 +0200 (EET)
Date:   Wed, 9 Jan 2019 10:41:07 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 1/3] videobuf2-core: Prevent size alignment wrapping
 buffer size to 0
Message-ID: <20190109084106.vk5mwnyw4ic7f5fb@paasikivi.fi.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
 <20190108085836.9376-2-sakari.ailus@linux.intel.com>
 <20190108105212.66837b9a@coco.lan>
 <20190108105955.68009949@coco.lan>
 <20190108133832.x23ypnl3zhzyrezi@paasikivi.fi.intel.com>
 <20190108122349.15639460@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108122349.15639460@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 08, 2019 at 12:23:49PM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 8 Jan 2019 15:38:32 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > Hi Mauro,
> > 
> > Thanks for the review.
> > 
> > On Tue, Jan 08, 2019 at 10:59:55AM -0200, Mauro Carvalho Chehab wrote:
> > > Em Tue, 8 Jan 2019 10:52:12 -0200
> > > Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:
> > >   
> > > > Em Tue,  8 Jan 2019 10:58:34 +0200
> > > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > > >   
> > > > > PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> > > > > checking that the aligned value is not smaller than the unaligned one.
> > > > > 
> > > > > Note on backporting to stable: the file used to be under
> > > > > drivers/media/v4l2-core, it was moved to the current location after 4.14.
> > > > > 
> > > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > > ---
> > > > >  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
> > > > >  1 file changed, 4 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > index 0ca81d495bda..0234ddbfa4de 100644
> > > > > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > > > > @@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> > > > >  	for (plane = 0; plane < vb->num_planes; ++plane) {
> > > > >  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > > > >  
> > > > > +		/* Did it wrap around? */
> > > > > +		if (size < vb->planes[plane].length)
> > > > > +			goto free;
> > > > > +  
> > > > 
> > > > Sorry, but I can't see how this could ever happen (except for a very serious
> > > > bug at the compiler or at the hardware).
> > > > 
> > > > See, the definition at PAGE_ALIGN is (from mm.h):
> > > > 
> > > > 	#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> > > > 
> > > > and the macro it uses come from kernel.h:
> > > > 
> > > > 	#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
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
> > > > 
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
> > > 
> > > Btw, in this particular case, I would use a WARN_ON(), as this is
> > > something that indicates not only a driver bug (as the driver is
> > > letting someone to request a buffer a way too big), but probably  
> > 
> > What's the maximum size a driver should allow? I guess this could be seen
> > be a failure from the driver's part to limit the size of the buffer, but
> > it's not trivial either to define that.
> > 
> > Hardware typically has maximum dimensions it can support, but the user may
> > want to add padding at the end of the lines. Perhaps a helper macro could
> > be used for this purpose: most likely there's no need to be more padding
> > than there's image data per line. If that turns out to be too restrictive,
> > the macro could be changed. That's probably unlikely, admittedly.
> > 
> > For some hardware these numbers could still be more than a 32-bit unsigned
> > integer can hold, so the check is still needed.
> 
> I guess that, by changing from "int" to "unsigned long", we ensure that the 
> number should be big enough to be able to represent the maximum allocation
> size.
> 
> On Linux, sizeof(long) is usually assumed to be sizeof(void *). Such
> assumption is used, for example, when we pass a structure pointer to
> ioctl's, instead of passing a long integer.
> 
> I mean, on a 64 bits system, long has 64 bits. AFAIKT, even the latest
> Xeon CPUs, the address space is lower than 64 bits. So, if one tries to
> allocate a memory with sizeof(ULONG_MAX), this will fail with ENOMEM.
> 
> On any (true) 32 bits system, the physical address is to 32 bits.
> So, if one tries to allocate a memory with ULONG_MAX, this should
> also fail, as there won't be memory for anything else.
> 
> There are some special cases, like X86_PAE (and ARM_LPAE). There, the 
> physical address space is 64 bits, but instruction set is the 32 bits one.
> Yet, I'm almost sure that (at least on x86) a single memory block there 
> can't be bigger than 32 bits.
> 
> What I'm trying to say is that I strongly suspect that we won't have 
> any cases where someone using would need a buffer with more than 
> 32 bits size on a non-64 architecture.

I agree; also the length field in struct v4l2_buffer is a __u32 so that
limits the value range for size as well.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
