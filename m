Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:35109 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbcLRGxV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 01:53:21 -0500
Received: by mail-vk0-f50.google.com with SMTP id w194so107463599vkw.2
        for <linux-media@vger.kernel.org>; Sat, 17 Dec 2016 22:53:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1481702690-10476-3-git-send-email-rick.chang@mediatek.com>
References: <1481702690-10476-1-git-send-email-rick.chang@mediatek.com> <1481702690-10476-3-git-send-email-rick.chang@mediatek.com>
From: Ricky Liang <jcliang@chromium.org>
Date: Sun, 18 Dec 2016 14:53:20 +0800
Message-ID: <CAAJzSMfb=_Td+_f-q0mOTX5dGFC1Roxxm7+-yjavKFo3DO8YUw@mail.gmail.com>
Subject: Re: [PATCH v9 2/4] vcodec: mediatek: Add Mediatek JPEG Decoder Driver
To: Rick Chang <rick.chang@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bin Liu <bin.liu@mediatek.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        srv_heupstream@mediatek.com,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC..."
        <linux-mediatek@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..."
        <linux-arm-kernel@lists.infradead.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 14, 2016 at 4:04 PM, Rick Chang <rick.chang@mediatek.com> wrote:
> Add v4l2 driver for Mediatek JPEG Decoder
>
> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  drivers/media/platform/Kconfig                   |   15 +
>  drivers/media/platform/Makefile                  |    2 +
>  drivers/media/platform/mtk-jpeg/Makefile         |    2 +
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c  | 1306 ++++++++++++++++++++++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h  |  139 +++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c    |  417 +++++++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h    |   91 ++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c |  160 +++
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h |   25 +
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h   |   58 +
>  10 files changed, 2215 insertions(+)

Reviewed-by: Ricky Liang <jcliang@chromium.org>
Tested-by: Ricky Liang <jcliang@chromium.org>
