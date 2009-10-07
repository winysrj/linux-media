Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39543 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772AbZJGOEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2009 10:04:08 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Wed, 7 Oct 2009 09:03:24 -0500
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <A69FA2915331DC488A831521EAE36FE4015546FBDB@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <002201ca4655$dd8dc260$98a94720$%szyprowski@samsung.com>
In-Reply-To: <002201ca4655$dd8dc260$98a94720$%szyprowski@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marek,

>
>How the hardware is actually designed? I see two possibilities:
>
>1.
>[input buffer] --[dma engine]----> [resizer1] --[dma]-> [mem output
>buffer1]
>                               \-> [resizer2] --[dma]-> [mem output
>buffer2]
>
This is the case.
>2.
>[input buffer] ---[dma engine1]-> [resizer1] --[dma]-> [mem output buffer1]
>                \-[dma engine2]-> [resizer2] --[dma]-> [mem output buffer2]
>
>In the first case we would really have problems mapping it properly to
>video
>nodes. But we should think if there are any use cases of such design? (in
>terms of mem-2-mem device)

Why not? In a typical camera scenario, application can feed one frame and get two output frames (one for storing and another for sending over email (a lower resolution). I just gave an example. You would say that this can be done in two steps, but when hardware is capable of doing this parallel, why not driver provide the support?

 I know that this Y-type design makes sense as a
>part of the pipeline from a sensor or decoder device. But I cannot find any
>useful use case for mem2mem version of it.
>
>The second case is much more trivial. One can just create two separate
>resizer
>devices (with their own nodes) or one resizer driver with two hardware
>resizers underneath it. In both cases application would simply queue the
>input
>buffer 2 times for both transactions.
I am assuming we are using the One node implementation model suggested by Ivan.

At hardware, streaming should happen at the same time (only one bit in register). So if we have second node for the same, then driver needs to match the IO instance of second device with the corresponding request on first node and this takes us to the same complication as with 2 video nodes implementation. Since only one capture queue per IO instance is possible in this model (matched by buf type), I don't think we can scale it for 2 outputs case. Or is it possible to queue 2 output buffers of two different sizes to the same queue?  
>
>Best regards
>--
>Marek Szyprowski
>Samsung Poland R&D Center
>
>

