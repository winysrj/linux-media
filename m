Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33905 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdAMPCd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 10:02:33 -0500
Subject: Re: [PATCH v6 3/3] arm: dts: mt2701: Add node for Mediatek JPEG
 Decoder
To: Eddie Huang <eddie.huang@mediatek.com>
References: <1479353915-5043-1-git-send-email-rick.chang@mediatek.com>
 <1479353915-5043-4-git-send-email-rick.chang@mediatek.com>
 <d602365a-e87b-5bae-8698-bd43063ef079@xs4all.nl>
 <1479784905.8964.15.camel@mtksdaap41>
 <badf8125-27ed-9c5b-fbc0-75716ffdfb0e@xs4all.nl>
 <1479866054.8964.21.camel@mtksdaap41> <1479894203.8964.29.camel@mtksdaap41>
 <1483670099.18931.5.camel@mtksdaap41>
 <974d20f3-5133-0869-2a35-c1617bec5d6e@xs4all.nl>
 <c35bd06d-f012-1289-e765-02dc26b87e27@gmail.com>
 <1484011718.10361.7.camel@mtksdaap41>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Rick Chang <rick.chang@mediatek.com>,
        devicetree@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        srv_heupstream@mediatek.com,
        James Liao <jamesjj.liao@mediatek.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-mediatek@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <267403e5-18ac-0c74-10ca-cc36b909dfb4@gmail.com>
Date: Fri, 13 Jan 2017 16:02:27 +0100
MIME-Version: 1.0
In-Reply-To: <1484011718.10361.7.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On 10/01/17 02:28, Eddie Huang wrote:
> Hi Matthias,
>
> On Mon, 2017-01-09 at 19:45 +0100, Matthias Brugger wrote:
>>
>> On 09/01/17 12:29, Hans Verkuil wrote:
>>> Hi Rick,
>>>
>>> On 01/06/2017 03:34 AM, Rick Chang wrote:
>>>> Hi Hans,
>>>>
>>>> The dependence on [1] has been merged in 4.10, but [2] has not.Do you have
>>>> any idea about this patch series? Should we wait for [2] or we could merge
>>>> the source code and dt-binding first?
>>>
>>> Looking at [2] I noticed that the last comment was July 4th. What is the reason
>>> it hasn't been merged yet?
>>>
>>> If I know [2] will be merged for 4.11, then I am fine with merging this media
>>> patch series. The dependency of this patch on [2] is something Mauro can handle.
>>>
>>> If [2] is not merged for 4.11, then I think it is better to wait until it is
>>> merged.
>>>
>>
>> I can't take [2] because there is no scpsys in the dts present. It seems
>> that it got never posted.
>>
>> Rick can you please follow-up with James and provide a patch which adds
>> a scpsys node to the mt2701.dtsi?
>>
>
> James sent three MT2701 dts patches [1] two weeks ago, these three
> patches include scpsys node. Please take a reference. And We will send
> new MT2701 ionmmu/smi dtsi node patch base on [1] later, thus you can
> accept and merge to 4.11.
>

Thanks for the clarification. I pulled all this patches into 
v4.10-next/dts32

Hans will you take v9 of this patch set?
Then I'll take the dts patch.

Regards,
Matthias

> [1]
> https://patchwork.kernel.org/patch/9489991/
> https://patchwork.kernel.org/patch/9489985/
> https://patchwork.kernel.org/patch/9489989/
>
> Thanks,
> Eddie
>
>
