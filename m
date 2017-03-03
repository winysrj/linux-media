Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36268 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdCCL5i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 06:57:38 -0500
Received: by mail-lf0-f44.google.com with SMTP id y193so46283637lfd.3
        for <linux-media@vger.kernel.org>; Fri, 03 Mar 2017 03:56:45 -0800 (PST)
Subject: Re: [PATCH] media: platform: Renesas IMR driver
To: Geert Uytterhoeven <geert@linux-m68k.org>
References: <20170302210104.646782352@cogentembedded.com>
 <CAMuHMdVg5N82bu8fxRS=3iqF2MQmqoR0idb_x0t2RNn8eoedQg@mail.gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <f8702961-3561-977f-d6dc-16571a64181e@cogentembedded.com>
Date: Fri, 3 Mar 2017 14:56:41 +0300
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVg5N82bu8fxRS=3iqF2MQmqoR0idb_x0t2RNn8eoedQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 03/03/2017 02:24 PM, Geert Uytterhoeven wrote:

>> --- /dev/null
>> +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
>
>> +- compatible: "renesas,imr-lx4-<soctype>", "renesas,imr-lx4" as a fallback for
>
> "renesas,<soctype>-imr-lx4"
>
>> +  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs,
>> +  where the examples with <soctype> are:
>> +  - "renesas,imr-lx4-h3" for R-Car H3,
>
> "renesas,r8a7795-imr-lx4"

    The IMR core names were copied from the manual verbatim (just in lower case).

>> +  - "renesas,imr-lx4-m3-w" for R-Car M3-W,
>
> "renesas,r8a7796-imr-lx4"
>
>> +  - "renesas,imr-lx4-v3m" for R-Car V3M.
>
> "renesas,-EPROBE_DEFER-imr-lx4"

    Huh? :-)

> Gr{oetje,eeting}s,
>
>                         Geert

MBR, Sergei
