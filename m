Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:24532 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726Ab1BPNQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 08:16:27 -0500
Subject: Re: [PATCH] [media] rc: do not enable remote controller adapters
 by default.
From: Andy Walls <awalls@md.metrocast.net>
To: Stephen Wilson <wilsons@start.ca>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <m3aahwa4ib.fsf@fibrous.localdomain>
References: <m3aahwa4ib.fsf@fibrous.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 08:16:49 -0500
Message-ID: <1297862209.2086.18.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-02-16 at 01:16 -0500, Stephen Wilson wrote:
> Having the RC_CORE config default to INPUT is almost equivalent to
> saying "yes".  Default to "no" instead.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>

I don't particularly like this, if it discourages desktop distributions
from building RC_CORE.  The whole point of RC_CORE in kernel was to have
the remote controllers bundled with TV and DTV cards "just work" out of
the box for end users.  Also the very popular MCE USB receiver device,
shipped with Media Center PC setups, needs it too.

Why exactly do you need it set to "No"?

Regards,
Andy

> ---
>  drivers/media/rc/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 3785162..8842843 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -1,7 +1,7 @@
>  menuconfig RC_CORE
>  	tristate "Remote Controller adapters"
>  	depends on INPUT
> -	default INPUT
> +	default n
>  	---help---
>  	  Enable support for Remote Controllers on Linux. This is
>  	  needed in order to support several video capture adapters.
> --
> 1.7.3.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


