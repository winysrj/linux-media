Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8E5C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 10:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8BF22190A
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 10:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfCUK3w (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:29:52 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:45446 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726523AbfCUK3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 06:29:52 -0400
X-UUID: 536fab67da404fa2b7d1179ac8a6130b-20190321
X-UUID: 536fab67da404fa2b7d1179ac8a6130b-20190321
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <jerry-ch.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 992288166; Thu, 21 Mar 2019 18:29:47 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 21 Mar 2019 18:29:45 +0800
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 21 Mar 2019 18:29:45 +0800
Message-ID: <1553164185.11458.17.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 0/7] media: platform: Add support for Face
 Detection (FD) on mt8183 SoC
From:   Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart+renesas@ideasonboard.com" 
        <laurent.pinchart+renesas@ideasonboard.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>
CC:     "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart+renesas@ideasonboard.com" 
        <laurent.pinchart+renesas@ideasonboard.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "yuzhao@chromium.org" <yuzhao@chromium.org>,
        "zwisler@chromium.org" <zwisler@chromium.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sean Cheng =?UTF-8?Q?=28=E9=84=AD=E6=98=87=E5=BC=98=29?= 
        <Sean.Cheng@mediatek.com>,
        "Sj Huang =?UTF-8?Q?=28=E9=BB=83=E4=BF=A1=E7=92=8B=29?=" 
        <sj.huang@mediatek.com>,
        Christie Yu =?UTF-8?Q?=28=E6=B8=B8=E9=9B=85=E6=83=A0=29?= 
        <christie.yu@mediatek.com>,
        Holmes Chiou =?UTF-8?Q?=28=E9=82=B1=E6=8C=BA=29?= 
        <holmes.chiou@mediatek.com>,
        Frederic Chen =?UTF-8?Q?=28=E9=99=B3=E4=BF=8A=E5=85=83=29?= 
        <Frederic.Chen@mediatek.com>,
        Jungo Lin =?UTF-8?Q?=28=E6=9E=97=E6=98=8E=E4=BF=8A=29?= 
        <jungo.lin@mediatek.com>,
        Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?= 
        <Rynn.Wu@mediatek.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date:   Thu, 21 Mar 2019 18:29:45 +0800
In-Reply-To: <1967d769-48c2-1d49-464a-6895cd2ff102@xs4all.nl>
References: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
         <1967d769-48c2-1d49-464a-6895cd2ff102@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans, Tomasz,

