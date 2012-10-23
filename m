Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62989 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2JWJtb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 05:49:31 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so2201308lag.19
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2012 02:49:30 -0700 (PDT)
Message-ID: <508667E3.4000509@mvista.com>
Date: Tue, 23 Oct 2012 13:48:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH RESEND] ARM: dm365: replace V4L2_OUT_CAP_CUSTOM_TIMINGS
 with V4L2_OUT_CAP_DV_TIMINGS
References: <1350907972-11256-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1350907972-11256-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 22-10-2012 16:12, Prabhakar Lad wrote:

> From: Lad, Prabhakar <prabhakar.lad@ti.com>

> This patch replaces V4L2_OUT_CAP_CUSTOM_TIMINGS macro with
> V4L2_OUT_CAP_DV_TIMINGS. As V4L2_OUT_CAP_CUSTOM_TIMINGS is being phased
> out.

> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> ---
>   Resending the patch since, it didn't reach the DLOS mailing list.

>   This patch is based on the following patch series,
>   ARM: davinci: dm365 EVM: add support for VPBE display
>   (https://patchwork.kernel.org/patch/1295071/)

>   arch/arm/mach-davinci/board-dm365-evm.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index 2924d61..771abb5 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -514,7 +514,7 @@ static struct vpbe_output dm365evm_vpbe_outputs[] = {
>   			.index		= 1,
>   			.name		= "Component",
>   			.type		= V4L2_OUTPUT_TYPE_ANALOG,
> -			.capabilities	= V4L2_OUT_CAP_CUSTOM_TIMINGS,
> +			.capabilities	=  V4L2_OUT_CAP_DV_TIMINGS,

    Why this extra space after '='?

WBR, Sergei

