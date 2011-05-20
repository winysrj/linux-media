Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41666 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934618Ab1ETOeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 10:34:05 -0400
Received: by bwz15 with SMTP id 15so3011947bwz.19
        for <linux-media@vger.kernel.org>; Fri, 20 May 2011 07:34:02 -0700 (PDT)
Message-ID: <4DD67B68.7070704@mvista.com>
Date: Fri, 20 May 2011 18:32:08 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v17 5/6] davinci vpbe: Build infrastructure for VPBE driver
References: <1305899324-2118-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1305899324-2118-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Manjunath Hadli wrote:

> This patch adds the build infra-structure for Davinci
> VPBE dislay driver.

> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
[...]

> diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
> index 6b19540..a7f11e7 100644
> --- a/drivers/media/video/davinci/Kconfig
> +++ b/drivers/media/video/davinci/Kconfig
> @@ -91,3 +91,25 @@ config VIDEO_ISIF
>  
>  	   To compile this driver as a module, choose M here: the
>  	   module will be called vpfe.
> +
> +config VIDEO_DM644X_VPBE
> +	tristate "DM644X VPBE HW module"

    BTW, as this seems DM644x specific, shouldn't this depend on 
CONFIG_ARCH_DAVINCI_DM644x?

> +	select VIDEO_VPSS_SYSTEM
> +	select VIDEOBUF_DMA_CONTIG
> +	help
> +	    Enables VPBE modules used for display on a DM644x
> +	    SoC.
> +
> +	    To compile this driver as a module, choose M here: the
> +	    module will be called vpbe.
> +
> +
> +config VIDEO_VPBE_DISPLAY
> +	tristate "VPBE V4L2 Display driver"
> +	select VIDEO_DM644X_VPBE

    Or this one, if it selects VIDEO_DM644X_VPBE?

> +	default y

    Hm, "y" shouldn't be the default.

WBR, Sergei
