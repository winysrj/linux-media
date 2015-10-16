Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34417 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbbJPRTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 13:19:50 -0400
In-Reply-To: <20151016164700.GC15102@tassilo.jf.intel.com>
References: <20151005110923.GA16831@wfg-t540p.sh.intel.com> <1445011330-22698-1-git-send-email-aryabinin@virtuozzo.com> <20151016164700.GC15102@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] Disable -Wframe-larger-than warnings with KASAN=y
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Fri, 16 Oct 2015 20:19:43 +0300
To: Andi Kleen <ak@linux.intel.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	linux-media@vger.kernel.org, Abylay Ospan <aospan@netup.ru>
Message-ID: <41FD6932-707C-4702-A4A9-8B8B51618048@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



16 октября 2015 г. 19:47:00 GMT+03:00, Andi Kleen <ak@linux.intel.com> пишет:
>On Fri, Oct 16, 2015 at 07:02:10PM +0300, Andrey Ryabinin wrote:
>> When the kernel compiled with KASAN=y, GCC adds redzones
>> for each variable on stack. This enlarges function's stack
>> frame and causes:
>> 	'warning: the frame size of X bytes is larger than Y bytes'
>> 
>> The worst case I've seen for now is following:
>>  ../net/wireless/nl80211.c: In function ‘nl80211_send_wiphy’:
>>  ../net/wireless/nl80211.c:1731:1: warning: the frame size of 5448
>bytes is larger than 2048 bytes [-Wframe-larger-than=]
>>   }
>>    ^
>> That kind of warning becomes useless with KASAN=y. It doesn't
>necessarily
>> indicate that there is some problem in the code, thus we should turn
>it off.
>
>If KASAN is really bloating the stack that much you may need to
>consider
>increasing the stack size with KASAN on. We have 16K now, but even that
>may not be enough if you more than double it.
>

Such huge bloat only in a few places, anyway it's done already. Stack is 32k with kasan.

>Otherwise it may just crash with KASAN on in more complex setups.
>
>-Andi
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

