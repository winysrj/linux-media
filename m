Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:39313 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750774AbdCOCRs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 22:17:48 -0400
Message-ID: <1489544252.27174.1.camel@mtksdaap41>
Subject: Re: [PATCH] media: mtk-jpeg: fix continuous log "Context is NULL"
From: Rick Chang <rick.chang@mediatek.com>
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Bin Liu <bin.liu@mediatek.com>
Date: Wed, 15 Mar 2017 10:17:32 +0800
In-Reply-To: <1489501282-52137-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1489501282-52137-1-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-03-14 at 22:21 +0800, Minghsiu Tsai wrote:
> The symptom is continuous log "mtk-jpeg 18004000.jpegdec: Context is NULL"
> in kernel log. It is becauese the error handling in irq doesn't clear
> interrupt.
> 
> The calling flow like as below when issue happen
> mtk_jpeg_device_run()
> mtk_jpeg_job_abort()
>   v4l2_m2m_job_finish() -> m2m_dev->curr_ctx = NULL;
> mtk_jpeg_dec_irq()
>   v4l2_m2m_get_curr_priv()
>      -> m2m_dev->curr_ctx == NULL
>      -> return NULL
> log "Context is NULL"
> 
> There is race condition between job_abort() and irq. In order to simplify
> code, don't want to add extra flag to maintain state, empty job_abort() and
> clear interrupt before v4l2_m2m_get_curr_priv() in irq.
> 
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
Acked-by: Rick Chang <rick.chang@mediatek.com>
