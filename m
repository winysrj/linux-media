Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9014CC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60FCB21019
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfCNImZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:42:25 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:49322 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfCNImZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 04:42:25 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 4LwRhq6v7LMwI4LwUhHryD; Thu, 14 Mar 2019 09:42:22 +0100
Subject: Re: [RFC PATCH V0 0/4] media: support Mediatek sensor interface
 driver
To:     Louis Kuo <louis.kuo@mediatek.com>, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com, tfiga@chromium.org,
        matthias.bgg@gmail.com, mchehab@kernel.org
Cc:     yuzhao@chromium.org, zwisler@chromium.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, frederic.chen@mediatek.com,
        Jerry-ch.Chen@mediatek.com, jungo.lin@mediatek.com,
        Rynn.Wu@mediatek.com, linux-media@vger.kernel.org,
        srv_heupstream@mediatek.com, devicetree@vger.kernel.org
References: <1550733718-31702-1-git-send-email-louis.kuo@mediatek.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d65ff907-51af-cf95-9f95-84aef95af505@xs4all.nl>
Date:   Thu, 14 Mar 2019 09:42:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1550733718-31702-1-git-send-email-louis.kuo@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLxRG6nObLX6d2xH2/mPoPng0pfQqN68BBtLrehZ9Ug2g28Uui4RSZzeF0urBYRNVS+i5HzS+ttMYbvWbo0QkQ9AIY1XvFU7rFvnvu23PH5lqmrxuTPs
 yxH0wzVn4kB9k96AyJQgoSG9t5f0WuhgWszpgrO8vJja3YXdQmLpc/BxV5BGnTEu+ZAWMhRRdiVpiGvFztli/PqpZvyHOHCdqju5aENMeOJSanvh4sjSHpvm
 yL9n7gNGKFDd3D4sYD2QcqfCYvudBfqQxj68nyKpZ6PT3Df/Lsn50GEJ9q7dlPIWcFmZsQ1OjCD/VGPOBuK0ieiW3KLuaKhLzU/8XXKOXZXoyZ55WzJYfIVe
 /C43IOBQBsSgJQg5aZOqDlzv/FLxbgIszpUFJRFRjLs5ObllkQiyT8iZsTn/ipinsBAZPQg+U/vAXfBLMi/tobydaH0ms5x/NYphbIFUJ6WE9sKAJPEAZJgy
 aDusrJ75wy1WK3O9dtA2iJ8vfO9uPgUmv+MULymH7lfT1ghUYvfFnp0DLXObux+Y+eqM5xouUqDt5+q8XkPYKqvtaAKxQupCw5v/R3HgCo0Dw5ENP3yU8QLW
 j28YfbBh9KMLpgmOnPwa6yyUF19V0Y5/I4ceZ3HQdcAOVQFuwGtALImCMR9WStRbjccKKBjnVT4Um3/0XaFsu7CmjT+qLZVv0K+k/gDSpFHlgcwGM5KRBkaY
 l8ZUuRP8tU7T/s6KfhGMNvFRP6i4ia9Lf2OoZVSPHkQs3JGavI2xTdsLX/segpXWWOdJIhiXUBZj8THIUv4Jmrry59dAjuvh9uNSxYzJ1tTZ7NwZ/Gr7j6Uh
 WsefDGzT5dxT7UMBQC1vX3hva99wnDcH+7Cgvxbq6tg9YTstypMVEfrxK5XoR67b9ALoLefUUbShhGsZKFa4kxftiGYPfRpDpnQwri4obK0lT993pIlmEfex
 MpdocQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Louis Kuo,

On 2/21/19 8:21 AM, Louis Kuo wrote:
> Hello,
> 
> This is the first version of the RFC patch series adding Sensor Inferface(seninf) driver on
> Mediatek mt8183 SoC, which will be used in camera features on CrOS application.
> It belongs to the first Mediatek's camera driver series based on V4L2 and media controller framework.
> I posted the main part of the seninf driver as RFC to discuss first and would like some review comments
> on the overall structure of the driver.
> 
> The driver is implemented with V4L2 framework.
> 1. Register as a V4L2 sub-device.
> 2. Only one entity with sink pads linked to camera sensors for choosing desired camera sensor by setup link
>    and with source pads linked to cam-io for routing different types of decoded packet datas to PASS1 driver
>    to generate sensor image frame and meta-data.

Just a high-level comment before you post the next version of this series:

Please compile the latest version of v4l2-compliance (part of
git://linuxtv.org/v4l-utils.git) and run it against your driver:

v4l2-compliance -d /dev/videoX -s10 -f

Whenever you post a new version of this series, please do a 'git pull' of
the v4l-utils repo, recompile and retest with v4l2-compliance and post the
test results in the cover letter.

Obviously, there should be no FAILs and probably no warnings.

Regards,

	Hans

> 
> The overall file structure of the seninf driver is as following:
> 
> * mtk_seninf.c: Implement software and HW control flow of seninf driver.
> * seninf_drv_def.h: Define data structure and enumeration.
> * seninf_reg.h: Define HW register R/W macros and HW register names.
> 
> Louis Kuo (4):
>   media: platform: mtk-isp: Add Mediatek sensor interface driver
>   media: platform: Add Mediatek sensor interface driver KConfig
>   dt-bindings: mt8183: Added sensor interface dt-bindings
>   dts: arm64: mt8183: Add sensor interface nodes
> 
>  .../devicetree/bindings/media/mediatek-seninf.txt  |   52 +
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   34 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/mtk-isp/Kconfig             |   16 +
>  drivers/media/platform/mtk-isp/Makefile            |   14 +
>  drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
>  .../media/platform/mtk-isp/isp_50/seninf/Makefile  |    4 +
>  .../platform/mtk-isp/isp_50/seninf/mtk_seninf.c    | 1339 ++++++++++++++++++++
>  .../mtk-isp/isp_50/seninf/seninf_drv_def.h         |  201 +++
>  .../platform/mtk-isp/isp_50/seninf/seninf_reg.h    |  992 +++++++++++++++
>  10 files changed, 2671 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-seninf.txt
>  create mode 100644 drivers/media/platform/mtk-isp/Kconfig
>  create mode 100644 drivers/media/platform/mtk-isp/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/Makefile
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/mtk_seninf.c
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/seninf_drv_def.h
>  create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/seninf_reg.h
> 

