Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:51490 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2HXNkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 09:40:52 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: 'Federico Vaga' <federico.vaga@gmail.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	'Giancarlo Asnaghi' <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Jonathan Corbet' <corbet@lwn.net>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
 <1343765829-6006-3-git-send-email-federico.vaga@gmail.com>
 <02f301cd7eaa$4fa7a7a0$eef6f6e0$%szyprowski@samsung.com>
 <1417436.RHVOLNlTxk@harkonnen>
In-reply-to: <1417436.RHVOLNlTxk@harkonnen>
Subject: RE: [PATCH 2/3] [media] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Date: Fri, 24 Aug 2012 15:40:38 +0200
Message-id: <027701cd81fe$0ed356a0$2c7a03e0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, August 24, 2012 3:23 PM Federico Vaga wrote:

> > Getting back to your patch - in your approach cpu cache handling is
> > missing. I suspect that it worked fine only because it has been
> > tested on some simple platform without any cpu caches (or with very
> > small ones).
> 
> Is missing from the memory allocator because I do it on the device
> driver. The current operations don't allow me to do that in the memory
> allocator.

Memory allocator module is much more appropriate place for it. dma-sg
allocator also needs a huge cleanup in this area...

> > Please check the following thread:
> > http://www.spinics.net/lists/linux-media/msg51768.html where Tomasz
> > has posted his ongoing effort on updating and extending videobuf2 and
> > dma-contig allocator. Especially the patch
> > http://www.spinics.net/lists/linux-media/msg51776.html will be
> > interesting for you, because cpu cache synchronization
> > (dma_sync_single_for_device / dma_sync_single_for_cpu) should be
> > called from prepare/finish callbacks.
> 
> You are right, it is interesting because avoid me to use cache sync in
> my driver. Can I work on these patches?
> 
> From this page I understand that these patches are not approved yet
> https://patchwork.kernel.org/project/linux-media/list/?page=2

You can take the patch which adds prepare/finish methods to memory
allocators. It should not have any dependency on the other stuff from
that thread. I'm fine with merging it either together with Your patch
or via Tomasz's patchset, whatever comes first.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


