Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755247AbdGSQCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 12:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <564a6768-3b23-6dc7-ecb5-cb4f4359b633@samsung.com>
References: <CGME20170718215328epcas2p2e5e1d7df96fcd894e70a961df864abdd@epcas2p2.samsung.com>
 <20170718214339.7774-33-robh@kernel.org> <564a6768-3b23-6dc7-ecb5-cb4f4359b633@samsung.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Jul 2017 11:02:01 -0500
Message-ID: <CAL_JsqLDCgO60ECGB70pMNcaLg0zUcJ6_+50vH-evfGe-D266Q@mail.gmail.com>
Subject: Re: [PATCH] media: Convert to using %pOF instead of full_name
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
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
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 19, 2017 at 4:41 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 07/18/2017 11:43 PM, Rob Herring wrote:
>> Now that we have a custom printf format specifier, convert users of
>> full_name to use %pOF instead. This is preparation to remove storing
>> of the full path string for each node.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>
>> ---
>>   drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  3 +-
>>   drivers/media/i2c/s5k5baf.c                    |  7 ++--
>>   drivers/media/platform/am437x/am437x-vpfe.c    |  4 +-
>>   drivers/media/platform/atmel/atmel-isc.c       |  4 +-
>>   drivers/media/platform/davinci/vpif_capture.c  | 16 ++++----
>>   drivers/media/platform/exynos4-is/fimc-is.c    |  8 ++--
>>   drivers/media/platform/exynos4-is/fimc-lite.c  |  3 +-
>>   drivers/media/platform/exynos4-is/media-dev.c  |  8 ++--
>>   drivers/media/platform/exynos4-is/mipi-csis.c  |  4 +-
>>   drivers/media/platform/mtk-mdp/mtk_mdp_comp.c  |  6 +--
>>   drivers/media/platform/mtk-mdp/mtk_mdp_core.c  |  8 ++--
>>   drivers/media/platform/omap3isp/isp.c          |  8 ++--
>>   drivers/media/platform/pxa_camera.c            |  2 +-
>>   drivers/media/platform/rcar-vin/rcar-core.c    |  4 +-
>>   drivers/media/platform/soc_camera/soc_camera.c |  6 +--
>>   drivers/media/platform/xilinx/xilinx-vipp.c    | 52 +++++++++++++-------------
>>   drivers/media/v4l2-core/v4l2-async.c           |  4 +-
>>   drivers/media/v4l2-core/v4l2-clk.c             |  3 +-
>>   include/media/v4l2-clk.h                       |  4 +-
>>   19 files changed, 71 insertions(+), 83 deletions(-)
>
>> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
>> index ac4704388920..9233ad0b1b6b 100644
>> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
>> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
>
>> @@ -144,9 +144,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>>               remote = ent->entity;
>>
>>               if (link.remote_port >= remote->num_pads) {
>> -                     dev_err(xdev->dev, "invalid port number %u on %s\n",
>> -                             link.remote_port,
>> -                             to_of_node(link.remote_node)->full_name);
>> +                     dev_err(xdev->dev, "invalid port number %u on %pOF\n",
>> +                             link.remote_port, link.remote_node);
>
> Shouldn't there be to_of_node(link.remote_node) instead of link.remote_node ?

Humm, yes. I thought I fixed that.

>
>>                       v4l2_fwnode_put_link(&link);
>>                       ret = -EINVAL;
>>                       break;
>
>> @@ -242,17 +241,17 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
>>               ent = xvip_graph_find_entity(xdev,
>>                                            to_of_node(link.remote_node));
>>               if (ent == NULL) {
>> -                     dev_err(xdev->dev, "no entity found for %s\n",
>> -                             to_of_node(link.remote_node)->full_name);
>> +                     dev_err(xdev->dev, "no entity found for %pOF\n",
>> +                             to_of_node(link.remote_node));
>>                       v4l2_fwnode_put_link(&link);
>>                       ret = -ENODEV;
>>                       break;
>>               }
>
>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>> index 851f128eba22..0a385d1ff28c 100644
>> --- a/drivers/media/v4l2-core/v4l2-async.c
>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>> @@ -47,9 +47,7 @@ static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>>       if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
>>               return sd->fwnode == asd->match.fwnode.fwnode;
>>
>> -     return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
>> -                         of_node_full_name(
>> -                                 to_of_node(asd->match.fwnode.fwnode)));
>> +     return to_of_node(sd->fwnode) == to_of_node(asd->match.fwnode.fwnode);
>
> I'm afraid this will not work, please see commit d2180e0cf77dc7a7049671d5d57d
> "[media] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay"

Maybe I'm missing something, but how does that work exactly? Before
the overlay is applied, the remote endpoint node (and its parent)
can't be resolved. In the commit example, the endpoint in the
media_bridge would also have to be part of the overlay. If you apply
and un-apply the overlay, then the of_node (and fw_node) in the
overlay is once again invalid. IOW, you should be in the same state as
before the overlay was applied. The node is still around because of
paranoia that actually freeing nodes would break things. It seems this
paranoia is real, so i think we need to do something to prevent this
from spreading.

Furthermore, it does not appear that any media driver supports
overlays and we have no general way to apply them in mainline yet
(other than an in kernel API). So really this scenario is not one we
have to support yet.

Rob
