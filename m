Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44242 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754044AbcKYIuj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 03:50:39 -0500
Date: Fri, 25 Nov 2016 06:50:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jarod Wilson <jarod@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/3] Avoid warnings about using unitialized dest_dir
Message-ID: <20161125065030.25d8d276@vento.lan>
In-Reply-To: <2518391.czCat0C7eD@wuerfel>
References: <20161027150848.3623829-1-arnd@arndb.de>
        <cover.1479567006.git.mchehab@s-opensource.com>
        <2518391.czCat0C7eD@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Nov 2016 17:35:42 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Saturday, November 19, 2016 12:56:57 PM CET Mauro Carvalho Chehab wrote:
> > As Arnd reported:
> > 
> > 	With gcc-5 or higher on x86, we can get a bogus warning in the
> > 	dvb-net code:
> > 
> > 	drivers/media/dvb-core/dvb_net.c: In function ‘dvb_net_ule’:
> > 	arch/x86/include/asm/string_32.h:77:14: error: ‘dest_addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
> > 	drivers/media/dvb-core/dvb_net.c:633:8: note: ‘dest_addr’ was declared here
> > 
> > Inspecting the code is really hard, as the function Arnd patched is really
> > complex.
> > 
> > IMHO, the best is to first simplify the logic, by breaking parts of it into
> > sub-routines, and then apply a proper fix.
> > 
> > This patch series does that.
> > 
> > Arnd,
> > 
> > After splitting the function, I think that the GCC 5 warning is not bogus,
> > as this code:
> > 		skb_copy_from_linear_data(h->priv->ule_skb, dest_addr,
> > 					  ETH_ALEN);
> >
> > is called before initializing dest_dir, but, even if I'm wrong, it is not a bad
> > idea to zero the dest_addr before handing the logic.  
> 
> My conclusion after looking at it for a while was that it is correct, the
> relevant code is roughtly:
> 
> 	if (!priv->ule_dbit) {
> 		drop = ...;
> 		if (drop)
> 			goto done;
> 		else
> 			skb_copy_from_linear_data(priv->ule_skb, dest_addr, ETH_ALEN);
> 	}
> 
> 	...
> 
> 	if (!priv->ule_dbit) {
> 		memcpy(ethh->h_dest, dest_addr, ETH_ALEN)
> 	}
> 
> done:
> 	...
> 
> 
> So it is always copied from the skb data before it gets used.
> 
> > PS.: I took a lot of care to avoid breaking something on this series, as I don't
> > have any means here to test DVB net.  So, I'd appreciate if you could take
> > a look and see if everything looks fine.  
> 
> I have replaced my patch with your series in my randconfig builds and see no
> new warnings so far.
> 
> The first patch looks correct to me, but I can't really verify the
> second one by inspection. It looks like a nice cleanup and I'd assume
> you did it correctly too. The third patch is probably not needed now,
> I think with the 'goto' removed, gcc will be able to figure it out
> already. It probably adds a few extra cycles to copy the zero data,
> which shouldn't be too bad either.

Thanks for looking into it. I'll apply only the first two
patches for now. If gcc starts complaining again, we can apply
it later.


> [btw, your mchehab@s-opensource.com keeps bouncing for me, I had to
>  remove that from Cc to get my reply to make it out]

Gah! I guess I'll need to switch to use some other e-mail instead.
Maybe it is time to use mchehab@kernel.org for everything.

Thanks,
Mauro
