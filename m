Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729530AbeJAV7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 17:59:22 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w91FG6Jw019806
        for <linux-media@vger.kernel.org>; Mon, 1 Oct 2018 11:21:04 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mun2jkcxv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 11:21:04 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Mon, 1 Oct 2018 11:21:02 -0400
Subject: Re: [PATCH v3 1/2] dt-bindings: media: Add Aspeed Video Engine
 binding documentation
To: Joel Stanley <joel@jms.id.au>, eajames@linux.ibm.com
Cc: Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org, Andrew Jeffery <andrew@aj.id.au>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hverkuil@xs4all.nl, Rob Herring <robh+dt@kernel.org>,
        mchehab@kernel.org, linux-media@vger.kernel.org
References: <1537903629-14003-1-git-send-email-eajames@linux.ibm.com>
 <1537903629-14003-2-git-send-email-eajames@linux.ibm.com>
 <CACPK8Xd0MhrFQqiM=u-Rv5u7RJRo5R-pAejH4dmeTrYSWE0AZA@mail.gmail.com>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Mon, 1 Oct 2018 10:20:57 -0500
MIME-Version: 1.0
In-Reply-To: <CACPK8Xd0MhrFQqiM=u-Rv5u7RJRo5R-pAejH4dmeTrYSWE0AZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <3e53dda4-81c4-1009-add2-45a3a7998e4e@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/01/2018 08:08 AM, Joel Stanley wrote:
> On Tue, 25 Sep 2018 at 21:27, Eddie James <eajames@linux.ibm.com> wrote:
>> Document the bindings.
>>
>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>> ---
>>   .../devicetree/bindings/media/aspeed-video.txt     | 26 ++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/aspeed-video.txt b/Documentation/devicetree/bindings/media/aspeed-video.txt
>> new file mode 100644
>> index 0000000..f1af528
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/aspeed-video.txt
>> @@ -0,0 +1,26 @@
>> +* Device tree bindings for Aspeed Video Engine
>> +
>> +The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs can
>> +capture and compress video data from digital or analog sources.
>> +
>> +Required properties:
>> + - compatible:         "aspeed,ast2400-video-engine" or
>> +                       "aspeed,ast2500-video-engine"
>> + - reg:                        contains the offset and length of the VE memory region
>> + - clocks:             clock specifiers for the syscon clocks associated with
>> +                       the VE (ordering must match the clock-names property)
>> + - clock-names:                "vclk" and "eclk"
>> + - resets:             reset specifier for the syscon reset associaated with
> associated

Good catch, thanks.

>
>> +                       the VE
>> + - interrupts:         the interrupt associated with the VE on this platform
>> +
>> +Example:
>> +
>> +video-engine@1e700000 {
>> +    compatible = "aspeed,ast2500-video-engine";
>> +    reg = <0x1e700000 0x20000>;
>> +    clocks = <&syscon ASPEED_CLK_GATE_VCLK>, <&syscon ASPEED_CLK_GATE_ECLK>;
>> +    clock-names = "vclk", "eclk";
> Did you end up sending the clock patches out?

Yes,

https://lore.kernel.org/patchwork/patch/978979/
https://lore.kernel.org/patchwork/patch/978976/

Do I need to send them as a separate series?

Thanks,
Eddie

>
> Cheers,
>
> Joel
>
>> +    resets = <&syscon ASPEED_RESET_VIDEO>;
>> +    interrupts = <7>;
>> +};
>> --
>> 1.8.3.1
>>
