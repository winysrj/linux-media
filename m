Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab0BSGJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 01:09:28 -0500
Message-ID: <4B7E2B0F.6000706@infradead.org>
Date: Fri, 19 Feb 2010 04:09:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Updated videobuf documentation
References: <20100218101219.665c5403@bike.lwn.net> <4B7DC652.9080601@xenotime.net>
In-Reply-To: <4B7DC652.9080601@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> On 02/18/10 09:12, Jonathan Corbet wrote:
>> Here (finally) is a new version of the videobuf documentation patch.  As
>> requested by Mauro, I have cleaned up the (now) redundant information in
>> v4l2-framework.txt.  A couple of errors from the first version have
>> also been remedied.

Very good job! I only noticed the same points that Randy already commented, plus
one a few small details:


>> +Drivers using the vmalloc() method need not (and cannot) concern themselves
>> +with buffer allocation at all; videobuf will handle those details.

OK

>> The +same is true of contiguous-DMA drivers;

Not anymore: there's a patch that added USERPTR support for videobuf-dma-contig:

commit 720b17e759a50635c429ccaa2ec3d01edb4f92d6
Author: Magnus Damm <damm@igel.co.jp>
Date:   Tue Jun 16 15:32:36 2009 -0700

    videobuf-dma-contig: zero copy USERPTR support

---

In terms of memory types, there's a possibility that weren't mentioned: the OVERLAY mode.

On overlay mode, the video memory is directly mmapped by the driver. So, the DMA will
do a PCI2PCI transfer, from the video capture device into the video display adapter.
This is currently only supported by videobuf-dma-sg, and only a few drivers actually
implement it (I think it is supported only by bttv and saa7134).

I'm not sure if it is valuable enough to mention it, since, at least for desktops,
this mode is deprecated, as passing the stream to userspace allows some post-processing,
like de-interlacing. Yet, there are some new SoC video devices, mostly used
on embedded devices, where I think the Overlay mode is interesting. Those devices may
have in-hardware post-processing, so it may make sense to avoid double buffering.

Maybe a small paragraph may be added just for the completeness of the doc.


-- 

Cheers,
Mauro
