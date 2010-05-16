Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0EPByt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 21:54:49 -0400
Message-ID: <4BEF5060.5050105@infradead.org>
Date: Sat, 15 May 2010 22:54:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: linux-next@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
	linuxppc-dev@ozlabs.org, David H?rdeman <david@hardeman.nu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-mips@linux-mips.org,
	linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH] media/IR: Add missing include file to rc-map.c
References: <201005051720.22617.PeterHuewe@gmx.de> <201005112042.14889.PeterHuewe@gmx.de> <20100514060240.GD12002@linux-sh.org> <201005141326.52099.PeterHuewe@gmx.de>
In-Reply-To: <201005141326.52099.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch adds a missing include linux/delay.h to prevent
> build failures[1-5]
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> Forwarded to linux-next mailing list - 
> breakage still exists in linux-next of 20100514 - please apply
> 
> KernelVersion: linux-next-20100505

Sorry for not answer earlier. I was traveling. Anyway, this
patch got applied on May, 12:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commitdiff;h=4ace7aa2998b2974948f1948a61a5d348ddae472

> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2571452/
> [2] http://kisskb.ellerman.id.au/kisskb/buildresult/2571188/
> [3] http://kisskb.ellerman.id.au/kisskb/buildresult/2571479/
> [4] http://kisskb.ellerman.id.au/kisskb/buildresult/2571429/
> [5] http://kisskb.ellerman.id.au/kisskb/buildresult/2571432/
> 
> drivers/media/IR/rc-map.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
> index caf6a27..46a8f15 100644
> --- a/drivers/media/IR/rc-map.c
> +++ b/drivers/media/IR/rc-map.c
> @@ -14,6 +14,7 @@
>  
>  #include <media/ir-core.h>
>  #include <linux/spinlock.h>
> +#include <linux/delay.h>
>  
>  /* Used to handle IR raw handler extensions */
>  static LIST_HEAD(rc_map_list);


-- 

Cheers,
Mauro
