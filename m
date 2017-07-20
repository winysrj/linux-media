Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965399AbdGTOGY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 10:06:24 -0400
MIME-Version: 1.0
In-Reply-To: <20170720081508.33563afe@vento.lan>
References: <CGME20170718215328epcas2p2e5e1d7df96fcd894e70a961df864abdd@epcas2p2.samsung.com>
 <20170718214339.7774-33-robh@kernel.org> <564a6768-3b23-6dc7-ecb5-cb4f4359b633@samsung.com>
 <CAL_JsqLDCgO60ECGB70pMNcaLg0zUcJ6_+50vH-evfGe-D266Q@mail.gmail.com> <20170720081508.33563afe@vento.lan>
From: Rob Herring <robh@kernel.org>
Date: Thu, 20 Jul 2017 09:06:01 -0500
Message-ID: <CAL_JsqJcS_Ewfow0+iuUtLRab62m=AHO+bvbHXX-eSR0Hw_JaQ@mail.gmail.com>
Subject: Re: [PATCH] media: Convert to using %pOF instead of full_name
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
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

On Thu, Jul 20, 2017 at 6:15 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Wed, 19 Jul 2017 11:02:01 -0500
> Rob Herring <robh@kernel.org> escreveu:
>
>> On Wed, Jul 19, 2017 at 4:41 AM, Sylwester Nawrocki
>> <s.nawrocki@samsung.com> wrote:
>> > On 07/18/2017 11:43 PM, Rob Herring wrote:
>> >> Now that we have a custom printf format specifier, convert users of
>> >> full_name to use %pOF instead. This is preparation to remove storing
>> >> of the full path string for each node.
>> >>
>> >> Signed-off-by: Rob Herring <robh@kernel.org>
>> >
>> >> ---
>> >>   drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  3 +-
>> >>   drivers/media/i2c/s5k5baf.c                    |  7 ++--
>> >>   drivers/media/platform/am437x/am437x-vpfe.c    |  4 +-
>> >>   drivers/media/platform/atmel/atmel-isc.c       |  4 +-
>> >>   drivers/media/platform/davinci/vpif_capture.c  | 16 ++++----
>> >>   drivers/media/platform/exynos4-is/fimc-is.c    |  8 ++--
>> >>   drivers/media/platform/exynos4-is/fimc-lite.c  |  3 +-
>> >>   drivers/media/platform/exynos4-is/media-dev.c  |  8 ++--
>> >>   drivers/media/platform/exynos4-is/mipi-csis.c  |  4 +-
>> >>   drivers/media/platform/mtk-mdp/mtk_mdp_comp.c  |  6 +--
>> >>   drivers/media/platform/mtk-mdp/mtk_mdp_core.c  |  8 ++--
>> >>   drivers/media/platform/omap3isp/isp.c          |  8 ++--
>> >>   drivers/media/platform/pxa_camera.c            |  2 +-
>> >>   drivers/media/platform/rcar-vin/rcar-core.c    |  4 +-
>> >>   drivers/media/platform/soc_camera/soc_camera.c |  6 +--
>> >>   drivers/media/platform/xilinx/xilinx-vipp.c    | 52 +++++++++++++-------------
>> >>   drivers/media/v4l2-core/v4l2-async.c           |  4 +-
>> >>   drivers/media/v4l2-core/v4l2-clk.c             |  3 +-
>> >>   include/media/v4l2-clk.h                       |  4 +-
>> >>   19 files changed, 71 insertions(+), 83 deletions(-)
>> >
>> >> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
>> >> index ac4704388920..9233ad0b1b6b 100644
>> >> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
>> >> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
>> >
>> >> @@ -144,9 +144,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>> >>               remote = ent->entity;
>> >>
>> >>               if (link.remote_port >= remote->num_pads) {
>> >> -                     dev_err(xdev->dev, "invalid port number %u on %s\n",
>> >> -                             link.remote_port,
>> >> -                             to_of_node(link.remote_node)->full_name);
>> >> +                     dev_err(xdev->dev, "invalid port number %u on %pOF\n",
>> >> +                             link.remote_port, link.remote_node);
>> >
>> > Shouldn't there be to_of_node(link.remote_node) instead of link.remote_node ?
>>
>> Humm, yes. I thought I fixed that.
>
> After such fix, I'm OK with this patch.

I'll send a new version.

I think I'll send a revert of the referenced commit. It won't apply
cleanly, but at least it will capture the change in behavior and why
it was wrong.

> Are you planning to apply it on your tree, or via the media one?
>
> I guess it is probably better to apply via media, in order to avoid
> conflicts with other changes.

Yes, you can take it.

Rob
