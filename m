Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33351 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbdCFJZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 04:25:51 -0500
Received: by mail-qk0-f182.google.com with SMTP id y76so12472665qkb.0
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 01:24:35 -0800 (PST)
Subject: Re: [PATCH 07/26] brcmsmac: reduce stack size with KASAN
To: Arnd Bergmann <arnd@arndb.de>, kasan-dev@googlegroups.com
References: <20170302163834.2273519-1-arnd@arndb.de>
 <20170302163834.2273519-8-arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <76733196-0948-8cbf-8b74-c1e3687a8c09@broadcom.com>
Date: Mon, 6 Mar 2017 10:16:08 +0100
MIME-Version: 1.0
In-Reply-To: <20170302163834.2273519-8-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2-3-2017 17:38, Arnd Bergmann wrote:
> The wlc_phy_table_write_nphy/wlc_phy_table_read_nphy functions always put an object
> on the stack, which will each require a redzone with KASAN and lead to possible
> stack overflow:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy':
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:17135:1: warning: the frame size of 6312 bytes is larger than 1000 bytes [-Wframe-larger-than=]

Looks like this warning text ended up in the wrong commit message. Got
me confused for a sec :-p

> This marks the two functions as noinline_for_kasan, avoiding the problem entirely.

Frankly I seriously dislike annotating code for the sake of some
(dynamic) memory analyzer. To me the whole thing seems rather
unnecessary. If the code passes the 2048 stack limit without KASAN it
would seem the limit with KASAN should be such that no warning is given.
I suspect that it is rather difficult to predict the additional size of
the instrumentation code and on some systems there might be a real issue
with increased stack usage.

Regards,
Arend

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> index b3aab2fe96eb..42dc8e1f483d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> @@ -14157,7 +14157,7 @@ static void wlc_phy_bphy_init_nphy(struct brcms_phy *pi)
>  	write_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_STEP, 0x668);
>  }
>  
> -void
> +noinline_for_kasan void
>  wlc_phy_table_write_nphy(struct brcms_phy *pi, u32 id, u32 len, u32 offset,
>  			 u32 width, const void *data)
>  {
> @@ -14171,7 +14171,7 @@ wlc_phy_table_write_nphy(struct brcms_phy *pi, u32 id, u32 len, u32 offset,
>  	wlc_phy_write_table_nphy(pi, &tbl);
>  }
>  
> -void
> +noinline_for_kasan void
>  wlc_phy_table_read_nphy(struct brcms_phy *pi, u32 id, u32 len, u32 offset,
>  			u32 width, void *data)
>  {
> 
