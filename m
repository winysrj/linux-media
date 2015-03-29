Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52807 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbC2PkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 11:40:15 -0400
Date: Sun, 29 Mar 2015 08:40:13 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 82/86] media/fintek: drop pci_ids dependency
Message-ID: <20150329084013.2fe912f4@concha.lan>
In-Reply-To: <1427635734-24786-83-git-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
	<1427635734-24786-83-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 29 Mar 2015 15:43:23 +0200
"Michael S. Tsirkin" <mst@redhat.com> escreveu:

> This driver does not use any PCI IDs, don't include
> the pci_ids.h header.

Please merge the media patches into one. No reason to have this rename
broken into lots of patches.

Thanks,
Mauro

> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/media/rc/fintek-cir.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
> index 4ef500f..9ca168a 100644
> --- a/drivers/media/rc/fintek-cir.c
> +++ b/drivers/media/rc/fintek-cir.c
> @@ -33,7 +33,6 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <media/rc-core.h>
> -#include <uapi/linux/pci_ids.h>
>  
>  #include "fintek-cir.h"
>  


-- 

Cheers,
Mauro
