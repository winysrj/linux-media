Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1KXRot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 12:44:49 -0500
Message-ID: <4ECE828D.4020507@infradead.org>
Date: Thu, 24 Nov 2011 15:44:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: ir-sanyo-decoder.c doesn't compile
References: <201111241347.51635.hverkuil@xs4all.nl>
In-Reply-To: <201111241347.51635.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-11-2011 10:47, Hans Verkuil escreveu:
> I get this error when compiling for_v3.3:
> 
> drivers/media/rc/ir-sanyo-decoder.c:201:16: error: expected declaration specifiers or ‘...’ before string constant
> drivers/media/rc/ir-sanyo-decoder.c:202:15: error: expected declaration specifiers or ‘...’ before string constant
> drivers/media/rc/ir-sanyo-decoder.c:203:15: error: expected declaration specifiers or ‘...’ before string constant
> drivers/media/rc/ir-sanyo-decoder.c:204:20: error: expected declaration specifiers or ‘...’ before string constant
> 
> There is a include <linux/module.h> missing.
> 
> This patch fixes this:

Thanks for noticing it. It is likely due to the merge from 3.3-rc2. Anyway, applied.

> 
> diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
> index 1646730..d38fbdd 100644
> --- a/drivers/media/rc/ir-sanyo-decoder.c
> +++ b/drivers/media/rc/ir-sanyo-decoder.c
> @@ -21,6 +21,7 @@
>   * Information for this protocol is available at the Sanyo LC7461 datasheet.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/bitrev.h>
>  #include "rc-core-priv.h"
>  
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Regards,
> 
> 	Hans

