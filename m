Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34517 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753672AbdCFVey (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 16:34:54 -0500
MIME-Version: 1.0
In-Reply-To: <87y3wi74y8.fsf@purkki.adurom.net>
References: <20170302163834.2273519-1-arnd@arndb.de> <20170302163834.2273519-9-arnd@arndb.de>
 <227c8e5a-fa20-0300-1cb0-1d3ef17deb19@broadcom.com> <87y3wi74y8.fsf@purkki.adurom.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 6 Mar 2017 22:34:12 +0100
Message-ID: <CAK8P3a0cemG0=6jZOQEpGN+RG2Be1LM_DE7aJVX18en_i6G7=Q@mail.gmail.com>
Subject: Re: [PATCH 08/26] brcmsmac: make some local variables 'static const'
 to reduce stack size
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 6, 2017 at 5:19 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 2-3-2017 17:38, Arnd Bergmann wrote:
>>> With KASAN and a couple of other patches applied, this driver is one
>>> of the few remaining ones that actually use more than 2048 bytes of
>>> kernel stack:
>>>
>>> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy_gainctrl':
>>> broadcom/brcm80211/brcmsmac/phy/phy_n.c:16065:1: warning: the frame size of 3264 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>>> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy':
>>> broadcom/brcm80211/brcmsmac/phy/phy_n.c:17138:1: warning: the frame size of 2864 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>>>
>>> Here, I'm reducing the stack size by marking as many local variables as
>>> 'static const' as I can without changing the actual code.
>>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
> Arnd, via which tree are you planning to submit these? I'm not sure
> what I should do with the wireless drivers patches from this series.

I'm not quite sure myself yet. I'd probably want the first few patches that
do most of the work get merged through Andrew's linux-mm tree once
we have come to agreement on them. The driver specific patches like
the brcmsmac ones depend on the introduction of noinline_for_kasan
or noinline_if_stackbloat and could either go in along with the first
set, or as a follow-up through the normal maintainer trees.

       Arnd
