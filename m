Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66ED5C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22851204FD
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfCNIhb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:37:31 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47623 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbfCNIha (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 04:37:30 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 4Lrdhq4vlLMwI4LrghHqq9; Thu, 14 Mar 2019 09:37:28 +0100
Subject: Re: [RFC v1 0/4] media: mediatek: support mdp3 on mt8183 platform
To:     Daoyuan Huang <daoyuan.huang@mediatek.com>,
        laurent.pinchart+renesas@ideasonboard.com, tfiga@chromium.org,
        matthias.bgg@gmail.com, mchehab@kernel.org
Cc:     yuzhao@chromium.org, zwisler@chromium.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, frederic.chen@mediatek.com,
        Jerry-ch.Chen@mediatek.com, jungo.lin@mediatek.com,
        Rynn.Wu@mediatek.com, linux-media@vger.kernel.org,
        srv_heupstream@mediatek.com, devicetree@vger.kernel.org,
        ping-hsun.wu@mediatek.com
References: <1552024160-33055-1-git-send-email-daoyuan.huang@mediatek.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <176c023b-d734-c5a0-bf40-e190eff00278@xs4all.nl>
Date:   Thu, 14 Mar 2019 09:37:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1552024160-33055-1-git-send-email-daoyuan.huang@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNiVOH6qbiOqPsLfxXr17xsaF2A/EreR7lAZmr7S24uVJMiiq43dDScXdKRVLPpBXE9IETxKuiH8gilq0XgB+AiGteU+1B5MpZj3IVU6Z0Wz18zV6jLR
 25Rkd3MNWihbsFeDqDzyfWDZZ6r3kLRiIJ4fjZGoPLxzih83X2scECMZRM01Ku1PbbY0Q9C6vbvUWCRGPZvvEU5Y8n+zt/0i/+dqSaRBZ+P0L9ZOyEXcN8Q2
 Xzl2T1Kt0we6/tnhDqCBZg07oDyGtMkI4gNEaBVMhcAODz2NARjTQOoPtvtG5wTNliU+fbSPpBaeuPu9EegIPdh66MlTpJCOs5rjWdHXNS06i8aEhThIV6vF
 QMDj06jD6pXl3OpspVOB4lFMvmVuGAFE4sjm875RoLW5ZqAOlnBXuewzWTY1NmnWy9cGbKT/LtcneVzFhGYpCbwWCgFK5F4tTFM/stIzBEIOqOyX5y1yA+St
 sXFDDGVEtWVSjVolCbWdtziuba106gZr3tc+YYJRoIQP01a3i0/KbUFfWa7jZ13oTGG354ym7nzdRlBMMgj8r3o7mQiPLJRHlKrbVLjhD7apCnZXI3k1oPY/
 wLL634W7/JS79M88EA893i2MhLUqL3TSC9mJpxq03XlE3rCxp0uAcQUta1Oq91g9Ba1UZ2jAmeJctoe+RX6uuGSdePI0LqFvPzD2FCpMFs/Dxy270tGfcAPk
 6Fb0tMeMC+yDNP9m79/ND1Qn2EuPVPGWdA1m1ODJItyTrc4SXwvyNjXZ0wdmw4KYgAmbLHaOrDG6SU4j5K2/TMgw7Tn3Hg66V/D0Ffq6w7QV5/rIyA1zdrNp
 8TyXqz/EOk1jEVP/5Bc/2QtHGHvS+Sbhir3p6jXMG3pP+nw+UCRth/iQU35d/ZTuqsmg4E27SMU0JbzzehTCRe1nFTuJcQj+nPloIoPEnEp8B/r2o7uSrmYI
 3c8k2A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Daoyuan Huang,

On 3/8/19 6:49 AM, Daoyuan Huang wrote:
> From: daoyuan huang <daoyuan.huang@mediatek.com>
> 
> This is the first version of RFC patch for Media Data Path 3 (MDP3),
> MDP3 is used for scaling and color format conversion.
> support using GCE to write register in critical time limitation.
> support V4L2 m2m device control.

Just a high-level comment before you post the next version of this series:

Please compile the latest version of v4l2-compliance (part of
git://linuxtv.org/v4l-utils.git) and run it against your driver:

v4l2-compliance -d /dev/videoX -s10 -f

(I hope the -f option works, it tests all combinations of pixelformats, but those
tests are new so there may be issues, just let me know if that's the case).

Whenever you post a new version of this series, please do a 'git pull' of
the v4l-utils repo, recompile and retest with v4l2-compliance and post the
test results in the cover letter.

Obviously, there should be no FAILs and probably no warnings.

Regards,

	Hans

> 
> ---
> Based on v5.0-rc1 and these series:
> device tree:
> http://lists.infradead.org/pipermail/linux-mediatek/2019-February/017570.html
> clock control:
> http://lists.infradead.org/pipermail/linux-mediatek/2019-February/017320.html
> system control processor (SCP):
> http://lists.infradead.org/pipermail/linux-mediatek/2019-February/017774.html
> global command engine (GCE):
> http://lists.infradead.org/pipermail/linux-mediatek/2019-January/017143.html
> ---
> 
> daoyuan huang (4):
>   dt-binding: mt8183: Add Mediatek MDP3 dt-bindings
>   dts: arm64: mt8183: Add Mediatek MDP3 nodes
>   media: platform: Add Mediatek MDP3 driver KConfig
>   media: platform: mtk-mdp3: Add Mediatek MDP3 driver
> 
>  .../bindings/media/mediatek,mt8183-mdp3.txt        |  217 ++++
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi           |  109 ++
>  drivers/media/platform/Kconfig                     |   18 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/mtk-mdp3/Makefile           |    9 +
>  drivers/media/platform/mtk-mdp3/isp_reg.h          |   38 +
>  drivers/media/platform/mtk-mdp3/mdp-platform.h     |   67 ++
>  drivers/media/platform/mtk-mdp3/mdp_reg_ccorr.h    |   76 ++
>  drivers/media/platform/mtk-mdp3/mdp_reg_rdma.h     |  207 ++++
>  drivers/media/platform/mtk-mdp3/mdp_reg_rsz.h      |  110 ++
>  drivers/media/platform/mtk-mdp3/mdp_reg_wdma.h     |  126 +++
>  drivers/media/platform/mtk-mdp3/mdp_reg_wrot.h     |  116 ++
>  drivers/media/platform/mtk-mdp3/mmsys_config.h     |  189 ++++
>  drivers/media/platform/mtk-mdp3/mmsys_mutex.h      |   36 +
>  drivers/media/platform/mtk-mdp3/mmsys_reg_base.h   |   39 +
>  drivers/media/platform/mtk-mdp3/mtk-img-ipi.h      |  272 +++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.c    |  407 +++++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.h    |   52 +
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.c    | 1180 ++++++++++++++++++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.h    |  176 +++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-core.c    |  257 +++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-core.h    |   89 ++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.c     |  784 +++++++++++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.h     |   52 +
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.c    |  778 +++++++++++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.h    |  382 +++++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.c     |  277 +++++
>  drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.h     |   90 ++
>  28 files changed, 6155 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-mdp3.txt
>  create mode 100644 drivers/media/platform/mtk-mdp3/Makefile
>  create mode 100644 drivers/media/platform/mtk-mdp3/isp_reg.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mdp-platform.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_ccorr.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_rdma.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_rsz.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_wdma.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_wrot.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mmsys_config.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mmsys_mutex.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mmsys_reg_base.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-img-ipi.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.c
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.c
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-core.c
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-core.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.c
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.c
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.h
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.c
>  create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.h
> 

