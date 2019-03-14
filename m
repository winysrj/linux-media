Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FF0C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F73721019
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfCNIqO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:46:14 -0400
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:39703 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbfCNIqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 04:46:14 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 4M07hq8WyLMwI4M0AhHsvY; Thu, 14 Mar 2019 09:46:11 +0100
Subject: Re: [RFC PATCH V0 0/7] media: platform: Add support for Digital Image
 Processing (DIP) on mt8183 SoC
To:     Frederic Chen <frederic.chen@mediatek.com>, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com, tfiga@chromium.org,
        matthias.bgg@gmail.com, mchehab@kernel.org
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, Jerry-ch.Chen@mediatek.com,
        jungo.lin@mediatek.com, Rynn.Wu@mediatek.com,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3eadd21f-de2c-404c-c2c2-f819bc29947c@xs4all.nl>
Date:   Thu, 14 Mar 2019 09:46:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKYoqDRv5u6SAnfMS50iAzuWG9oLdpRSP1eKcmKvKPrAVamMisH2vm3roU0Gd/j7GHeM0SaavAPqOSFG/xyl9WJxQBnExTuea6NOQO2KFGHz8cBb4RyT
 jv66P3TB9h4IOwiIpaisxfGLazicywvCZdphwzHHh16wkcs/+9ZzW0M66MJhFidf5n5UxIhTS+QQzNu6bdiRgwp2hNi1eJsS8TYRrDSDm2Gjm+v2kAe58JWe
 qf/JFZEFclUc2iJ+/Oh+lwSUtDSExMlfSIzfO2OPtPh31ThLCWDnokjK+0O5aAwBiQdyFGxj3Iffm+l6Dn2t+ZhLYlUrRnkds0H4KxWNAK3HLPPueHyIp+Th
 epHA/uPRZUys3l8bAXSHCCkhOY18JP+2kvMNfx2f0QIhig0hUMZKpERtgDa3t9XObh9QrtxCGWc9OpKv/ycinOCMQg4H1WioANIuNn+slE7SZbmbpikh0NJV
 OSqhFt9Es4WpqprhZuDNpiVXnu6XY9Y/1nimNxGUCRNePEh9fPCEif7x5CUyPGqGXbMnqTCnJrphZuE1Em29u9ZnOFooXnjc3SLgLrR8SmswQBFQeetFt3Je
 6hqsjCq8/9SDWmdQ5m0CpYBpNrsEtbgCb0xrcSQSNPpYfaonEiSryPG6o8ZE4/8ZT2cVarUZ+F1C6GyJ3eEQy9b8RVsbZkk6Bji7JJ5CFKbM3XYlvci2KCIB
 kpiglxJh3joyk/7i2/TJhGwpuiWEoRdkue6aGz/P8+fmUcFVEIpnwWrlPh1G/1j6xpjzzgk0+p0ywRhd9v7JR+ZhBaioQdRl
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Frederic Chen,

On 2/1/19 12:21 PM, Frederic Chen wrote:
> Hello,
> 
> This is the first version of the RFC patch series adding Digital Image
> Processing (DIP) driver on Mediatek mt8183 SoC, which will be used in camera
> features on CrOS application. It belongs to the first Mediatek’s ISP driver
> series based on V4L2 and media controller framework. I posted the main part of
> the DIP driver as RFC to discuss first and would like some review comments on
> the overall structure of the driver.
> 
> Digital Image Processing (DIP) unit can accept the tuning parameters and adjust
> the image content in Mediatek ISP system. Furthermore, it performs demosaicing
> and noise reduction on the image to support the advanced camera features of the
> application. The DIP driver also support image format conversion, resizing and
> rotation with its hardware path.
> 
> The driver is implemented with V4L2 and media controller framework. We have the
> following entities describing the DIP path.
> 
> 1. Meta (output video device): connects to DIP sub device. It accepts the input
>    tuning buffer from userspace. The metadata interface used currently is only
>    a temporary solution to kick off driver development and is not ready for
>    reviewed yet.
> 
> 2. RAW (output video device): connects to DIP sub device. It accepts input image
>    buffer from userspace.
> 
> 3. DIP (sub device): connects to MDP-0 and MDP-1. When processing an image, DIP
>    hardware support multiple output image with different size and format so it
>    needs two capture video devices to return the streaming data to the user.
> 
> 4. MDP-0 (capture video device): return the processed image data.
> 
> 5. MDP-1 (capture video device): return the processed image data, the image
>    size and format can be different from the ones of MDP-0.

