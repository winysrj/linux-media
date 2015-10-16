Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27557 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbbJPQrB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 12:47:01 -0400
Date: Fri, 16 Oct 2015 09:47:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	linux-media@vger.kernel.org, Abylay Ospan <aospan@netup.ru>
Subject: Re: [PATCH] Disable -Wframe-larger-than warnings with KASAN=y
Message-ID: <20151016164700.GC15102@tassilo.jf.intel.com>
References: <20151005110923.GA16831@wfg-t540p.sh.intel.com>
 <1445011330-22698-1-git-send-email-aryabinin@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1445011330-22698-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 16, 2015 at 07:02:10PM +0300, Andrey Ryabinin wrote:
> When the kernel compiled with KASAN=y, GCC adds redzones
> for each variable on stack. This enlarges function's stack
> frame and causes:
> 	'warning: the frame size of X bytes is larger than Y bytes'
> 
> The worst case I've seen for now is following:
>  ../net/wireless/nl80211.c: In function ‘nl80211_send_wiphy’:
>  ../net/wireless/nl80211.c:1731:1: warning: the frame size of 5448 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>   }
>    ^
> That kind of warning becomes useless with KASAN=y. It doesn't necessarily
> indicate that there is some problem in the code, thus we should turn it off.

If KASAN is really bloating the stack that much you may need to consider
increasing the stack size with KASAN on. We have 16K now, but even that
may not be enough if you more than double it.

Otherwise it may just crash with KASAN on in more complex setups.

-Andi
