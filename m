Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40918
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751015AbcK1ToX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 14:44:23 -0500
Date: Mon, 28 Nov 2016 17:44:14 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        LMML <linux-media@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [GIT PULL] Samsung fixes for 4.8
Message-ID: <20161128174414.1ab8cb7e@vento.lan>
In-Reply-To: <d56c3d6d-6cbf-2f98-80d8-c72cd20f3957@osg.samsung.com>
References: <CGME20160916133335eucas1p2417ec5672f250c3eaca8e424293ce783@eucas1p2.samsung.com>
        <8001c83d-0e3a-61cb-bf53-8c2b497bd0ed@samsung.com>
        <20161021102607.2df96630@vento.lan>
        <70cc3f35-e661-c76f-8620-dfeb74030183@samsung.com>
        <20161116124600.66e4c9e4@vento.lan>
        <d9d745c8-3128-c637-1fa7-c46606fca2af@samsung.com>
        <20161116131932.7c2908e3@vento.lan>
        <d56c3d6d-6cbf-2f98-80d8-c72cd20f3957@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Nov 2016 16:29:25 -0300
Javier Martinez Canillas <javier@osg.samsung.com> escreveu:

> Hello Mauro,
> 
> On 11/16/2016 12:19 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 16 Nov 2016 16:08:19 +0100
> > Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:
> >   
> >> On 11/16/2016 03:46 PM, Mauro Carvalho Chehab wrote:  
> >>>>>> Marek Szyprowski (1):    
> >>>>>>>>>       s5p-mfc: fix failure path of s5p_mfc_alloc_memdev()      
> >>>>>
> >>>>> Mauro, this patch seems to had slipped through the cracks, I can't see it
> >>>>> in neither media fixes nor the master branch. Could you please check it?    
> >>>
> >>> The patch seems to be on my tree:    
> >>  
> 
> This patch is indeed in your tree as commit:
> 
> https://git.linuxtv.org/media_tree.git/commit/?id=3467c9a7e7f9
> 
> and also in present in the media/v4.9-2 tag.
> 
> But the patch never made to mainline. In fact, I don't see any of the
> patches in the media/v4.9-2 tag to be merged in v4.9-rc7.

It is part of a group of 187 patches for Kernel 4.10. There aren't
anything there that fixes a regression on 4.8 or 4.9. So, no
hush.

I double-checked and all the patches at media/v4.9-2 are there at
media master. So, should be sent to 4.10.

Regards,
Mauro
