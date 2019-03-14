Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5008C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FED920643
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfCNIk5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:40:57 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37023 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbfCNIk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 04:40:57 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 4Luzhq6LWLMwI4Lv3hHreU; Thu, 14 Mar 2019 09:40:54 +0100
Subject: Re: [RFC PATCH V0 0/7] media: platform: Add support for Face
 Detection (FD) on mt8183 SoC
To:     Jerry-ch Chen <Jerry-Ch.chen@mediatek.com>, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com, tfiga@chromium.org,
        matthias.bgg@gmail.com, mchehab@kernel.org
Cc:     yuzhao@chromium.org, zwisler@chromium.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, frederic.chen@mediatek.com,
        jungo.lin@mediatek.com, Rynn.Wu@mediatek.com,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com,
        devicetree@vger.kernel.org
References: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1967d769-48c2-1d49-464a-6895cd2ff102@xs4all.nl>
Date:   Thu, 14 Mar 2019 09:40:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHiDWTUJbXEeQ0kvY52t0/Ywc2SmHaRmuODPKjxKUS4SCA3dh2OwT2+X23XVLXlt+TcT+q71TXjMQccH1BQfGPKMOI+u+Px6PiGyl3ZpI8dLncAS4LPJ
 KxQ75yVDDHy09DgJRzw/0I0VMt8U9XrdYngmiZ+Ubxy8rdOru3EIGlmX8qRmYqb7XvE1VAv74k6nkwrSGyZm8NkdUvpF1tMLtWdYkxGV1WmF4zvI+jsb9F5V
 vsr7W6puA3rpv+1UGV8GWRPyZWPnxJQGlZBBviHpEZmElY7TUbcMlzDaZttT/q2VrFLx0nHOyJ8SBJcS76PwuMSTGHsr/JZ2Td1FBxggXuHxqGAQh2Roc/QD
 lR+OcYd1KEAL4x46BAUrS/KuBjxIQUleJmw4ybkNgmt9PnWRUhfVQTkKykztRQDiSbJqYmWv0XIyUoCOlqndIM1JghhlW97SahybNVfpOe30/CZYKlYLeV7E
 XY14VU8vZCIzuj6RaJ7Sa8OxdsMPBDgbUUmzufnu9Z2OlMN6RFEiIDFevl+3F3zEzMun87twjSECuRnYMHO3/jiDjlTK4iORh5XRL+iuGiQIDRQPDRAxop4s
 0gRwUEhdJqj8MgaAfBZE4L0AIJuFP/j++IqSbioqzQ2QNvl5G0NlL6ylmYXC6mK6NXE6pHMe9sp06hbhn/beIJiRIhqqPNjgXKEJFdJZn+dp/3+BAxNqHBwv
 VUNjp4CFU+QTpMktY9QFP3f9X038MO16DR1l5Lch6NLB6fv9Mva5N8aV+3kQjyZB+9//Yq28Kjlxx8VQI/bRosPvgyG2mSNSE5pxtrWOtYbMXRTI6uVlsPxL
 8O9bmvd80t9wxWY4zz26VlzhIdlE8nfhDUb473ikEjJafNEmpX3JWzwYJKWxdmQJUgbga8ogIgSiNryOLMk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jerry-ch Chen,

On 2/20/19 8:48 AM, Jerry-ch Chen wrote:
> Hello,
> 
> This is the first version of the RFC patch series adding Face Detection
> (FD) driver on Mediatek mt8183 SoC, which will be used in camera features
> on CrOS application. It belongs to the first Mediatek's camera driver
> series based on V4L2 and media controller framework. I posted the main part
> of the FD driver as RFC to discuss first and would like some review
> comments on the overall structure of the driver.
> 
> Face Detection (FD) unit provide hardware accelerated face detection
> feature. It can detect different sizes of faces in a given image.
> Furthermore, it has the capability to detect the faces of Rotation-in-Plane
> from -180 to +180 degrees and Rotation-off-Plane from -90 to +90 degrees.
> 
> The driver is implemented with V4L2 and media controller framework. We have
> the following entities describing the FD path.

