Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39428 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbdCFQYc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 11:24:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, kasan-dev@googlegroups.com,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/26] brcmsmac: reindent split functions
References: <20170302163834.2273519-1-arnd@arndb.de>
        <20170302163834.2273519-11-arnd@arndb.de>
        <c18494f1-1a21-c1e5-31db-bef78abe172f@broadcom.com>
Date: Mon, 06 Mar 2017 18:24:16 +0200
In-Reply-To: <c18494f1-1a21-c1e5-31db-bef78abe172f@broadcom.com> (Arend Van
        Spriel's message of "Mon, 6 Mar 2017 10:33:34 +0100")
Message-ID: <87tw7674r3.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 2-3-2017 17:38, Arnd Bergmann wrote:
>> In the previous commit I left the indentation alone to help reviewing
>> the patch, this one now runs the three new functions through 'indent -kr -8'
>> with some manual fixups to avoid silliness.
>> 
>> No changes other than whitespace are intended here.
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        | 1507 +++++++++-----------
>>  1 file changed, 697 insertions(+), 810 deletions(-)
>> 

Arend, please edit your quotes. Leaving 1000 lines of unnecessary quotes
in your reply makes my use of patchwork horrible:

https://patchwork.kernel.org/patch/9601155/

-- 
Kalle Valo
