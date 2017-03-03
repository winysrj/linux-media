Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0105.outbound.protection.outlook.com ([104.47.2.105]:55472
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751333AbdCCNwl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 08:52:41 -0500
Subject: Re: [PATCH 01/26] compiler: introduce noinline_for_kasan annotation
To: Arnd Bergmann <arnd@arndb.de>, <kasan-dev@googlegroups.com>
References: <20170302163834.2273519-1-arnd@arndb.de>
 <20170302163834.2273519-2-arnd@arndb.de>
CC: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <kernel-build-reports@lists.linaro.org>,
        "David S . Miller" <davem@davemloft.net>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <7e7a62de-3b79-6044-72fa-4ade418953d1@virtuozzo.com>
Date: Fri, 3 Mar 2017 16:50:20 +0300
MIME-Version: 1.0
In-Reply-To: <20170302163834.2273519-2-arnd@arndb.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/02/2017 07:38 PM, Arnd Bergmann wrote:
> When CONFIG_KASAN is set, we can run into some code that uses incredible
> amounts of kernel stack:
> 
> drivers/staging/dgnc/dgnc_neo.c:1056:1: error: the frame size of 11112 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
> drivers/media/i2c/cx25840/cx25840-core.c:4960:1: error: the frame size of 94000 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
> drivers/media/dvb-frontends/stv090x.c:3430:1: error: the frame size of 5312 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> 
> This happens when a sanitizer uses stack memory each time an inline function
> gets called. This introduces a new annotation for those functions to make
> them either 'inline' or 'noinline' dependning on the CONFIG_KASAN symbol.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/compiler.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index f8110051188f..56b90897a459 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -416,6 +416,17 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
>   */
>  #define noinline_for_stack noinline
>  
> +/*
> + * CONFIG_KASAN can lead to extreme stack usage with certain patterns when
> + * one function gets inlined many times and each instance requires a stack
> + * ckeck.
> + */
> +#ifdef CONFIG_KASAN
> +#define noinline_for_kasan noinline __maybe_unused


noinline_iff_kasan might be a better name.  noinline_for_kasan gives the impression
that we always noinline function for the sake of kasan, while noinline_iff_kasan
clearly indicates that function is noinline only if kasan is used.

> +#else
> +#define noinline_for_kasan inline
> +#endif
> +
>  #ifndef __always_inline
>  #define __always_inline inline
>  #endif
> 
