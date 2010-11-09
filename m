Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40131 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0KIOxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 09:53:15 -0500
Received: by ewy7 with SMTP id 7so3573655ewy.19
        for <linux-media@vger.kernel.org>; Tue, 09 Nov 2010 06:53:14 -0800 (PST)
Message-ID: <4CD96006.8010301@mvista.com>
Date: Tue, 09 Nov 2010 17:51:50 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 6/6] davinci vpbe: Build infrastructure for VPBE driver
References: <1289228157-5366-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1289228157-5366-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Manjunath Hadli wrote:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>

> This patch adds the build infra-structure for Davinci
> VPBE dislay driver.

> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
[...]

> diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
> index 6b19540..dab32d5 100644
> --- a/drivers/media/video/davinci/Kconfig
> +++ b/drivers/media/video/davinci/Kconfig
> @@ -91,3 +91,25 @@ config VIDEO_ISIF
>  
>  	   To compile this driver as a module, choose M here: the
>  	   module will be called vpfe.
> +
> +config VIDEO_DM644X_VPBE
> +        tristate "DM644X VPBE HW module"
> +        select VIDEO_VPSS_SYSTEM
> +	select VIDEOBUF_DMA_CONTIG
> +        help

    Please use tabs for indentation uniformly.

WBR, Sergei

