Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:49246 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbbJPQF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 12:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <1445011330-22698-1-git-send-email-aryabinin@virtuozzo.com>
References: <20151005110923.GA16831@wfg-t540p.sh.intel.com> <1445011330-22698-1-git-send-email-aryabinin@virtuozzo.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Fri, 16 Oct 2015 19:05:33 +0300
Message-ID: <CAK3bHNWBhSKCLVcJBwsNF6HL3vpGH9dGO2zm_c_v8at1v3BYJw@mail.gmail.com>
Subject: Re: [PATCH] Disable -Wframe-larger-than warnings with KASAN=y
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Acked-by: Abylay Ospan <aospan@netup.ru>



2015-10-16 19:02 GMT+03:00 Andrey Ryabinin <aryabinin@virtuozzo.com>:
> When the kernel compiled with KASAN=y, GCC adds redzones
> for each variable on stack. This enlarges function's stack
> frame and causes:
>         'warning: the frame size of X bytes is larger than Y bytes'
>
> The worst case I've seen for now is following:
>  ../net/wireless/nl80211.c: In function ‘nl80211_send_wiphy’:
>  ../net/wireless/nl80211.c:1731:1: warning: the frame size of 5448 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>   }
>    ^
> That kind of warning becomes useless with KASAN=y. It doesn't necessarily
> indicate that there is some problem in the code, thus we should turn it off.
>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> ---
>  lib/Kconfig.debug | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index ab76b99..1d1521c 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -197,6 +197,7 @@ config ENABLE_MUST_CHECK
>  config FRAME_WARN
>         int "Warn for stack frames larger than (needs gcc 4.4)"
>         range 0 8192
> +       default 0 if KASAN
>         default 1024 if !64BIT
>         default 2048 if 64BIT
>         help
> --
> 2.4.9
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
