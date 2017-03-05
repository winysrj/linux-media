Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34257 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751806AbdCEKoC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 05:44:02 -0500
MIME-Version: 1.0
In-Reply-To: <abdfa250-8b13-7471-3e60-2b33b41aa1a5@cogentembedded.com>
References: <20170302210104.646782352@cogentembedded.com> <CAMuHMdVg5N82bu8fxRS=3iqF2MQmqoR0idb_x0t2RNn8eoedQg@mail.gmail.com>
 <f8702961-3561-977f-d6dc-16571a64181e@cogentembedded.com> <CAMuHMdUa4n_Gw7bMiSvDzb8TYQMu3WgnR6kTXtsMu_=k1mQrsA@mail.gmail.com>
 <abdfa250-8b13-7471-3e60-2b33b41aa1a5@cogentembedded.com>
From: Magnus Damm <magnus.damm@gmail.com>
Date: Sun, 5 Mar 2017 19:43:58 +0900
Message-ID: <CANqRtoQ9kzUgBs2iLVh2WMTbZDzk5vrd0kxgep+Uz4AgPBLkDw@mail.gmail.com>
Subject: Re: [PATCH] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Thanks for your efforts with this driver. Nice to see that V2 is
getting in better shape.

In the future, would it be possible for you to include the patch
version number in the [PATCH] tag somehow?

On Fri, Mar 3, 2017 at 9:03 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 03/03/2017 02:58 PM, Geert Uytterhoeven wrote:
>
>>>>> +  - "renesas,imr-lx4-v3m" for R-Car V3M.
>>>>
>>>>
>>>>
>>>> "renesas,-EPROBE_DEFER-imr-lx4"
>>>
>>>
>>>
>>>    Huh? :-)
>>
>>
>> Do you know the part number of V3M?
>
>
>    No, but using the names from the manual I don't need it.

NAK, like Geert says, please follow the same style as other upstream
drivers. DT compat strings is not a place for random polices.

Thanks,

/ magnus
