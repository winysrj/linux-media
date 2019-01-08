Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC3EC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD33A2087E
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546952401;
	bh=9v6z0PHx16Srrjjk9bhQq1K2HPnrTbUvfJEX7Vw/Xdg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=YyGwQFDXYgUyuoQdCpNZuLMPAVEFklFqLAyPlK0WF+T2ETfuBFlkDAQmXAUk39akV
	 4hDihE3gS7M1ome6PxCcz9U464xDqQvV+GIhsbqmvt6TpRKduGrKd+Ayotg9300N/t
	 74m+mnShwMRNqPsgi8npP5eofL4tPo44qXlD40+A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfAHNAB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:00:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:49660 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfAHNAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 08:00:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2YxERaHGs9ffLqONjGUrRxyS1EZF8etWUA5pEYx2lN4=; b=oYk12YmW5VgWxP7/5XCJB/V973
        zSEqZnPFduOuBHyU/3yZnas9LCLOY3uEVY1pBCMitZ9B2X8Eurnt10+XY+30cFOrDEwjXCBjvmvbT
        BUHQJ8Rh9NVkfvm4I/QHNH391E1BjZO0dJe2hAUQSSd0xXzPrpH4jlXDLQpLmxxkCoKfhgOWJn+66
        u1Yme4OGvnEDPTRBE1D4NRqhE4GEDntb9UXyxCxKQWAhSeRxxSYOWy8Nphua4WfEW4OCQLbCdaAnv
        z8924/VfXhUyBXp91Z9QYg7MCnwQLhmJToVPQHLl0iNY21yVqM8j93ps8fYLeE31+dX6hhz2QgQJm
        oGRcLguQ==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggqz9-0002pM-JG; Tue, 08 Jan 2019 12:59:59 +0000
Date:   Tue, 8 Jan 2019 10:59:55 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 1/3] videobuf2-core: Prevent size alignment wrapping
 buffer size to 0
Message-ID: <20190108105955.68009949@coco.lan>
In-Reply-To: <20190108105212.66837b9a@coco.lan>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
        <20190108085836.9376-2-sakari.ailus@linux.intel.com>
        <20190108105212.66837b9a@coco.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 8 Jan 2019 10:52:12 -0200
Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:

> Em Tue,  8 Jan 2019 10:58:34 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> > checking that the aligned value is not smaller than the unaligned one.
> > 
> > Note on backporting to stable: the file used to be under
> > drivers/media/v4l2-core, it was moved to the current location after 4.14.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> >  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > index 0ca81d495bda..0234ddbfa4de 100644
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
> 
> Sorry, but I can't see how this could ever happen (except for a very serious
> bug at the compiler or at the hardware).
> 
> See, the definition at PAGE_ALIGN is (from mm.h):
> 
> 	#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> 
> and the macro it uses come from kernel.h:
> 
> 	#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
> 	#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> 	..
> 	#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
> 
> So, this:
> 	size = PAGE_ALIGN(length);
> 
> (assuming PAGE_SIZE= 0x1000)
> 
> becomes:
> 
> 	size = (length + 0x0fff) & ~0xfff;
> 
> so, size will *always* be >= length.

Hmm... after looking at patch 2, now I understand what's your concern...

If someone indeed uses length = INT_MAX, size will indeed be zero.

Please adjust the description accordingly, as it doesn't reflect
that.

Btw, in this particular case, I would use a WARN_ON(), as this is
something that indicates not only a driver bug (as the driver is
letting someone to request a buffer a way too big), but probably
also an attempt from a hacker to try to crack the system.

Thanks,
Mauro
