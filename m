Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35842 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754998AbcHVRD5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 13:03:57 -0400
Subject: Re: [PATCH v4 2/4] dt-bindings: Add a binding for Mediatek MDP
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rob Herring <robh@kernel.org>
References: <1471606767-3218-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1471606767-3218-3-git-send-email-minghsiu.tsai@mediatek.com>
 <20160819141655.GA18486@rob-hp-laptop> <1471828082.30956.1.camel@mtksdaap41>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <bc8dda62-8169-c2b4-bc05-7e23d5329c28@gmail.com>
Date: Mon, 22 Aug 2016 19:03:49 +0200
MIME-Version: 1.0
In-Reply-To: <1471828082.30956.1.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 22/08/16 03:08, Minghsiu Tsai wrote:
> On Fri, 2016-08-19 at 09:16 -0500, Rob Herring wrote:
>> On Fri, Aug 19, 2016 at 07:39:25PM +0800, Minghsiu Tsai wrote:
>>> Add a DT binding documentation of MDP for the MT8173 SoC
>>> from Mediatek
>>>
>>> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
>>> ---
>>>  .../devicetree/bindings/media/mediatek-mdp.txt     |  109 ++++++++++++++++++++
>>>  1 file changed, 109 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
>>
>> Please add acks when posting new versions.
>>
>> Rob
>
> Sorry for my mistake. I will add it in next version.
>


No need to provide a new version just because of this. If the driver 
will be taken as is, I can fix up the ack when applying.

Thanks,
Matthias
