Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33065 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdCCMNe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 07:13:34 -0500
Received: by mail-lf0-f43.google.com with SMTP id a6so46551859lfa.0
        for <linux-media@vger.kernel.org>; Fri, 03 Mar 2017 04:12:13 -0800 (PST)
Subject: Re: [PATCH] media: platform: Renesas IMR driver
To: Geert Uytterhoeven <geert@linux-m68k.org>
References: <20170302210104.646782352@cogentembedded.com>
 <CAMuHMdVg5N82bu8fxRS=3iqF2MQmqoR0idb_x0t2RNn8eoedQg@mail.gmail.com>
 <f8702961-3561-977f-d6dc-16571a64181e@cogentembedded.com>
 <CAMuHMdUa4n_Gw7bMiSvDzb8TYQMu3WgnR6kTXtsMu_=k1mQrsA@mail.gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <abdfa250-8b13-7471-3e60-2b33b41aa1a5@cogentembedded.com>
Date: Fri, 3 Mar 2017 15:03:38 +0300
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUa4n_Gw7bMiSvDzb8TYQMu3WgnR6kTXtsMu_=k1mQrsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2017 02:58 PM, Geert Uytterhoeven wrote:

>>>> +  - "renesas,imr-lx4-v3m" for R-Car V3M.
>>>
>>>
>>> "renesas,-EPROBE_DEFER-imr-lx4"
>>
>>
>>    Huh? :-)
>
> Do you know the part number of V3M?

    No, but using the names from the manual I don't need it.

> Gr{oetje,eeting}s,
>
>                         Geert

MBR, Sergei
