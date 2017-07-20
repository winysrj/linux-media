Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:42112 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934926AbdGTKWr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 06:22:47 -0400
Subject: Re: [PATCH] media: Convert to using %pOF instead of full_name
To: Rob Herring <robh@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        Javi Merino <javi.merino@kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <7b004361-f103-f804-3884-299eb5607648@samsung.com>
Date: Thu, 20 Jul 2017 12:22:34 +0200
MIME-version: 1.0
In-reply-to: <CAL_JsqLDCgO60ECGB70pMNcaLg0zUcJ6_+50vH-evfGe-D266Q@mail.gmail.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20170718215328epcas2p2e5e1d7df96fcd894e70a961df864abdd@epcas2p2.samsung.com>
        <20170718214339.7774-33-robh@kernel.org>
        <564a6768-3b23-6dc7-ecb5-cb4f4359b633@samsung.com>
        <CAL_JsqLDCgO60ECGB70pMNcaLg0zUcJ6_+50vH-evfGe-D266Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2017 06:02 PM, Rob Herring wrote:
>>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>>> index 851f128eba22..0a385d1ff28c 100644
>>> --- a/drivers/media/v4l2-core/v4l2-async.c
>>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>>> @@ -47,9 +47,7 @@ static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>>>        if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
>>>                return sd->fwnode == asd->match.fwnode.fwnode;
>>>
>>> -     return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
>>> -                         of_node_full_name(
>>> -                                 to_of_node(asd->match.fwnode.fwnode)));
>>> +     return to_of_node(sd->fwnode) == to_of_node(asd->match.fwnode.fwnode);
 >>
>> I'm afraid this will not work, please see commit d2180e0cf77dc7a7049671d5d57d
>> "[media] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay"
 >
> Maybe I'm missing something, but how does that work exactly? Before
> the overlay is applied, the remote endpoint node (and its parent)
> can't be resolved. In the commit example, the endpoint in the
> media_bridge would also have to be part of the overlay. If you apply
> and un-apply the overlay, then the of_node (and fw_node) in the
> overlay is once again invalid. IOW, you should be in the same state as
> before the overlay was applied. The node is still around because of
> paranoia that actually freeing nodes would break things. It seems this
> paranoia is real, so i think we need to do something to prevent this
> from spreading.
> 
> Furthermore, it does not appear that any media driver supports
> overlays and we have no general way to apply them in mainline yet
> (other than an in kernel API). So really this scenario is not one we
> have to support yet.

Indeed, the motivation of the above mentioned commit was some out of
tree driver. I don't know was the exact use case, assuming that the
endpoint in the bridge node was also part of the overlay the bridge
driver must have not been rescanning device tree after overlay un-apply
and apply. Currently there is no other way to do this than to unbind
and bind. So the bridge driver must have been referencing an already
invalid node as you point out.

I haven't been following DT overlays very closely, as Frank explains
your change seems to be actually an improvement of current code.

-- 
Thanks,
Sylwester
