Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33442 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdF3NPZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 09:15:25 -0400
Received: by mail-lf0-f52.google.com with SMTP id z78so28471844lff.0
        for <linux-media@vger.kernel.org>; Fri, 30 Jun 2017 06:15:24 -0700 (PDT)
Subject: Re: [PATCH v3] media: platform: rcar_imr: add IMR-LSX3 support
To: Rob Herring <robh@kernel.org>
References: <20170628195719.333514117@cogentembedded.com>
 <20170629214212.6r4e5xqmuul7g4o2@rob-hp-laptop>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <ea3cceb5-5fa4-a3d8-01c8-8a768553869a@cogentembedded.com>
Date: Fri, 30 Jun 2017 16:15:21 +0300
MIME-Version: 1.0
In-Reply-To: <20170629214212.6r4e5xqmuul7g4o2@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/30/2017 12:42 AM, Rob Herring wrote:

>> Add support for the image renderer light SRAM extended 3 (IMR-LSX3) found
>> only in the R-Car V2H (R8A7792) SoC.  It differs  from IMR-LX4 in that it
>> supports only planar video formats but can use the video capture data for
>> the textures.
>>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> ---
>> This patch  is against the 'media_tree.git' repo's 'master' branch plus the
>> latest version of the Renesas IMR driver...
>>
>> Changes in version 3:
>> - fixed compilation errors, resolved rejects, refreshed the patch atop of the
>>   IMR driver patch (version 6).
>>
>> Changes in version 2:
>> - renamed *enum* 'imr_gen' to 'imr_type' and the *struct* field of this type
>>   from 'gen' to 'type';
>> - rename *struct* 'imr_type' to 'imr_info' and the fields/variables of this type
>>   from 'type' to 'info';
>> - added comments to IMR-LX4 only CMRCR2 bits;
>> - added IMR type check to the WTS instruction writing to CMRCCR2.
>>
>>  Documentation/devicetree/bindings/media/rcar_imr.txt |   11 +-
>
> You missed my ack on v2.

    Sorry again, realized that just after posting v3.

>>  drivers/media/platform/rcar_imr.c                    |  101 +++++++++++++++----
>>  2 files changed, 92 insertions(+), 20 deletions(-)

MBR, Sergei
