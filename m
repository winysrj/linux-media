Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36364 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753649AbdCFUEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 15:04:16 -0500
Received: by mail-lf0-f52.google.com with SMTP id y193so77602749lfd.3
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 12:03:24 -0800 (PST)
Subject: Re: [PATCH] media: platform: Renesas IMR driver
To: Magnus Damm <magnus.damm@gmail.com>
References: <20170302210104.646782352@cogentembedded.com>
 <CAMuHMdVg5N82bu8fxRS=3iqF2MQmqoR0idb_x0t2RNn8eoedQg@mail.gmail.com>
 <f8702961-3561-977f-d6dc-16571a64181e@cogentembedded.com>
 <CAMuHMdUa4n_Gw7bMiSvDzb8TYQMu3WgnR6kTXtsMu_=k1mQrsA@mail.gmail.com>
 <abdfa250-8b13-7471-3e60-2b33b41aa1a5@cogentembedded.com>
 <CANqRtoQ9kzUgBs2iLVh2WMTbZDzk5vrd0kxgep+Uz4AgPBLkDw@mail.gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <ede03ec6-7c56-1285-d81b-f24f62794629@cogentembedded.com>
Date: Mon, 6 Mar 2017 20:11:25 +0300
MIME-Version: 1.0
In-Reply-To: <CANqRtoQ9kzUgBs2iLVh2WMTbZDzk5vrd0kxgep+Uz4AgPBLkDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/2017 01:43 PM, Magnus Damm wrote:

> Thanks for your efforts with this driver. Nice to see that V2 is
> getting in better shape.
>
> In the future, would it be possible for you to include the patch
> version number in the [PATCH] tag somehow?

    Sorry, I'm still getting used to 'quilt mail'...

> On Fri, Mar 3, 2017 at 9:03 PM, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
>> On 03/03/2017 02:58 PM, Geert Uytterhoeven wrote:
>>
>>>>>> +  - "renesas,imr-lx4-v3m" for R-Car V3M.
>>>>>
>>>>>
>>>>>
>>>>> "renesas,-EPROBE_DEFER-imr-lx4"
>>>>
>>>>
>>>>
>>>>    Huh? :-)
>>>
>>>
>>> Do you know the part number of V3M?
>>
>>
>>    No, but using the names from the manual I don't need it.
>
> NAK, like Geert says, please follow the same style as other upstream
> drivers. DT compat strings is not a place for random polices.

    Note that I don't think we need the SoC specific strings (like was done 
with the VSP1/2 driver). I'm not seeing any differences between the gen3 SoCs 
looking at the most current manual...

> Thanks,
>
> / magnus

MBR, Sergei
