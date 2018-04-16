Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35243 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbeDPRcM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 13:32:12 -0400
Received: by mail-ot0-f195.google.com with SMTP id f47-v6so18303200oth.2
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 10:32:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523884614.5918.12.camel@pengutronix.de>
References: <1520081790-3437-1-git-send-email-festevam@gmail.com> <1523884614.5918.12.camel@pengutronix.de>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 16 Apr 2018 14:32:11 -0300
Message-ID: <CAOMZO5CANmvqVVw2=aooT1PxjdBaThY1OK9wStKsgqF8F3t37Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] media: imx-media-csi: Fix inconsistent IS_ERR and PTR_ERR
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 16, 2018 at 10:16 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> The second patch is applied now, but this part is still missing in
> v4.17-rc1, causing the CSI subdev probe to fail:
>
>   imx-ipuv3-csi: probe of imx-ipuv3-csi.0 failed with error -1369528304
>   imx-ipuv3-csi: probe of imx-ipuv3-csi.1 failed with error -1369528304
>   imx-ipuv3-csi: probe of imx-ipuv3-csi.5 failed with error -1369528304
>   imx-ipuv3-csi: probe of imx-ipuv3-csi.6 failed with error -1369528304

Yes, this original patch does not apply against 4.17-rc1 anymore, so I
rebased and resend it.

Thanks
