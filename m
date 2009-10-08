Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49794 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbZJHV0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 17:26:47 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Thu, 8 Oct 2009 16:26:04 -0500
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <A69FA2915331DC488A831521EAE36FE40154EE1938@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <002201ca4655$dd8dc260$98a94720$%szyprowski@samsung.com>
 <A69FA2915331DC488A831521EAE36FE4015546FBDB@dlee06.ent.ti.com>,<000101ca47ef$fd373510$f7a59f30$%szyprowski@samsung.com>
In-Reply-To: <000101ca47ef$fd373510$f7a59f30$%szyprowski@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

f such design? (in
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

Marek,

You can't say that. This feature is currently supported in our internal release which is
being used by our customers. So for feature parity it is required to be supported as
we can't determine how many customers are using this feature. Besides in the above
scenario that I have mentioned, following happens.

sensor -> CCDC -> Memory (video node)

Memory -> Previewer -> Resizer1 -> Memory
                                   |-> Resizer2 -> Memory

Typically application capture full resolution frame (Bayer RGB) to Memory and then use Previewer
and Resizer in memory to memory mode to do conversion to UYVY format. But application use second
resizer to get a lower resolution frame simultaneously. We would like to expose this hardware
capability to user application through this memory to memory device. 

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

Yes. No hacking please! We should be able to do S_FMT for the second Resizer output and dequeue
the frame. Not sure how can we handle this in this model. 

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