Just a high-level comment before you post the next version of this series:

Please compile the latest version of v4l2-compliance (part of
git://linuxtv.org/v4l-utils.git) and run it against your driver:

v4l2-compliance -m /dev/mediaX

Whenever you post a new version of this series, please do a 'git pull' of
the v4l-utils repo, recompile and retest with v4l2-compliance and post the
test results in the cover letter.

Obviously, there should be no FAILs and probably no warnings.

I suspect that streaming (e.g. adding the -s10 option to v4l2-compliance)
probably won't work since v4l2-compliance doesn't know about the meta data
formats.

Regards,

	Hans

> 
> 1. Meta input (output video device): connects to FD sub device. It accepts
>    the input parameter buffer from userspace. The metadata interface used
>    currently is only a temporary solution to kick off driver development
>    and is not ready for reviewed yet.
> 
> 2. RAW (output video device): connects to FD sub device. It accepts input
>    image buffer from userspace.
> 
> 3. FD (sub device): connects to Meta output. When processing an image,
>    FD hardware only returns the statistics of detected faces so it needs
>    only one capture video devices to return the streaming data to the user.
> 
> 4. Meta output (capture video device): Return the result of detected faces
>    as metadata output.
> 
>    The overall file structure of the FD driver is as following:
> 
> * mtk_fd-dev-ctx-core.c: Implements common software flow of FD driver.
> * mtk_fd-v4l2.c: Static FD contexts configuration.
> * mtk_fd.c: Controls the hardware flow.
> * mtk_fd-dev.c: Implements context-independent flow.
> * mtk_fd-ctrl.c: Handles the HW ctrl request from userspace.
> * mtk_fd-smem-drv.c: Provides the shared memory management required
> operation. We reserved a memory region for the co-processor and FD to
> exchange the hardware configuration data.
> * mtk_fd-v4l2-util.c: Implements V4L2 and vb2 ops.
> 
> Jerry-ch Chen (7):
>   dt-bindings: mt8183: Add binding for FD shared memory
>   dts: arm64: mt8183: Add FD shared memory node
>   dt-bindings: mt8183: Added FD-SMEM dt-bindings
>   dt-bindings: mt8183: Added FD dt-bindings
>   dts: arm64: mt8183: Add FD nodes
>   media: platform: Add Mediatek FD driver KConfig
>   platform: mtk-isp: Add Mediatek FD driver
> 
>  .../devicetree/bindings/media/mediatek,fd_smem.txt |   28 +
>  .../bindings/media/mediatek,mt8183-fd.txt          |   30 +
>  .../mediatek,reserve-memory-fd_smem.txt            |   44 +
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   28 +
>  drivers/media/platform/Kconfig                     |    2 +
>  drivers/media/platform/mtk-isp/Kconfig             |   10 +
>  drivers/media/platform/mtk-isp/Makefile            |   16 +
>  drivers/media/platform/mtk-isp/fd/Makefile         |   38 +
>  drivers/media/platform/mtk-isp/fd/mtk_fd-core.h    |  157 +++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h     |  299 ++++++
>  .../platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c      |  917 +++++++++++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c     |  355 +++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h     |  198 ++++
>  .../media/platform/mtk-isp/fd/mtk_fd-smem-drv.c    |  452 +++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h    |   25 +
>  .../media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c   | 1046 ++++++++++++++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c    |  115 +++
>  drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h    |   36 +
>  drivers/media/platform/mtk-isp/fd/mtk_fd.c         |  730 ++++++++++++++
>  drivers/media/platform/mtk-isp/fd/mtk_fd.h         |  127 +++
>  20 files changed, 4653 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek,fd_smem.txt
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-fd.txt
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-fd_smem.txt
>  create mode 100644 drivers/media/platform/mtk-isp/Kconfig
>  create mode 100644 drivers/media/platform/mtk-isp/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/fd/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-core.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem-drv.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.c
>  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.h
> 

