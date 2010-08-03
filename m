Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:59425 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0HCSa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 14:30:26 -0400
Date: Tue, 3 Aug 2010 11:28:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, hpa@zytor.com,
	David =?ISO-8859-1?Q?H=E4rdem?= =?ISO-8859-1?Q?an?=
	<david@hardeman.nu>, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] V4L/DVB: ir-code: Add missing "select BITREVERSE"
Message-Id: <20100803112824.874be724.randy.dunlap@oracle.com>
In-Reply-To: <1280859508-25357-1-git-send-email-hpa@linux.intel.com>
References: <1280859508-25357-1-git-send-email-hpa@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue,  3 Aug 2010 11:18:28 -0700 H. Peter Anvin wrote:

> The Sony and JVC IR drivers use bitreverse but don't properly encode
> the dependency.
> 
> Found by randconfig builds.

Hi,

These are already merged into linux-next... and Mauro has sent a pull request
that includes these patches.


> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: David Härdeman <david@hardeman.nu>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/IR/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
> index d22a8ec..6cd93b4 100644
> --- a/drivers/media/IR/Kconfig
> +++ b/drivers/media/IR/Kconfig
> @@ -42,6 +42,7 @@ config IR_RC6_DECODER
>  config IR_JVC_DECODER
>  	tristate "Enable IR raw decoder for the JVC protocol"
>  	depends on IR_CORE
> +	select BITREVERSE
>  	default y
>  
>  	---help---
> @@ -51,6 +52,7 @@ config IR_JVC_DECODER
>  config IR_SONY_DECODER
>  	tristate "Enable IR raw decoder for the Sony protocol"
>  	depends on IR_CORE
> +	select BITREVERSE
>  	default y
>  
>  	---help---
> -- 
> 1.7.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
