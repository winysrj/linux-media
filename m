Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45580 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3DUTR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:17:29 -0400
Received: by mail-lb0-f176.google.com with SMTP id y8so4964608lbh.7
        for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 12:17:27 -0700 (PDT)
Message-ID: <51743B15.4000107@cogentembedded.com>
Date: Sun, 21 Apr 2013 23:16:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: linux-media@vger.kernel.org, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v2 4/5] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support
References: <201304212242.39693.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304212242.39693.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/21/2013 10:42 PM, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> Add ML86V7667 platform devices on BOCK-W board, configure VIN0/1 pins, and
> register VIN0/1 devices with the ML86V7667 specific platform data.
>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: some macro/comment cleanup; updated the copyrights.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>
> ---
>   arch/arm/mach-shmobile/board-bockw.c |   40 +++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
>
> Index: renesas/arch/arm/mach-shmobile/board-bockw.c
> ===================================================================
> --- renesas.orig/arch/arm/mach-shmobile/board-bockw.c
> +++ renesas/arch/arm/mach-shmobile/board-bockw.c

[...]

> @@ -23,6 +24,8 @@
>   #include <linux/regulator/fixed.h>
>   #include <linux/regulator/machine.h>
>   #include <linux/smsc911x.h>
> +#include <linux/pinctrl/machine.h>

    Noticed just now: this #include is duplicate. It seems I was too 
fast in resending
the series...

WBR, Sergei

