Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A208C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53E8E2085A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfCAM4A (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:56:00 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:57612 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728244AbfCAMz7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 07:55:59 -0500
Received: from [IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48] ([IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zhhhgNqNPLMwIzhhigicvn; Fri, 01 Mar 2019 13:55:57 +0100
Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
Date:   Fri, 1 Mar 2019 13:55:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfI5nxj7txHHF9FH5EdcLbWCp+C4F8bNpeOuCi9CQINBf8jMtKmsfA+M7ygYlx4wkt1ma7V1Tsvc9xnsxWD/esUl8+8IaRkEC0WRmhvNi78gvcSekbbhd
 e7l2Vbw3dEzdHZZLtCx43DN3Q6Xyuf3jHYWLC7P8JBmkI/GrLhxpKs9cqO4x9yMyE9gus9teo3yjGua0My8P+1hCVjiyWLKG+DJZYeoFaC8cZp66hbljByok
 6YvvhbVJ8gNdj7NiQAF3YoYuVraXZcOSPY70ciOAXzZXngiGQ0MSFHvQNHS5vc4bZxqjDW4Dyl4hXcAKjENBQMmZVMBEyG1fK7V4ynaI2Ukr/bNguVAZC8EP
 ivTGIap7E3cCfG+xRRCK3cI3VAFCQ9xLYfdaLM8fKK87OTnxSqY6z26igCZ2oiW9DraAx/htUWBZ9gd9Epy5Cb9o8jNVIWiDeT4U4AW9m6KKiFgKIjHZ/zHl
 4o8XelcSuld70KD4moRamkqPn2nIynd4vsBPWrsqKaQi/9/MmBefnpxBjy+9RPtZePVtrv5fbolmNfNZMjxbwapjw5AQ228VEcd7/UysafsRoGScbdvaIKHs
 QSVeIUan9MfMBHEKZga0YKKVLOxyJg+HqPV0VJU9BmrbOb8+ldRvxWJwMj9Y/7HibqZWsE79Tq8PY5KIFSW03+kgJNboDEa4Z/JvjtHSWsmr9O7z9O7pWU95
 6Fd7KO1SJLgaT76gKqOrWcLdOSd3PFWS
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Fabrizio,

It looks like this series fell through the cracks.

I looked at it and the main problem is that it is missing a Reviewed-by
from Rob Herring (devicetree maintainer). It's a bit surprising since he
is usually fairly prompt.

I recommend that you rebase and repost it and I'll delegate the v2 series
to me so we can hopefully get it in for 5.2 (5.1 is likely too late) once
Rob reviews it.

BTW, I'm the one who usually processes rcar patches. But it was delegated in
patchwork to Laurent, so I never saw it.

Regards,

	Hans

On 3/1/19 1:09 PM, Fabrizio Castro wrote:
> Hello Mauro,
> 
> This patch has been around for some time now, do you think you can take it?
> 
> Cheers,
> Fab
> 
>> From: Biju Das <biju.das@bp.renesas.com>
>> Sent: 10 September 2018 15:31
>> Subject: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1 support
>>
>> Document RZ/G2M (R8A774A1) SoC bindings.
>>
>> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
>>
>> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
>> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
>> ---
>>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
>> b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
>> index 2d385b6..12fe685 100644
>> --- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
>> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
>> @@ -2,12 +2,13 @@ Renesas R-Car MIPI CSI-2
>>  ------------------------
>>
>>  The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for the
>> -Renesas R-Car family of devices. It is used in conjunction with the
>> -R-Car VIN module, which provides the video capture capabilities.
>> +Renesas R-Car Gen3 and RZ/G2 family of devices. It is used in conjunction
>> +with the R-Car VIN module, which provides the video capture capabilities.
>>
>>  Mandatory properties
>>  --------------------
>>   - compatible: Must be one or more of the following
>> +   - "renesas,r8a774a1-csi2" for the R8A774A1 device.
>>     - "renesas,r8a7795-csi2" for the R8A7795 device.
>>     - "renesas,r8a7796-csi2" for the R8A7796 device.
>>     - "renesas,r8a77965-csi2" for the R8A77965 device.
>> --
>> 2.7.4
> 

