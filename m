Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37157
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934281AbdGTLPx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 07:15:53 -0400
Date: Thu, 20 Jul 2017 08:15:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Rob Herring <robh@kernel.org>
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
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] media: Convert to using %pOF instead of full_name
Message-ID: <20170720081508.33563afe@vento.lan>
In-Reply-To: <CAL_JsqLDCgO60ECGB70pMNcaLg0zUcJ6_+50vH-evfGe-D266Q@mail.gmail.com>
References: <CGME20170718215328epcas2p2e5e1d7df96fcd894e70a961df864abdd@epcas2p2.samsung.com>
        <20170718214339.7774-33-robh@kernel.org>
        <564a6768-3b23-6dc7-ecb5-cb4f4359b633@samsung.com>
        <CAL_JsqLDCgO60ECGB70pMNcaLg0zUcJ6_+50vH-evfGe-D266Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Jul 2017 11:02:01 -0500
Rob Herring <robh@kernel.org> escreveu:

> On Wed, Jul 19, 2017 at 4:41 AM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
> > On 07/18/2017 11:43 PM, Rob Herring wrote:  
> >> Now that we have a custom printf format specifier, convert users of
> >> full_name to use %pOF instead. This is preparation to remove storing
> >> of the full path string for each node.
> >>
> >> Signed-off-by: Rob Herring <robh@kernel.org>  
> >  
> >> ---
> >>   drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  3 +-
> >>   drivers/media/i2c/s5k5baf.c                    |  7 ++--
> >>   drivers/media/platform/am437x/am437x-vpfe.c    |  4 +-
> >>   drivers/media/platform/atmel/atmel-isc.c       |  4 +-
> >>   drivers/media/platform/davinci/vpif_capture.c  | 16 ++++----
> >>   drivers/media/platform/exynos4-is/fimc-is.c    |  8 ++--
> >>   drivers/media/platform/exynos4-is/fimc-lite.c  |  3 +-
> >>   drivers/media/platform/exynos4-is/media-dev.c  |  8 ++--
> >>   drivers/media/platform/exynos4-is/mipi-csis.c  |  4 +-
> >>   drivers/media/platform/mtk-mdp/mtk_mdp_comp.c  |  6 +--
> >>   drivers/media/platform/mtk-mdp/mtk_mdp_core.c  |  8 ++--
> >>   drivers/media/platform/omap3isp/isp.c          |  8 ++--
> >>   drivers/media/platform/pxa_camera.c            |  2 +-
> >>   drivers/media/platform/rcar-vin/rcar-core.c    |  4 +-
> >>   drivers/media/platform/soc_camera/soc_camera.c |  6 +--
> >>   drivers/media/platform/xilinx/xilinx-vipp.c    | 52 +++++++++++++-------------
> >>   drivers/media/v4l2-core/v4l2-async.c           |  4 +-
> >>   drivers/media/v4l2-core/v4l2-clk.c             |  3 +-
> >>   include/media/v4l2-clk.h                       |  4 +-
> >>   19 files changed, 71 insertions(+), 83 deletions(-)  
> >  
> >> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
> >> index ac4704388920..9233ad0b1b6b 100644
> >> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> >> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c  
> >  
> >> @@ -144,9 +144,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
> >>               remote = ent->entity;
> >>
> >>               if (link.remote_port >= remote->num_pads) {
> >> -                     dev_err(xdev->dev, "invalid port number %u on %s\n",
> >> -                             link.remote_port,
> >> -                             to_of_node(link.remote_node)->full_name);
> >> +                     dev_err(xdev->dev, "invalid port number %u on %pOF\n",
> >> +                             link.remote_port, link.remote_node);  
> >
> > Shouldn't there be to_of_node(link.remote_node) instead of link.remote_node ?  
> 
> Humm, yes. I thought I fixed that.

After such fix, I'm OK with this patch.

Are you planning to apply it on your tree, or via the media one?

I guess it is probably better to apply via media, in order to avoid
conflicts with other changes.

Thanks,
Mauro
