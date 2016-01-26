Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:30312 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbcAZHMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 02:12:19 -0500
Date: Tue, 26 Jan 2016 08:12:15 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	mchehab@osg.samsung.com, kgene@kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: exynos4-is: media-dev: Add missing
 of_node_put
In-Reply-To: <56A7185F.7020207@samsung.com>
Message-ID: <alpine.DEB.2.02.1601260809340.2004@localhost6.localdomain6>
References: <20160125152136.GA19484@amitoj-Inspiron-3542> <56A6BCC3.8040407@samsung.com> <alpine.DEB.2.02.1601260723290.2004@localhost6.localdomain6> <56A7185F.7020207@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 26 Jan 2016, Krzysztof Kozlowski wrote:

> On 26.01.2016 15:24, Julia Lawall wrote:
> > 
> > 
> > On Tue, 26 Jan 2016, Krzysztof Kozlowski wrote:
> > 
> >> On 26.01.2016 00:21, Amitoj Kaur Chawla wrote:
> >>> for_each_available_child_of_node and for_each_child_of_node perform an
> >>> of_node_get on each iteration, so to break out of the loop an of_node_put is
> >>> required.
> >>>
> >>> Found using Coccinelle. The simplified version of the semantic patch
> >>> that is used for this is as follows:
> >>>
> >>> // <smpl>
> >>> @@
> >>> local idexpression n;
> >>> expression e,r;
> >>> @@
> >>>
> >>>  for_each_available_child_of_node(r,n) {
> >>>    ...
> >>> (
> >>>    of_node_put(n);
> >>> |
> >>>    e = n
> >>> |
> >>> +  of_node_put(n);
> >>> ?  break;
> >>> )
> >>>    ...
> >>>  }
> >>> ... when != n
> >>> // </smpl>
> >>
> >> Patch iselft looks correct but why are you pasting coccinelle script
> >> into the message?
> >>
> >> The script is already present in Linux kernel:
> >> scripts/coccinelle/iterators/device_node_continue.cocci
> > 
> > I don't think so.  The continue one takes care of the case where there is 
> > an extraneous of_node_put before a continue, not a missing one before a 
> > break.  But OK to drop it if it doesn't seem useful.
> > 
> > julia
> 
> You are right - this is not covered by that cocci patch... but I think
> is covered by scripts/coccinelle/iterators/fen.cocci, isn't it?

Not quite.  That is for of_node_puts after normal loop completion (not 
sure that this problem comes up any more, but at one point there were a 
number of them). There are indeed a lot of ways in which the management of 
reference counts can go wrong...

Anyway, the rule that Amitoj used seems to be pretty reliable, so I'll try 
to get it into the kernel source tree some day soon.

julia

> 
> BR,
> Krzysztof
> 
> > 
> >> This just extends the commit message without any meaningful data so with
> >> removal of coccinelle script above:
> >> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >>
> >> Best regards,
> >> Krzysztof
> >>
> >>>
> >>> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
> >>> ---
> >>>  drivers/media/platform/exynos4-is/media-dev.c | 12 +++++++++---
> >>>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> 
