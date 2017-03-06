Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752926AbdCFQYc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 11:24:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: kasan-dev@googlegroups.com,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 08/26] brcmsmac: make some local variables 'static const' to reduce stack size
References: <20170302163834.2273519-1-arnd@arndb.de>
        <20170302163834.2273519-9-arnd@arndb.de>
        <227c8e5a-fa20-0300-1cb0-1d3ef17deb19@broadcom.com>
Date: Mon, 06 Mar 2017 18:19:59 +0200
In-Reply-To: <227c8e5a-fa20-0300-1cb0-1d3ef17deb19@broadcom.com> (Arend Van
        Spriel's message of "Mon, 6 Mar 2017 10:30:58 +0100")
Message-ID: <87y3wi74y8.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 2-3-2017 17:38, Arnd Bergmann wrote:
>> With KASAN and a couple of other patches applied, this driver is one
>> of the few remaining ones that actually use more than 2048 bytes of
>> kernel stack:
>> 
>> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy_gainctrl':
>> broadcom/brcm80211/brcmsmac/phy/phy_n.c:16065:1: warning: the frame size of 3264 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy':
>> broadcom/brcm80211/brcmsmac/phy/phy_n.c:17138:1: warning: the frame size of 2864 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>> 
>> Here, I'm reducing the stack size by marking as many local variables as
>> 'static const' as I can without changing the actual code.
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Arnd, via which tree are you planning to submit these? I'm not sure
what I should do with the wireless drivers patches from this series.

-- 
Kalle Valo
