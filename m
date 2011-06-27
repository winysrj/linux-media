Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11518 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1F0PSP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 11:18:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNG007XJFUE8JB0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Jun 2011 16:18:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNG002RUFUD32@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Jun 2011 16:18:13 +0100 (BST)
Date: Mon, 27 Jun 2011 17:18:09 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: The return value of __vb2_queue_alloc()
In-reply-to: <20110624142701.0c5c7a7e@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>,
	'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <001801cc34dd$6c7bef20$4573cd60$%szyprowski@samsung.com>
Content-language: pl
References: <20110624141927.1c89a033@bike.lwn.net>
 <20110624142701.0c5c7a7e@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Friday, June 24, 2011 10:27 PM Jonathan Corbet wrote:

> On Fri, 24 Jun 2011 14:19:27 -0600
> Jonathan Corbet <corbet@lwn.net> wrote:
> 
> > Here's a little something I decided to hack on rather than addressing all
> > the real work I have to do.
> 
> ...and while I was looking at this code, I noticed one little curious
> thing:
> 
> int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> {
> /* ... */
> 	/* Finally, allocate buffers and video memory */
> 	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes,
> 				plane_sizes);
> 	if (ret < 0) {
> 		dprintk(1, "Memory allocation failed with error: %d\n", ret);
> 		return ret;
> 	}
> 
> If you actually look at __vb2_queue_alloc(), it claims to return the
> number of buffers actually allocated, and an inspection of the code bears
> up that claim.  So it can never return a negative value.  Do you maybe
> want "if (ret <= 0) {" there instead?  One assumes there will be few
> drivers so accommodating as to work with zero buffers.

You are right. There is no point asking driver if it accepts zero buffers. 
Thanks for pointing the bug!

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



