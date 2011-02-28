Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:45206 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1B1JFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 04:05:20 -0500
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHB007NOKKFZH00@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Feb 2011 17:50:39 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHB003LWKK1KK@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Feb 2011 17:50:39 +0900 (KST)
Date: Mon, 28 Feb 2011 09:50:15 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [st-ericsson] v4l2 vs omx for camera
In-reply-to: <alpine.LFD.2.00.1102261408010.22034@xanadu.home>
To: 'Nicolas Pitre' <nicolas.pitre@linaro.org>,
	'Kyungmin Park' <kmpark@infradead.org>
Cc: 'Linus Walleij' <linus.walleij@linaro.org>,
	linaro-dev@lists.linaro.org,
	'Harald Gustafsson' <harald.gustafsson@ericsson.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Edward Hervey' <bilboed@gmail.com>,
	'Discussion of the development of and with GStreamer'
	<gstreamer-devel@lists.freedesktop.org>,
	johan.mossberg.lml@gmail.com,
	'ST-Ericsson LT Mailing List' <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <002b01cbd724$8e528bc0$aaf7a340$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
 <AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
 <201102100847.15212.hverkuil@xs4all.nl>
 <201102171448.09063.laurent.pinchart@ideasonboard.com>
 <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
 <1298578789.821.54.camel@deumeu>
 <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
 <AANLkTini7xuQ2kcrWbfGSUomdoPkLLJiik2soer8SL+X@mail.gmail.com>
 <alpine.LFD.2.00.1102261408010.22034@xanadu.home>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Saturday, February 26, 2011 8:20 PM Nicolas Pitre wrote:

> On Sat, 26 Feb 2011, Kyungmin Park wrote:
> 
> > On Sat, Feb 26, 2011 at 2:22 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > > 2011/2/24 Edward Hervey <bilboed@gmail.com>:
> > >
> > >>  What *needs* to be solved is an API for data allocation/passing at the
> > >> kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
> > >> userspace (like GStreamer) can pass around, monitor and know about.
> > >
> > > I think the patches sent out from ST-Ericsson's Johan Mossberg to
> > > linux-mm for "HWMEM" (hardware memory) deals exactly with buffer
> > > passing, pinning of buffers and so on. The CMA (Contigous Memory
> > > Allocator) has been slightly modified to fit hand-in-glove with HWMEM,
> > > so CMA provides buffers, HWMEM pass them around.
> > >
> > > Johan, when you re-spin the HWMEM patchset, can you include
> > > linaro-dev and linux-media in the CC? I think there is *much* interest
> > > in this mechanism, people just don't know from the name what it
> > > really does. Maybe it should be called mediamem or something
> > > instead...
> >
> > To Marek,
> >
> > Can you also update the CMA status and plan?
> >
> > The important thing is still Russell don't agree the CMA since it's
> > not solve the ARM different memory attribute mapping issue. Of course
> > there's no way to solve the ARM issue.
> 
> There are at least two ways to solve that issue, and I have suggested
> both on the lak mailing list already.
> 
> 1) Make the direct mapped kernel memory usable by CMA mapped through a
>    page-sized two-level page table mapping which would allow for solving
>    the attributes conflict on a per page basis.

That's the solution I work on now. I've also suggested this in the last
CMA discussion, however there was no response if this is the right way

> 2) Use highmem more aggressively and allow only highmem pages for CMA.
>    This is quite easy to make sure the target page(s) for CMA would have
>    no kernel mappings and therefore no attribute conflict.  Furthermore,
>    highmem pages are always relocatable for making physically contiguous
>    segments available.

I'm not sure that highmem is the right solution. First, this will force
systems with rather small amount of memory (like 256M) to use highmem just
to support DMA allocable memory. It also doesn't solve the issue with
specific memory requirement for our DMA hardware (multimedia codec needs
video memory buffers from 2 physical banks).

The relocation issue has been already addressed in the last CMA patch series.
Michal managed to create a framework that allowed to relocate on demand any
pages from the CMA area.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


