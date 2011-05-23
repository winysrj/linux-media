Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:51966 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab1EWQif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 12:38:35 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 23 May 2011 22:08:20 +0530
Subject: RE: [PATCH v18 07/13] davinci: move DM64XX_VDD3P3V_PWDN to devices.c
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D09B416@dbde02.ent.ti.com>
References: <1301737380-4288-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1301737380-4288-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Apr 02, 2011 at 15:13:00, Hadli, Manjunath wrote:
> Move the definition of DM64XX_VDD3P3V_PWDN from hardware.h
> to devices.c since it is used only there.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Sekhar Nori <nsekhar@ti.com>

Applying this after updating the patch description to
point out that this also helps rid hardware.h of platform
private stuff..

> ---
>  arch/arm/mach-davinci/devices.c               |    1 +
>  arch/arm/mach-davinci/include/mach/hardware.h |    3 ---
>  2 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index 22ebc64..4e1b663 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -182,6 +182,7 @@ static struct platform_device davinci_mmcsd1_device = {
>  	.resource = mmcsd1_resources,
>  };
>  
> +#define DM64XX_VDD3P3V_PWDN	0x48

.. and moving this to the top of the file.

Thanks,
Sekhar
