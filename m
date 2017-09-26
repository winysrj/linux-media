Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:38824 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965865AbdIZGcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 02:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD007F521@AcuExch.aculab.com>
References: <20170922212930.620249-1-arnd@arndb.de> <20170922212930.620249-5-arnd@arndb.de>
 <063D6719AE5E284EB5DD2968C1650D6DD007F521@AcuExch.aculab.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 25 Sep 2017 23:32:08 -0700
Message-ID: <CAK8P3a1zxjMsQTBPijCo8FJjEU5aRVTr7n_NZ1YM2UnDPKoRLw@mail.gmail.com>
Subject: Re: [PATCH v4 4/9] em28xx: fix em28xx_dvb_init for KASAN
To: David Laight <David.Laight@aculab.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        =?UTF-8?Q?Martin_Li=C5=A1ka?= <marxin@gcc.gnu.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 25, 2017 at 7:41 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Arnd Bergmann
>> Sent: 22 September 2017 22:29
> ...
>> It seems that this is triggered in part by using strlcpy(), which the
>> compiler doesn't recognize as copying at most 'len' bytes, since strlcpy
>> is not part of the C standard.
>
> Neither is strncpy().
>
> It'll almost certainly be a marker in a header file somewhere,
> so it should be possibly to teach it about other functions.

I'm currently travelling and haven't investigated in detail, but from
taking a closer look here, I found that the hardened 'strlcpy()'
in include/linux/string.h triggers it. There is also a hardened
(much shorted) 'strncpy()' that doesn't trigger it in the same file,
and having only the extern declaration of strncpy also doesn't.

        Arnd
