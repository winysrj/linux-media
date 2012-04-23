Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:64019 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2DWQQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 12:16:41 -0400
Date: Mon, 23 Apr 2012 09:16:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Johann Deneux <johann.deneux@gmail.comx>,
	Anssi Hannula <anssi.hannula@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 2/3] Input: move drivers/input/fixp-arith.h to
 include/linux
Message-ID: <20120423161633.GA29290@core.coreip.homeip.net>
References: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
 <1335187267-27940-3-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335187267-27940-3-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2012 at 03:21:06PM +0200, Antonio Ospite wrote:
> Move drivers/input/fixp-arith.h to include/linux so that the functions
> defined there can be used by other subsystems, for instance some video
> devices ISPs can control the output HUE value by setting registers for
> sin(HUE) and cos(HUE).
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  drivers/input/ff-memless.c                    |    3 +--
>  {drivers/input => include/linux}/fixp-arith.h |    0
>  2 files changed, 1 insertion(+), 2 deletions(-)
>  rename {drivers/input => include/linux}/fixp-arith.h (100%)
> 
> diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
> index 117a59a..5f55885 100644
> --- a/drivers/input/ff-memless.c
> +++ b/drivers/input/ff-memless.c
> @@ -31,8 +31,7 @@
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
>  #include <linux/jiffies.h>
> -
> -#include "fixp-arith.h"
> +#include <linux/fixp-arith.h>
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Anssi Hannula <anssi.hannula@gmail.com>");
> diff --git a/drivers/input/fixp-arith.h b/include/linux/fixp-arith.h
> similarity index 100%
> rename from drivers/input/fixp-arith.h
> rename to include/linux/fixp-arith.h
> -- 
> 1.7.10
> 

-- 
Dmitry
