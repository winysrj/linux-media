Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64125 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1AGN6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 08:58:44 -0500
Received: by ewy5 with SMTP id 5so7803469ewy.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 05:58:43 -0800 (PST)
Message-ID: <4D271BD1.30405@mvista.com>
Date: Fri, 07 Jan 2011 16:57:37 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-arm-kernel@listinfradead.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v12 5/8] davinci vpbe: platform specific additions
References: <1294407622-25670-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1294407622-25670-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On 07-01-2011 16:40, Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
> index 5a1b26d..b59591c 100644
> --- a/arch/arm/mach-davinci/include/mach/dm644x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm644x.h
> @@ -6,8 +6,7 @@
>    *
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> + * the Free Software Foundation; either version 2 of the License.

    Unfinished sentence. Did you intend to changed the license to GPL 2 only?
If so, it's worth mentioning in the changelog...

[...]
> @@ -40,8 +43,21 @@
>   #define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
>   #define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
>
> +/* VPBE register base addresses */
> +#define DM644X_VENC_REG_BASE		0x01C72400

    You defined the macro but don't use it...

> +#define DM644X_VPBE_REG_BASE		0x01C72780
> +
> +#define DM644X_OSD_REG_BASE		0x01C72600

    Same comment...

> +#define DM644X_VPBE_REG_BASE		0x01C72780

    This is duplicate.

> +
> +#define OSD_REG_SIZE			0x00000100

    Your OSD platform device however has its resource of size 0x200...

> +/* SYS register addresses */
> +#define SYS_VPSS_CLKCTL			0x01C40044

    You've already #define'd and used VPSS_CLKCTL -- this is duplicate/unused.

WBR, Sergei
