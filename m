Return-path: <linux-media-owner@vger.kernel.org>
Received: from wmproxy2-g27.free.fr ([212.27.42.92]:16284 "EHLO
	wmproxy2-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZCKNsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 09:48:50 -0400
Date: Wed, 11 Mar 2009 14:48:45 +0100 (CET)
From: robert.jarzmik@free.fr
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: ospite@studenti.unina.it, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <651370679.3318401236779325568.JavaMail.root@zimbra20-e3.priv.proxad.net>
In-Reply-To: <722242271.3317321236779109198.JavaMail.root@zimbra20-e3.priv.proxad.net>
Subject: Re: [PATCH] pxa_camera: Redesign DMA handling
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Mail Original -----
De: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
À: "Robert Jarzmik" <robert.jarzmik@free.fr>
Cc: ospite@studenti.unina.it, mike@compulab.co.il, "Linux Media Mailing List" <linux-media@vger.kernel.org>
Envoyé: Mercredi 11 Mars 2009 13h22:19 GMT +01:00 Amsterdam / Berlin / Berne / Rome / Stockholm / Vienne
Objet: Re: [PATCH] pxa_camera: Redesign DMA handling

Hi Robert,

On Wed, 4 Mar 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > (moved to the new v4l list)
> >
> >> The DMA transfers in pxa_camera showed some weaknesses in
> >> multiple queued buffers context :
> >>  - poll/select problem
> >>    The order between list pcdev->capture and DMA chain was
> >>    not the same. This creates a discrepancy between video
> >>    buffers marked as "done" by the IRQ handler, and the
> >>    really finished video buffer.
> >
> > Could you please describe where and how the order could get wrong?

> Now after I've explained to you how the present DMA-chaining works, do you 
> still think the order can be swapped? If so, I need a new explanation:-)

Nope. I totally removed that comment from the commit. I only left poll/select
problem, with "select timeout" on capture_example from v4l tree. The buffer
swap must have been my poor understanding of the DMA chain at that time.
I added instead the evolution from "DMA stopped chaining" into "DMA hot chaining"
with fallback path is the chaining was done too late before DMA stopped.

> because, as we now know, this doesn't hold - we just use one (last) dummy 
> descriptor from the new buffer to append it to the current sg_tail, which 
> seems correct to me.
You're right.

Even now I'm on the new DMA handling (your "hot chaining" suggestion), I'm
still thinking about what was wrong with the old code. As you may have seen,
I've asked for help on LAK to understand the DMA controller better.

BTW, I've retouched the comments inside that patch. I wonder if I should let you
make a review of the last posted patch, or repost a full V2 serie after I complete
my full non-regression test cases ?
Either way, I think there will be a third converging iteration (V3).

What do you think is easier for you ?

Cheers.

--
Robert
