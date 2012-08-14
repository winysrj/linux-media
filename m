Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:53883 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab2HNGaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 02:30:21 -0400
Date: Tue, 14 Aug 2012 08:30:18 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
In-Reply-To: <5029AC92.2060408@redhat.com>
Message-ID: <alpine.DEB.2.02.1208140819400.1973@localhost6.localdomain6>
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr> <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda> <501FD69D.7070702@metafoo.de> <alpine.DEB.2.02.1208101558100.2011@hadrien> <50295A43.30305@redhat.com>
 <alpine.DEB.2.02.1208132219060.2355@localhost6.localdomain6> <5029AC92.2060408@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Well, I've massively applied hundreds of patches today, but not much
> on this driver. Maybe it is better for you to wait for a couple of
> days for these to be at -next, or use, instead, our tree as the basis for
> it:
> 	git://linuxtv.org/media_tree.git staging/for_v3.7

I cloned this, but it doesn't seem to contain the file:

>:~: cd staging/for_v3.7/
>:for_v3.7: ls drivers/media/video/mx2_emmaprp.c
ls: cannot access drivers/media/video/mx2_emmaprp.c: No such file or 
directory

julia
