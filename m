Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36301 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbbLEVrY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 16:47:24 -0500
Received: by lbblt2 with SMTP id lt2so38126301lbb.3
        for <linux-media@vger.kernel.org>; Sat, 05 Dec 2015 13:47:23 -0800 (PST)
Subject: Re: [PATCH v2 17/32] v4l: vsp1: Fix typo in VI6_DISP_IRQ_STA_DST
 register name
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1449281586-25726-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56635B69.3000800@cogentembedded.com>
Date: Sun, 6 Dec 2015 00:47:21 +0300
MIME-Version: 1.0
In-Reply-To: <1449281586-25726-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12/5/2015 5:12 AM, Laurent Pinchart wrote:

> Rename the VI6_DISP_IRQ_STA_DSE register

    Register bit, perhaps?

> to VI6_DISP_IRQ_STA_DST to fix
> a typo and match the datasheet.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>   drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
> index 25b48738b147..8173ceaab9f9 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -46,7 +46,7 @@
>   #define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << (n))
>
>   #define VI6_DISP_IRQ_STA		0x007c
> -#define VI6_DISP_IRQ_STA_DSE		(1 << 8)
> +#define VI6_DISP_IRQ_STA_DST		(1 << 8)
>   #define VI6_DISP_IRQ_STA_MAE		(1 << 5)
>   #define VI6_DISP_IRQ_STA_LNE(n)		(1 << (n))
>

MBR, Sergei

