Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34466 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753315AbdCFLQX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 06:16:23 -0500
MIME-Version: 1.0
In-Reply-To: <2dd6ce84-0285-b4c1-97d4-bb41a6ffec04@broadcom.com>
References: <20170302163834.2273519-1-arnd@arndb.de> <20170302163834.2273519-8-arnd@arndb.de>
 <76733196-0948-8cbf-8b74-c1e3687a8c09@broadcom.com> <CAK8P3a30Ge5gyKco4HKCdKWiJk9ee1PU3_P6THjOQgHm3EQcJw@mail.gmail.com>
 <2dd6ce84-0285-b4c1-97d4-bb41a6ffec04@broadcom.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 6 Mar 2017 12:16:21 +0100
Message-ID: <CAK8P3a3fNbuPvXt4M5HsXOga5Ay0yN7saewRJUoaAsXLq6AypQ@mail.gmail.com>
Subject: Re: [PATCH 07/26] brcmsmac: reduce stack size with KASAN
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: kasan-dev <kasan-dev@googlegroups.com>,
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

On Mon, Mar 6, 2017 at 12:02 PM, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 6-3-2017 11:38, Arnd Bergmann wrote:
>> On Mon, Mar 6, 2017 at 10:16 AM, Arend Van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 2-3-2017 17:38, Arnd Bergmann wrote:
>>>> The wlc_phy_table_write_nphy/wlc_phy_table_read_nphy functions always put an object
>>>> on the stack, which will each require a redzone with KASAN and lead to possible
>>>> stack overflow:
>>>>
>>>> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy':
>>>> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:17135:1: warning: the frame size of 6312 bytes is larger than 1000 bytes [-Wframe-larger-than=]
>>>
>>> Looks like this warning text ended up in the wrong commit message. Got
>>> me confused for a sec :-p
>>
>> What's wrong about the warning?
>
> The warning is about the function 'wlc_phy_workarounds_nphy' (see PATCH
> 9/26) and not about wlc_phy_table_write_nphy/wlc_phy_table_read_nphy
> functions.

The warning only shows up for wlc_phy_workarounds_nphy, and we have to
fix both issues to get the size down enough. If we split it up without
uninlining the register access functions, we end up with two or three smaller
functions that still exceed the limit.

>>>> This marks the two functions as noinline_for_kasan, avoiding the problem entirely.
>>>
>>> Frankly I seriously dislike annotating code for the sake of some
>>> (dynamic) memory analyzer. To me the whole thing seems rather
>>> unnecessary. If the code passes the 2048 stack limit without KASAN it
>>> would seem the limit with KASAN should be such that no warning is given.
>>> I suspect that it is rather difficult to predict the additional size of
>>> the instrumentation code and on some systems there might be a real issue
>>> with increased stack usage.
>>
>> The frame sizes don't normally change that much. There are a couple of
>> drivers like brcmsmac that repeatedly call an inline function which has
>> a local variable that it passes by reference to an extern function.
>>
>> While normally those variables share a stack location, KASAN forces
>> each instance to its own location and adds (in this case) 80 bytes of
>> redzone around it to detect out-of-bounds access.
>>
>> While most drivers are fine with a 1500 byte warning limit, increasing
>> the limit to 7kb would silence brcmsmac (unless more registers
>> are accessed from wlc_phy_workarounds_nphy) but also risk a
>> stack overflow to go unnoticed.
>
> Given the amount of local variables maybe just tag the functions with
> noinline instead.

But that would result in less efficient object code without KASAN,
as inlining these by default is a good idea when the stack variables
all get folded.

     Arnd
