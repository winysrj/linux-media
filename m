Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2I0IIz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 04:08:55 -0400
Date: Thu, 27 Sep 2012 05:08:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Damien Bally <biribi@free.fr>
Cc: linux-media@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: Cinergy T Stick Dual RC (rev. 2)
Message-ID: <20120927050850.1549e936@redhat.com>
In-Reply-To: <50575DDC.8020805@free.fr>
References: <50575DDC.8020805@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Damien,

Em Mon, 17 Sep 2012 19:29:00 +0200
Damien Bally <biribi@free.fr> escreveu:

> Hello
> 
> I bought this card because it is supported since kernel 2.6.37 according 
> to this page :
> 
> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_Dual_RC
> 
> As it it was not recognized by OpenSuse 11.4 (the kernel just sees a 
> keyboard) I googled a while and found that rev.2 was not (and noticed 
> the little sticker on my device confirming it).
> 
> According to this page : 
> http://ein-eike.de/2012/08/07/terratec-cinergy-t-stick-dual-rc-revision-2 the 
> device contains it9133 and it9137 chips which are supported since 3.4 
> kernels. So I patched and compiled successfully the last linux-media 
> sources and intalled the adhoc firmwares.
> 
> It seems to work quite well with VDR : I managed to record 
> simultaneously 2 streams on different transponders while watching live 
> TV, but I haven't yet tested the remote control part.

In order to submit a patch, it needs to be at the diff -p1 format, e. g.
the patches should be like:
	something/drivers/media/.../it913x.c

Also, you need to add your Signed-Off-By at the email [1]. You should also
copy the driver maintainer (Malcolm Priestley <tvboxspy@gmail.com>) as
I generally expect him to pick those patches, and submit them to me.
Well, this one in particular is trivial, as it is just a new USB ID addition,
so I generally just apply those kind of patches directly, if the driver maintainer
didn't get it before me.

So, could you please fix those issues and resent the patch?

Thanks,
Mauro

[1] See: http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

