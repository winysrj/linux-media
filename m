Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:37249 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756834AbeDXLKB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 07:10:01 -0400
Received: by mail-ot0-f182.google.com with SMTP id 77-v6so14672430otd.4
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 04:10:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180424103303.rrgv2d33stnll2cx@valkosipuli.retiisi.org.uk>
References: <1522335300-13467-1-git-send-email-manivannan.sadhasivam@linaro.org>
 <1522335300-13467-2-git-send-email-manivannan.sadhasivam@linaro.org>
 <CAMZdPi-VCsct6S4cYCvN_XniFB9=pJqC8hnTdQnvL5H_CU2a8Q@mail.gmail.com> <20180424103303.rrgv2d33stnll2cx@valkosipuli.retiisi.org.uk>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Tue, 24 Apr 2018 13:09:20 +0200
Message-ID: <CAMZdPi_kaMp_gqoKOiRvkB2kmk0hDtLBZP66DvjOXKU_Xnuk6w@mail.gmail.com>
Subject: Re: [RESEND PATCH] media: i2c: ov5640: Add pixel clock support
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        slongerbeam@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        dragonboard@lists.96boards.org,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

>> Any comments on this change?
>
> <URL:https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Maxime+Ripard&state=*&q=ov5640>
>
> There's also another set that adds PIXEL_CLOCK (as well as LINK_FREQ)
> support to the driver, that seems more complete than this patch but
> requires a rebase on Maxime's patches:
>
> <URL:https://patchwork.linuxtv.org/project/linux-media/list/?submitter=7218&state=*&q=ov5640>

Thanks, I've just see this patch series. Indeed, patch will need a
rework/rebase.

Regards,
Loic
