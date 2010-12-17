Return-path: <mchehab@gaivota>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:53139 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab0LQQap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 11:30:45 -0500
Received: by ewy10 with SMTP id 10so410166ewy.4
        for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 08:30:44 -0800 (PST)
Message-ID: <4D0B8FE3.3080502@mvista.com>
Date: Fri, 17 Dec 2010 19:29:23 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v7 5/8] davinci vpbe: board specific additions
References: <1292507737-32739-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1292507737-32739-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello.

Manjunath Hadli wrote:

> This patch implements tables for display timings,outputs and
> other board related functionalities.

> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index 34c8b41..e9b1243 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
[...]
> @@ -620,6 +671,8 @@ davinci_evm_map_io(void)
>  {
>  	/* setup input configuration for VPFE input devices */
>  	dm644x_set_vpfe_config(&vpfe_cfg);
> +	/* setup configuration for vpbe devices */
> +	dm644x_set_vpbe_display_config(&vpbe_display_cfg);
>  	dm644x_init();
>  }

    This patch should *follow* the platform patch (where 
dm644x_set_vpbe_display_config() is defined), not precede it.

WBR, Sergei
