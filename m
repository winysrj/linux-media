Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.185]:52531 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934544AbdIYOtg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 10:49:36 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Arnd Bergmann' <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Jiri Pirko <jiri@resnulli.us>,
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
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
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
        =?Windows-1252?Q?Martin_Li=9Aka?= <marxin@gcc.gnu.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 4/9] em28xx: fix em28xx_dvb_init for KASAN
Date: Mon, 25 Sep 2017 14:41:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD007F521@AcuExch.aculab.com>
References: <20170922212930.620249-1-arnd@arndb.de>
 <20170922212930.620249-5-arnd@arndb.de>
In-Reply-To: <20170922212930.620249-5-arnd@arndb.de>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann
> Sent: 22 September 2017 22:29
...
> It seems that this is triggered in part by using strlcpy(), which the
> compiler doesn't recognize as copying at most 'len' bytes, since strlcpy
> is not part of the C standard.

Neither is strncpy().

It'll almost certainly be a marker in a header file somewhere,
so it should be possibly to teach it about other functions.

	David
