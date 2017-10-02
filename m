Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdJBNxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 09:53:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v4,
 1/9] brcmsmac: make some local variables 'static const' to reduce
 stack size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170922212930.620249-2-arnd@arndb.de>
References: <20170922212930.620249-2-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <mmarek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, kasan-dev@googlegroups.com,
        linux-kbuild@vger.kernel.org, Jakub Jelinek <jakub@gcc.gnu.org>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <marxin@gcc.gnu.org>
Message-Id: <20171002135348.7AFA560AFB@smtp.codeaurora.org>
Date: Mon,  2 Oct 2017 13:53:48 +0000 (UTC)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> With KASAN and a couple of other patches applied, this driver is one
> of the few remaining ones that actually use more than 2048 bytes of
> kernel stack:
> 
> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy_gainctrl':
> broadcom/brcm80211/brcmsmac/phy/phy_n.c:16065:1: warning: the frame size of 3264 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy':
> broadcom/brcm80211/brcmsmac/phy/phy_n.c:17138:1: warning: the frame size of 2864 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> 
> Here, I'm reducing the stack size by marking as many local variables as
> 'static const' as I can without changing the actual code.
> 
> This is the first of three patches to improve the stack usage in this
> driver. It would be good to have this backported to stabl kernels
> to get all drivers in 'allmodconfig' below the 2048 byte limit so
> we can turn on the frame warning again globally, but I realize that
> the patch is larger than the normal limit for stable backports.
> 
> The other two patches do not need to be backported.
> 
> Cc: <stable@vger.kernel.org>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers.git, thanks.

c503dd38f850 brcmsmac: make some local variables 'static const' to reduce stack size

-- 
https://patchwork.kernel.org/patch/9967145/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
