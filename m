Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46771 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab1KQKjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:39:05 -0500
Received: by bke11 with SMTP id 11so1792985bke.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 02:39:04 -0800 (PST)
Message-ID: <4EC4E413.3020708@mvista.com>
Date: Thu, 17 Nov 2011 14:38:11 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/5] ARM: davinci: delete individual platform header
 files and use a common header
References: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com> <1321525138-3928-6-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321525138-3928-6-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 17-11-2011 14:18, Manjunath Hadli wrote:

> include davinci_common.h file in files using the platform

   Just davinci.h now.

> header file for dm355, dm365, dm644x and dm646x and delete the
> individual platform header files.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>

> diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
> index 25036cb..1e0fef9 100644
> --- a/drivers/media/video/davinci/vpif.h
> +++ b/drivers/media/video/davinci/vpif.h
> @@ -18,8 +18,7 @@
>
>   #include<linux/io.h>
>   #include<linux/videodev2.h>
> -#include<mach/hardware.h>

    You need to either describe this change, or do it in a sperate patch.

WBR, Sergei