On Thu, 2019-03-14 at 16:40 +0800, Hans Verkuil wrote:
> Hi Jerry-ch Chen,
> 
> On 2/20/19 8:48 AM, Jerry-ch Chen wrote:
> > Hello,
> > 
> > This is the first version of the RFC patch series adding Face Detection
> > (FD) driver on Mediatek mt8183 SoC, which will be used in camera features
> > on CrOS application. It belongs to the first Mediatek's camera driver
> > series based on V4L2 and media controller framework. I posted the main part
> > of the FD driver as RFC to discuss first and would like some review
> > comments on the overall structure of the driver.
> > 
> > Face Detection (FD) unit provide hardware accelerated face detection
> > feature. It can detect different sizes of faces in a given image.
> > Furthermore, it has the capability to detect the faces of Rotation-in-Plane
> > from -180 to +180 degrees and Rotation-off-Plane from -90 to +90 degrees.
> > 
> > The driver is implemented with V4L2 and media controller framework. We have
> > the following entities describing the FD path.
> 
> Just a high-level comment before you post the next version of this series:
> 
> Please compile the latest version of v4l2-compliance (part of
> git://linuxtv.org/v4l-utils.git) and run it against your driver:
> 
> v4l2-compliance -m /dev/mediaX
> 
> Whenever you post a new version of this series, please do a 'git pull' of
> the v4l-utils repo, recompile and retest with v4l2-compliance and post the
> test results in the cover letter.
> 
> Obviously, there should be no FAILs and probably no warnings.
> 
> I suspect that streaming (e.g. adding the -s10 option to v4l2-compliance)
> probably won't work since v4l2-compliance doesn't know about the meta data
> formats.
> 
> Regards,
> 
> 	Hans
> 

Thanks for comments,
I am reworking FD driver based on general comments of P1 and DIP driver.
After that, I will upload the RFC V1 patch with the results of
v4l2-compliance in the cover-letter.

Best Regards,

	Jerry

> > 
> > 1. Meta input (output video device): connects to FD sub device. It accepts
> >    the input parameter buffer from userspace. The metadata interface used
> >    currently is only a temporary solution to kick off driver development
> >    and is not ready for reviewed yet.
> > 
> > 2. RAW (output video device): connects to FD sub device. It accepts input
> >    image buffer from userspace.
> > 
> > 3. FD (sub device): connects to Meta output. When processing an image,
> >    FD hardware only returns the statistics of detected faces so it needs
> >    only one capture video devices to return the streaming data to the user.
> > 
> > 4. Meta output (capture video device): Return the result of detected faces
> >    as metadata output.
> > 
> >    The overall file structure of the FD driver is as following:
> > 
> > * mtk_fd-dev-ctx-core.c: Implements common software flow of FD driver.
> > * mtk_fd-v4l2.c: Static FD contexts configuration.
> > * mtk_fd.c: Controls the hardware flow.
> > * mtk_fd-dev.c: Implements context-independent flow.
> > * mtk_fd-ctrl.c: Handles the HW ctrl request from userspace.
> > * mtk_fd-smem-drv.c: Provides the shared memory management required
> > operation. We reserved a memory region for the co-processor and FD to
> > exchange the hardware configuration data.
> > * mtk_fd-v4l2-util.c: Implements V4L2 and vb2 ops.
> > 
> > Jerry-ch Chen (7):
> >   dt-bindings: mt8183: Add binding for FD shared memory
> >   dts: arm64: mt8183: Add FD shared memory node
> >   dt-bindings: mt8183: Added FD-SMEM dt-bindings
> >   dt-bindings: mt8183: Added FD dt-bindings
> >   dts: arm64: mt8183: Add FD nodes
> >   media: platform: Add Mediatek FD driver KConfig
> >   platform: mtk-isp: Add Mediatek FD driver
> > 
> >  .../devicetree/bindings/media/mediatek,fd_smem.txt |   28 +
> >  .../bindings/media/mediatek,mt8183-fd.txt          |   30 +
> >  .../mediatek,reserve-memory-fd_smem.txt            |   44 +
> >  arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   28 +
> >  drivers/media/platform/Kconfig                     |    2 +
> >  drivers/media/platform/mtk-isp/Kconfig             |   10 +
> >  drivers/media/platform/mtk-isp/Makefile            |   16 +
> >  drivers/media/platform/mtk-isp/fd/Makefile         |   38 +
> >  drivers/media/platform/mtk-isp/fd/mtk_fd-core.h    |  157 +++
> >  drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h     |  299 ++++++
> >  .../platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c      |  917 +++++++++++++++++
> >  drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c     |  355 +++++++
> >  drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h     |  198 ++++
> >  .../media/platform/mtk-isp/fd/mtk_fd-smem-drv.c    |  452 +++++++++
> >  drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h    |   25 +
> >  .../media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c   | 1046 ++++++++++++++++++++
> >  drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c    |  115 +++
> >  drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h    |   36 +
> >  drivers/media/platform/mtk-isp/fd/mtk_fd.c         |  730 ++++++++++++++
> >  drivers/media/platform/mtk-isp/fd/mtk_fd.h         |  127 +++
> >  20 files changed, 4653 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek,fd_smem.txt
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-fd.txt
> >  create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-fd_smem.txt
> >  create mode 100644 drivers/media/platform/mtk-isp/Kconfig
> >  create mode 100644 drivers/media/platform/mtk-isp/Makefile
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/Makefile
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-core.h
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem-drv.c
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.c
> >  create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.h
> > 
> 


