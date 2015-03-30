Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52843 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbbC3MRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 08:17:54 -0400
Date: Mon, 30 Mar 2015 05:17:52 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci@vger.kernel.org,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/6] media/fintek: drop pci_ids dependency
Message-ID: <20150330051752.3923a027@concha.lan>
In-Reply-To: <1427712964-16155-4-git-send-email-mst@redhat.com>
References: <1427712964-16155-1-git-send-email-mst@redhat.com>
	<1427712964-16155-4-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Mar 2015 12:59:32 +0200
"Michael S. Tsirkin" <mst@redhat.com> escreveu:

> This driver does not use any PCI IDs, don't include
> the pci_ids.h header.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Yeah, someone just cut and paste the dependencies from some other IR driver
without checking.

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> ---
>  drivers/media/rc/fintek-cir.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
> index b516757..9ca168a 100644
> --- a/drivers/media/rc/fintek-cir.c
> +++ b/drivers/media/rc/fintek-cir.c
> @@ -33,7 +33,6 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <media/rc-core.h>
> -#include <linux/pci_ids.h>
>  
>  #include "fintek-cir.h"
>  


-- 

Cheers,
Mauro
