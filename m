Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40921 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756615AbdIHSwt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 14:52:49 -0400
Date: Fri, 8 Sep 2017 19:52:47 +0100
From: Sean Young <sean@mess.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH] media: default for RC_CORE should be n
Message-ID: <20170908185247.un3c7bjnety6uja3@gofer.mess.org>
References: <20170908163929.9277-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908163929.9277-1-sthemmin@microsoft.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 08, 2017 at 09:39:29AM -0700, Stephen Hemminger wrote:
> The Linus policy on Kconfig is that the default should be no
> for all new devices. I.e the user rebuild a new kernel from an
> old config should not by default get a larger kernel.

That might make sense for new config, but RC_CORE has been present for
7 years; I don't see how changing defaults for existing config makes
sense.


Sean

> 
> Fixes: b4c184e506a4 ("[media] media: reorganize the main Kconfig items")
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> ---
>  drivers/media/rc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index d9ce8ff55d0c..5aa384afcfef 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -2,7 +2,7 @@
>  menuconfig RC_CORE
>  	tristate "Remote Controller support"
>  	depends on INPUT
> -	default y
> +	default n
>  	---help---
>  	  Enable support for Remote Controllers on Linux. This is
>  	  needed in order to support several video capture adapters,
> -- 
> 2.11.0
