Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:52961 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935291AbZJOStA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 14:49:00 -0400
Received: by pzk26 with SMTP id 26so987144pzk.4
        for <linux-media@vger.kernel.org>; Thu, 15 Oct 2009 11:47:48 -0700 (PDT)
To: <santiago.nunez@ridgerun.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
	todd.fischer@ridgerun.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
References: <1255617794-1401-1-git-send-email-santiago.nunez@ridgerun.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Thu, 15 Oct 2009 11:47:46 -0700
In-Reply-To: <1255617794-1401-1-git-send-email-santiago.nunez@ridgerun.com> (santiago nunez's message of "Thu\, 15 Oct 2009 08\:43\:14 -0600")
Message-ID: <87skdk7aul.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<santiago.nunez@ridgerun.com> writes:

> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
>
> This patch provides support for TVP7002 in architecture definitions
> within DM365.
>
> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> ---
>  arch/arm/mach-davinci/board-dm365-evm.c |  170 ++++++++++++++++++++++++++++++-
>  1 files changed, 166 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index a1d5e7d..6c544d3 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -38,6 +38,11 @@
>  #include <mach/common.h>
>  #include <mach/mmc.h>
>  #include <mach/nand.h>
> +#include <mach/gpio.h>
> +#include <linux/videodev2.h>
> +#include <media/tvp514x.h>
> +#include <media/tvp7002.h>
> +#include <media/davinci/videohd.h>
>  
>  
>  static inline int have_imager(void)
> @@ -48,8 +53,11 @@ static inline int have_imager(void)
>  
>  static inline int have_tvp7002(void)
>  {
> -	/* REVISIT when it's supported, trigger via Kconfig */
> +#ifdef CONFIG_VIDEO_TVP7002
> +	return 1;
> +#else
>  	return 0;
> +#endif

I've said this before, but I'll say it again.  I don't like the
#ifdef-on-Kconfig-option here.

Can you add a probe hook to the platform_data so that when the tvp7002
is found it can call pdata->probe() which could then set a flag
for use by have_tvp7002().

This will have he same effect without the ifdef since if the driver
is not compiled in, its probe can never be triggered.

Kevin

