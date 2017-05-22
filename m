Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51016 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757676AbdEVJJW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 05:09:22 -0400
Subject: Re: [PATCH v3 0/3] Fix mdp device tree
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
Cc: srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <1494559361-42835-1-git-send-email-minghsiu.tsai@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20ba4f83-7d22-2a8e-4eb6-7d4eba92e2ae@xs4all.nl>
Date: Mon, 22 May 2017 11:09:05 +0200
MIME-Version: 1.0
In-Reply-To: <1494559361-42835-1-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/12/2017 05:22 AM, Minghsiu Tsai wrote:

Who should take care of the dtsi changes? I'm not sure who maintains the mdp dts.

The driver change and the dtsi change need to be in sync, so it is probably easiest
to merge this via one tree.

Here is my Acked-by for these three patches:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I can take all three, provided I have the Ack of the mdp dts maintainer. Or it can
go through him with my Ack.

Regards,

	Hans

> Changes in v3:
> - Upload patches again because forget to add v2 in title
> 
> Changes in v2:
> - Update commit message
> 
> If the mdp_* nodes are under an mdp sub-node, their corresponding
> platform device does not automatically get its iommu assigned properly.
> 
> Fix this by moving the mdp component nodes up a level such that they are
> siblings of mdp and all other SoC subsystems.  This also simplifies the
> device tree.
> 
> Although it fixes iommu assignment issue, it also break compatibility
> with old device tree. So, the patch in driver is needed to iterate over
> sibling mdp device nodes, not child ones, to keep driver work properly.
> 
> Daniel Kurtz (2):
>   arm64: dts: mt8173: Fix mdp device tree
>   media: mtk-mdp: Fix mdp device tree
> 
> Minghsiu Tsai (1):
>   dt-bindings: mt8173: Fix mdp device tree
> 
>  .../devicetree/bindings/media/mediatek-mdp.txt     |  12 +-
>  arch/arm64/boot/dts/mediatek/mt8173.dtsi           | 126 ++++++++++-----------
>  drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |   2 +-
>  3 files changed, 64 insertions(+), 76 deletions(-)
> 
