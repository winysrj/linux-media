Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60784 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab1KOKzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 05:55:43 -0500
Received: by bke11 with SMTP id 11so6991397bke.19
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2011 02:55:42 -0800 (PST)
Message-ID: <4EC244F9.1030604@mvista.com>
Date: Tue, 15 Nov 2011 14:54:49 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 5/5] davinci: delete individual platform header files
 and use a common header
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com> <1321283357-27698-6-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321283357-27698-6-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 14-11-2011 19:09, Manjunath Hadli wrote:

> include davinci_common.h file in files using the platform
> header file for dm355, dm365, dm644x and dm646x and delete the
> individual platform header files.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
[...]

> diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
> index 25036cb..73b00bd 100644
> --- a/drivers/media/video/davinci/vpif.h
> +++ b/drivers/media/video/davinci/vpif.h
> @@ -18,8 +18,7 @@
>
>   #include<linux/io.h>
>   #include<linux/videodev2.h>
> -#include<mach/hardware.h>

    Why are you removing this?

> -#include<mach/dm646x.h>
> +#include<mach/davinci_common.h>
>   #include<media/davinci/vpif_types.h>
>
>   /* Maximum channel allowed */
> diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
> index a693d4e..c019d26 100644
> --- a/drivers/media/video/davinci/vpif_capture.h
> +++ b/drivers/media/video/davinci/vpif_capture.h
> @@ -27,6 +27,7 @@
>   #include<media/v4l2-device.h>
>   #include<media/videobuf-core.h>
>   #include<media/videobuf-dma-contig.h>
> +#include<mach/davinci_common.h>

    Not clear why are you adding this when no platform header was included before.

WBR, Sergei

