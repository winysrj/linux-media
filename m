Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38962 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1AJL3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 06:29:50 -0500
Received: by ewy5 with SMTP id 5so8648782ewy.19
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 03:29:48 -0800 (PST)
Message-ID: <4D2AED69.3060602@mvista.com>
Date: Mon, 10 Jan 2011 14:28:41 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v13 5/8] davinci vpbe: platform specific additions
References: <1294654980-1936-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1294654980-1936-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On 10-01-2011 13:23, Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 9a2376b..3cc5f7c 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
[...]
> @@ -654,6 +655,138 @@ void dm644x_set_vpfe_config(struct vpfe_config *cfg)
[...]
> +
> +#define VPSS_CLKCTL	SYS_VPSS_CLKCTL

    What's the point? Why not just use SYS_VPSS_CLKCTL?

> diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
> index 5a1b26d..46385e7 100644
> --- a/arch/arm/mach-davinci/include/mach/dm644x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm644x.h
[...]
> @@ -40,8 +43,19 @@
>   #define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
>   #define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
>
> +/* VPBE register base addresses */
> +#define DM644X_VENC_REG_BASE		0x01C72400
> +#define DM644X_OSD_REG_BASE		0x01C72600
> +
> +#define OSD_REG_SIZE			0x000001ff
> +#define VENC_REG_SIZE			0x0000017f

    Well, actually that's not the size but "limit" -- sizes should be 0x200 
and 0x180 respectively...

WBR, Sergei
