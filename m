Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:46696 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZJHIWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 04:22:00 -0400
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR600448SIDPG@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Oct 2009 17:20:37 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR600M0ASI1RD@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Oct 2009 17:20:36 +0900 (KST)
Date: Thu, 08 Oct 2009 10:18:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <A69FA2915331DC488A831521EAE36FE4015546FBDB@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000101ca47ef$fd373510$f7a59f30$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <002201ca4655$dd8dc260$98a94720$%szyprowski@samsung.com>
 <A69FA2915331DC488A831521EAE36FE4015546FBDB@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, October 07, 2009 4:03 PM Karicheri, Muralidharan wrote:

> >How the hardware is actually designed? I see two possibilities:
> >
> >1.
> >[input buffer] --[dma engine]----> [resizer1] --[dma]-> [mem output
> >buffer1]
> >                               \-> [resizer2] --[dma]-> [mem output
> >buffer2]
> >
> This is the case.
> >2.
> >[input buffer] ---[dma engine1]-> [resizer1] --[dma]-> [mem output buffer1]
> >                \-[dma engine2]-> [resizer2] --[dma]-> [mem output buffer2]
> >
> >In the first case we would really have problems mapping it properly to
> >video
> >nodes. But we should think if there are any use cases of such design? (in
> >terms of mem-2-mem device)
> 
> Why not? In a typical camera scenario, application can feed one frame and get two output frames (one
> for storing and another for sending over email (a lower resolution). I just gave an example.

You gave an example of the Y-type pipeline which start in real streaming
device (camera) which is completely different thing. Y-type CAPTURE pipeline
is quite common thing, which can be simply mapped to 2 different capture
video nodes.

In my previous mail I asked about Y-type pipeline which starts in memory. I
don't think there is any common use case for such thing.

>  I know that this Y-type design makes sense as a
> >part of the pipeline from a sensor or decoder device. But I cannot find any
> >useful use case for mem2mem version of it.
> >
> >The second case is much more trivial. One can just create two separate
> >resizer
> >devices (with their own nodes) or one resizer driver with two hardware
> >resizers underneath it. In both cases application would simply queue the
> >input
> >buffer 2 times for both transactions.
> I am assuming we are using the One node implementation model suggested by Ivan.
> 
> At hardware, streaming should happen at the same time (only one bit in register). So if we have second
> node for the same, then driver needs to match the IO instance of second device with the corresponding
> request on first node and this takes us to the same complication as with 2 video nodes implementation.

Right.

> Since only one capture queue per IO instance is possible in this model (matched by buf type), I don't
> think we can scale it for 2 outputs case. Or is it possible to queue 2 output buffers of two different
> sizes to the same queue?

This can be hacked by introducing yet another 'type' (for example
SECOND_CAPTURE), but I don't like such solution. Anyway - would we really
need Y-type mem2mem device?

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


