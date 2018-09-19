Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45599 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733266AbeITAYK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 20:24:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id u83-v6so5992362lje.12
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 11:44:57 -0700 (PDT)
Subject: Re: [PATCH] rcar-csi2: add R8A77980 support
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
References: <f6edfd44-7b08-e467-3486-795251816187@cogentembedded.com>
 <20180806180250.GD1635@bigcity.dyn.berto.se>
 <e2d1e9ea-f524-31f1-1561-2f0363981938@cogentembedded.com>
 <20180917111748.GT18450@bigcity.dyn.berto.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <662a85e2-a26a-515c-2e0c-05df9f7570d8@cogentembedded.com>
Date: Wed, 19 Sep 2018 21:44:53 +0300
MIME-Version: 1.0
In-Reply-To: <20180917111748.GT18450@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 09/17/2018 02:17 PM, Niklas Söderlund wrote:

>>>> Add the R-Car V3H (AKA R8A77980) SoC support to the R-Car CSI2 driver.
>>>>
>>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>
>>> It looks good but before I add my tag I would like to know if you tested 
>>> this on a V3H?
>>
>>    No, have not tested the upstream patch, seemed too cumbersome (we did 
>> test the BSP patch AFAIK).
> 
> Did you find time to test this change? I think it looks good but I would 

   Unfortunately, no.

> feel a lot better about this change if I knew it was tested :-) More 
> often then not have we shaken a bug out of the rcar-{csi2,vin} tree by 
> adding support for a new SoC.
> 
> Also if you for some reason need to resend this series could you split 
> the DT documentation and driver changes in two separate patches?

   OK.

>>> In the past extending the R-Car CSI-2 receiver to a new 
>>> SoC always caught some new corner case :-)
>>>
>>> I don't have access to a V3H myself otherwise I would of course test it 
>>> myself.
>>
>>    CSI-2 on the Condor board is connected to a pair of MAX9286 GMSL de-serializers
>> which are connected to 4 (composite?) connectors... There's supposed to be sensor
>> chip on the other side, AFAIK...
> 
> There is experimental patches which are tested on V3M that uses the 
> MAX9286 GMSL setup if you feel brave and want to try and extend them to 
> cover V3H ;-P

   Wouldn't hurt having them. :-)

MBR, Sergei