Just a high-level comment before you post the next version of this series
and for your "platform: Add support for ISP Pass 1 on mt8183 SoC" series

Please compile the latest version of v4l2-compliance (part of
git://linuxtv.org/v4l-utils.git) and run it against your driver:

v4l2-compliance -m /dev/mediaX

Whenever you post a new version of this series, please do a 'git pull' of
the v4l-utils repo, recompile and retest with v4l2-compliance and post the
test results in the cover letter.

Obviously, there should be no FAILs and probably no warnings.

I suspect that streaming (e.g. adding the -s10 option to v4l2-compliance)
might not work since v4l2-compliance doesn't know about the meta data
formats. But give it a try and see what happens :-)

Regards,

	Hans

> 
> The overall file structure of the DIP driver is as following:
> 
> * mtk_dip-dev-ctx-core.c: Implements common software flow of DIP driver.
>   DIP driver supports two or more software contexts. For example, context 0 is
>   created for preview path and context 1 is for capture path. Both the two
>   contexts share the same DIP hardware to process the images.
> * mtk_dip-v4l2.c: Static DIP contexts configuration.
> * mtk_dip.c: Controls the hardware flow.
> * mtk_dip-dev.c: Implements context-independent flow.
> * mtk_dip-ctrl.c: Handles the HW ctrl request from userspace.
> * mtk_dip-smem-drv.c: Provides the shared memory management required operation.
>   We reserved a memory region for the co-processor and DIP to exchange the
>   tuning and hardware configuration data.
> * mtk_dip-v4l2-util.c: Implements V4L2 and vb2 ops.
> 
> Frederic Chen (7):
>   [media] dt-bindings: mt8183: Add binding for DIP shared memory
>   dts: arm64: mt8183: Add DIP shared memory node
>   [media] dt-bindings: mt8183: Added DIP-SMEM dt-bindings
>   [media] dt-bindings: mt8183: Added DIP dt-bindings
>   dts: arm64: mt8183: Add DIP nodes
>   media: platform: Add Mediatek DIP driver KConfig
>   [media] platform: mtk-isp: Add Mediatek DIP driver
> 
>  .../bindings/media/mediatek,dip_smem.txt           |   29 +
>  .../bindings/media/mediatek,mt8183-dip.txt         |   35 +
>  .../mediatek,reserve-memory-dip_smem.txt           |   45 +
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   36 +
>  drivers/media/platform/Kconfig                     |    2 +
>  drivers/media/platform/mtk-isp/Kconfig             |   21 +
>  drivers/media/platform/mtk-isp/Makefile            |   18 +
>  drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
>  drivers/media/platform/mtk-isp/isp_50/dip/Makefile |   35 +
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-core.h     |  188 +++
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c     |  173 +++
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h     |   43 +
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h      |  319 ++++
>  .../mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c      | 1643 ++++++++++++++++++++
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.c      |  374 +++++
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.h      |  191 +++
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c |  452 ++++++
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-smem.h     |   25 +
>  .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c         | 1000 ++++++++++++
>  .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h         |   38 +
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c     |  292 ++++
>  .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h     |   60 +
>  .../media/platform/mtk-isp/isp_50/dip/mtk_dip.c    | 1385 +++++++++++++++++
>  .../media/platform/mtk-isp/isp_50/dip/mtk_dip.h    |   93 ++
>  24 files changed, 6514 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-dip.txt
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
>  create mode 100644 drivers/media/platform/mtk-isp/Kconfig
>  create mode 100644 drivers/media/platform/mtk-isp/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-core.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.h
> 

