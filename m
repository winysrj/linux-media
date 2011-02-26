Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55334 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1BZTUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 14:20:05 -0500
Received: by qwd7 with SMTP id 7so1980747qwd.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 11:20:04 -0800 (PST)
Date: Sat, 26 Feb 2011 14:20:02 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
cc: Linus Walleij <linus.walleij@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Edward Hervey <bilboed@gmail.com>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	johan.mossberg.lml@gmail.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
In-Reply-To: <AANLkTini7xuQ2kcrWbfGSUomdoPkLLJiik2soer8SL+X@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1102261408010.22034@xanadu.home>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com> <201102100847.15212.hverkuil@xs4all.nl> <201102171448.09063.laurent.pinchart@ideasonboard.com>
 <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com> <1298578789.821.54.camel@deumeu> <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com> <AANLkTini7xuQ2kcrWbfGSUomdoPkLLJiik2soer8SL+X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-243630289-1298748003=:22034"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-243630289-1298748003=:22034
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 26 Feb 2011, Kyungmin Park wrote:

> On Sat, Feb 26, 2011 at 2:22 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > 2011/2/24 Edward Hervey <bilboed@gmail.com>:
> >
> >>  What *needs* to be solved is an API for data allocation/passing at the
> >> kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
> >> userspace (like GStreamer) can pass around, monitor and know about.
> >
> > I think the patches sent out from ST-Ericsson's Johan Mossberg to
> > linux-mm for "HWMEM" (hardware memory) deals exactly with buffer
> > passing, pinning of buffers and so on. The CMA (Contigous Memory
> > Allocator) has been slightly modified to fit hand-in-glove with HWMEM,
> > so CMA provides buffers, HWMEM pass them around.
> >
> > Johan, when you re-spin the HWMEM patchset, can you include
> > linaro-dev and linux-media in the CC? I think there is *much* interest
> > in this mechanism, people just don't know from the name what it
> > really does. Maybe it should be called mediamem or something
> > instead...
> 
> To Marek,
> 
> Can you also update the CMA status and plan?
> 
> The important thing is still Russell don't agree the CMA since it's
> not solve the ARM different memory attribute mapping issue. Of course
> there's no way to solve the ARM issue.

There are at least two ways to solve that issue, and I have suggested 
both on the lak mailing list already.

1) Make the direct mapped kernel memory usable by CMA mapped through a 
   page-sized two-level page table mapping which would allow for solving 
   the attributes conflict on a per page basis.

2) Use highmem more aggressively and allow only highmem pages for CMA.
   This is quite easy to make sure the target page(s) for CMA would have
   no kernel mappings and therefore no attribute conflict.  Furthermore, 
   highmem pages are always relocatable for making physically contiguous 
   segments available.


Nicolas
--8323328-243630289-1298748003=:22034--
