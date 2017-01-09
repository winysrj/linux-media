Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36618 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932093AbdAISpm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 13:45:42 -0500
Subject: Re: [PATCH v6 3/3] arm: dts: mt2701: Add node for Mediatek JPEG
 Decoder
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Rick Chang <rick.chang@mediatek.com>
References: <1479353915-5043-1-git-send-email-rick.chang@mediatek.com>
 <1479353915-5043-4-git-send-email-rick.chang@mediatek.com>
 <d602365a-e87b-5bae-8698-bd43063ef079@xs4all.nl>
 <1479784905.8964.15.camel@mtksdaap41>
 <badf8125-27ed-9c5b-fbc0-75716ffdfb0e@xs4all.nl>
 <1479866054.8964.21.camel@mtksdaap41> <1479894203.8964.29.camel@mtksdaap41>
 <1483670099.18931.5.camel@mtksdaap41>
 <974d20f3-5133-0869-2a35-c1617bec5d6e@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        James Liao <jamesjj.liao@mediatek.com>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <c35bd06d-f012-1289-e765-02dc26b87e27@gmail.com>
Date: Mon, 9 Jan 2017 19:45:36 +0100
MIME-Version: 1.0
In-Reply-To: <974d20f3-5133-0869-2a35-c1617bec5d6e@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/01/17 12:29, Hans Verkuil wrote:
> Hi Rick,
>
> On 01/06/2017 03:34 AM, Rick Chang wrote:
>> Hi Hans,
>>
>> The dependence on [1] has been merged in 4.10, but [2] has not.Do you have
>> any idea about this patch series? Should we wait for [2] or we could merge
>> the source code and dt-binding first?
>
> Looking at [2] I noticed that the last comment was July 4th. What is the reason
> it hasn't been merged yet?
>
> If I know [2] will be merged for 4.11, then I am fine with merging this media
> patch series. The dependency of this patch on [2] is something Mauro can handle.
>
> If [2] is not merged for 4.11, then I think it is better to wait until it is
> merged.
>

I can't take [2] because there is no scpsys in the dts present. It seems 
that it got never posted.

Rick can you please follow-up with James and provide a patch which adds 
a scpsys node to the mt2701.dtsi?

Thanks,
Matthias
