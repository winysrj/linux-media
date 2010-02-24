Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64579 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0BXCDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 21:03:46 -0500
Message-ID: <4B8488FA.90103@gmail.com>
Date: Wed, 24 Feb 2010 10:03:38 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH - next] MAINTAINERS: Telegent tlg2300 section fix
References: <1266944900.9265.28.camel@Joe-Laptop.home>
In-Reply-To: <1266944900.9265.28.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

thanks.

Acked-by: Huang Shijie <shijie8@gmail.com>
> linux-next commit 2ff8223957d901999bf76aaf2c6183e33a6ad14e
> exposes an infinite loop defect in scripts/get_maintainer.pl
>
> Fix the incorrect format of the MAINTAINERS "M:" entries.
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 57305f6..e633460 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4775,13 +4775,12 @@ F:	drivers/media/video/*7146*
>   F:	include/media/*7146*
>
>   TLG2300 VIDEO4LINUX-2 DRIVER
> -M 	Huang Shijie	<shijie8@gmail.com>
> -M 	Kang Yong	<kangyong@telegent.com>
> -M 	Zhang Xiaobing	<xbzhang@telegent.com>
> +M:	Huang Shijie<shijie8@gmail.com>
> +M:	Kang Yong<kangyong@telegent.com>
> +M:	Zhang Xiaobing<xbzhang@telegent.com>
>   S:	Supported
>   F:	drivers/media/video/tlg2300
>
> -
>   SC1200 WDT DRIVER
>   M:	Zwane Mwaikambo<zwane@arm.linux.org.uk>
>   S:	Maintained
>
>
>
>    

