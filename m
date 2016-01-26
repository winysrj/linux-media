Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50741 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060AbcAZJMu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 04:12:50 -0500
Date: Tue, 26 Jan 2016 07:12:42 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: exynos4-is: media-dev: Add missing
 of_node_put
Message-ID: <20160126071242.4a127d3f@recife.lan>
In-Reply-To: <alpine.DEB.2.02.1601260809340.2004@localhost6.localdomain6>
References: <20160125152136.GA19484@amitoj-Inspiron-3542>
	<56A6BCC3.8040407@samsung.com>
	<alpine.DEB.2.02.1601260723290.2004@localhost6.localdomain6>
	<56A7185F.7020207@samsung.com>
	<alpine.DEB.2.02.1601260809340.2004@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Jan 2016 08:12:15 +0100
Julia Lawall <julia.lawall@lip6.fr> escreveu:

> On Tue, 26 Jan 2016, Krzysztof Kozlowski wrote:
> 
> > On 26.01.2016 15:24, Julia Lawall wrote:  
> > > 
> > > 
> > > On Tue, 26 Jan 2016, Krzysztof Kozlowski wrote:
> > >   
> > >> On 26.01.2016 00:21, Amitoj Kaur Chawla wrote:  
> > >>> for_each_available_child_of_node and for_each_child_of_node perform an
> > >>> of_node_get on each iteration, so to break out of the loop an of_node_put is
> > >>> required.
> > >>>
> > >>> Found using Coccinelle. The simplified version of the semantic patch
> > >>> that is used for this is as follows:
> > >>>
> > >>> // <smpl>
> > >>> @@
> > >>> local idexpression n;
> > >>> expression e,r;
> > >>> @@
> > >>>
> > >>>  for_each_available_child_of_node(r,n) {
> > >>>    ...
> > >>> (
> > >>>    of_node_put(n);
> > >>> |
> > >>>    e = n
> > >>> |
> > >>> +  of_node_put(n);
> > >>> ?  break;
> > >>> )
> > >>>    ...
> > >>>  }
> > >>> ... when != n
> > >>> // </smpl>  
> > >>
> > >> Patch iselft looks correct but why are you pasting coccinelle script
> > >> into the message?
> > >>
> > >> The script is already present in Linux kernel:
> > >> scripts/coccinelle/iterators/device_node_continue.cocci  
> > > 
> > > I don't think so.  The continue one takes care of the case where there is 
> > > an extraneous of_node_put before a continue, not a missing one before a 
> > > break.  But OK to drop it if it doesn't seem useful.
> > > 
> > > julia  
> > 
> > You are right - this is not covered by that cocci patch... but I think
> > is covered by scripts/coccinelle/iterators/fen.cocci, isn't it?  
> 
> Not quite. 

If the script is not part of the Kernel, please keep the script in the
patch, as it could be useful in some future.

Regards,
Mauro
