Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab1KCSEX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 14:04:23 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA3I4NqG022483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 3 Nov 2011 14:04:23 -0400
Received: from [10.11.11.101] (vpn-11-101.rdu.redhat.com [10.11.11.101])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pA3I4Mkf008885
	for <linux-media@vger.kernel.org>; Thu, 3 Nov 2011 14:04:23 -0400
Message-ID: <4EB2D7A5.1080208@redhat.com>
Date: Thu, 03 Nov 2011 16:04:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] edac: Only build sb_edac on 64-bit
References: <1320343211-10665-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1320343211-10665-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-11-2011 16:00, Mauro Carvalho Chehab escreveu:
> From: Josh Boyer <jwboyer@redhat.com>
> 
> The sb_edac driver is marginally useful on a 32-bit kernel, and
> currently has 64-bit divide compile errors when building that config.
> For now, make this build on only for 64-bit kernels.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Please discard this patch... my fingers just automatically typed "--cc lmml",
as they used to do it most of the time when typing a git send-email command ;)

> ---
>  drivers/edac/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 203361e..5948a21 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -214,7 +214,7 @@ config EDAC_I7300
>  
>  config EDAC_SBRIDGE
>  	tristate "Intel Sandy-Bridge Integrated MC"
> -	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
> +	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
>  	depends on EXPERIMENTAL
>  	help
>  	  Support for error detection and correction the Intel

For the silly patchwork at linuxtv:

Nacked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

(as it doesn't bellong to media stuff ;) )
