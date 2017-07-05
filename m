Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35844 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdGEKS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Jul 2017 06:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0i-H=uU=9DNJbtK2EMX2GJ5cL_TW0roSHpa6tHTcZ2sg@mail.gmail.com>
References: <20170704101508.30946-1-chunyan.zhang@spreadtrum.com>
 <20170704101508.30946-3-chunyan.zhang@spreadtrum.com> <CAK8P3a0i-H=uU=9DNJbtK2EMX2GJ5cL_TW0roSHpa6tHTcZ2sg@mail.gmail.com>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Wed, 5 Jul 2017 18:18:56 +0800
Message-ID: <CAAfSe-vj76psYw2uzC2w0pASRT-FGHqXph0zWE_3tmMVzMHKvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] misc: added Spreadtrum's radio driver
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Songhe Wei <songhe.wei@spreadtrum.com>,
        Zhongping Tan <zhongping.tan@spreadtrum.com>,
        Orson Zhai <orson.zhai@spreadtrum.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 July 2017 at 18:51, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Jul 4, 2017 at 12:15 PM, Chunyan Zhang
> <chunyan.zhang@spreadtrum.com> wrote:
>> This patch added FM radio driver for Spreadtrum's SC2342, which's
>> a WCN SoC, also added a new directory for Spreadtrum's WCN SoCs.
>>
>> Signed-off-by: Songhe Wei <songhe.wei@spreadtrum.com>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
>
> (adding linux-media folks to Cc)

(You forgot to add them in :))

>
> Hi Chunyan,

Hi Arnd,

>
> Thanks for posting this for inclusion as Greg asked for. I'm not sure what
> the policy is for new radio drivers, but I assume this would have to go
> to drivers/staging/media/ as it is a driver for hardware that fits into
> drivers/media/radio but doesn't use the respective APIs.

Ok, I agree to let it go to drivers/staging/media/.

Like I mentioned, SC2342 includes many functions, this patch is only
adding FM radio function included in SC2342 to the kernel tree.  So I
figure that its lifetime probably will not be too long, will remove it
from the kernel tree when we have a clean enough version of the whole
SC2342 drivers for the official upstreaming.

Thanks,
Chunyan

>
>         Arnd
> ---
> end of message, full patch quoted for reference below
>
