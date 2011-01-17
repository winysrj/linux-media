Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57743 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1AQTol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 14:44:41 -0500
Received: by ewy5 with SMTP id 5so2910218ewy.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 11:44:40 -0800 (PST)
Message-ID: <4D349BD6.1080001@mvista.com>
Date: Mon, 17 Jan 2011 22:43:18 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v15 3/3] davinci vpbe: changes to common files
References: <1295273713-15289-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1295273713-15289-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Manjunath Hadli wrote:

> Implemented a common and single mapping for DAVINCI_SYSTEM_MODULE_BASE
> to be used by all davinci platforms.

> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/common.c b/arch/arm/mach-davinci/common.c
> index 1d25573..fa7152d 100644
> --- a/arch/arm/mach-davinci/common.c
> +++ b/arch/arm/mach-davinci/common.c
> @@ -111,7 +111,9 @@ void __init davinci_common_init(struct davinci_soc_info *soc_info)
>  		if (ret != 0)
>  			goto err;
>  	}
> -
> +	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
> +	if (!davinci_sysmodbase)
> +		return;

    This seems pointless check as you'll return anyway. You should probably 
'goto err', not 'return' here.

>  	return;
>  
>  err:

WBR, Sergei

