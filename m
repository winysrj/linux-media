Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58063 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbbKQQ3x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 11:29:53 -0500
Date: Tue, 17 Nov 2015 14:29:48 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com
Subject: Re: [GIT PULL FOR v4.5] Davinci staging fixes
Message-ID: <20151117142948.446851e9@recife.lan>
In-Reply-To: <1523162.9GiZlJHs21@avalon>
References: <1523162.9GiZlJHs21@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 09 Nov 2015 23:27:02 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> I've collected the pending Davinci staging fixes from patchwork and prepared a 
> branch for you.
> 
> Prabhakar, is that fine with you ? Do you still maintain the driver ? If so, 
> do you expect patches to be picked up when you ack them, or can you collect 
> them in a branch somewhere and send a pull request ?

As the patches on this tree are trivial, and one of them has Prabhakar's ack,
I'll apply them, as I'm assuming that they're all ok for Prabhakar.

Please let me know if any of them would be causing any further issues.

Regards,
Mauro

> 
> The following changes since commit 79f5b6ae960d380c829fb67d5dadcd1d025d2775:
> 
>   [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK 
> (2015-10-20 16:02:41 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/pinchartl/media.git davinci
> 
> for you to fetch changes up to b542f513822fd11460ef781742d6c0446b40eeb8:
> 
>   staging: media: davinci_vpfe: fix ipipe_mode type (2015-11-09 23:07:53 
> +0200)
> 
> ----------------------------------------------------------------
> Andrzej Hajda (1):
>       staging: media: davinci_vpfe: fix ipipe_mode type
> 
> Arnd Bergmann (1):
>       staging/davinci/vpfe/dm365: add missing dependencies
> 
> Julia Lawall (1):
>       drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c: use correct 
> structure type name in sizeof
> 
> Junsu Shin (1):
>       staging: media: davinci_vpfe: Fix over 80 characters coding style issue
> 
> Nicholas Mc Guire (1):
>       staging: media: davinci_vpfe: drop condition with no effect
> 
>  drivers/staging/media/davinci_vpfe/Kconfig           | 2 ++
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c     | 5 +++--
>  drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c  | 2 +-
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c   | 7 +------
>  drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 2 +-
>  5 files changed, 8 insertions(+), 10 deletions(-)
> 
