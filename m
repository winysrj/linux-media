Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42211 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbeJWJPY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 05:15:24 -0400
Received: by mail-yb1-f194.google.com with SMTP id o204-v6so2952046yba.9
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 17:54:29 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id j196-v6sm821421ywg.81.2018.10.22.17.54.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 17:54:27 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id n140-v6so2121534yba.1
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 17:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <6621f3b9-a5a0-d33f-306f-d405db34da2c@xs4all.nl>
In-Reply-To: <6621f3b9-a5a0-d33f-306f-d405db34da2c@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 23 Oct 2018 09:54:14 +0900
Message-ID: <CAAFQd5DWnk4+7bF7Ju=stzh44_2k9dAXnDJMyaTsxBf3Tx_oMg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Document memory-to-memory video codec interfaces
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Oct 23, 2018 at 12:41 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Tomasz, Alexandre,
>
> Thank you for all your work! Much appreciated.
>
> I've applied both the stateful and stateless patches on top of the request_api branch
> and made the final result available here:
>
> https://hverkuil.home.xs4all.nl/request-api/
>
> Tomasz, I got two warnings when building the doc tree, the patch below fixes it.
>
> Regards,
>
>         Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
> index 09c7a6621b8e..5522453ac39f 100644
> --- a/Documentation/media/uapi/v4l/dev-decoder.rst
> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
> @@ -972,11 +972,11 @@ sequence was started.
>
>     .. warning::
>
> -   The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues

This should also have been s/sentence/sequence/.

> -   are streaming. For compatibility reasons, the call to
> -   :c:func:`VIDIOC_DECODER_CMD` will not fail even if any of the queues is not
> -   streaming, but at the same time it will not initiate the `Drain` sequence
> -   and so the steps described below would not be applicable.
> +      The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues
> +      are streaming. For compatibility reasons, the call to
> +      :c:func:`VIDIOC_DECODER_CMD` will not fail even if any of the queues is not
> +      streaming, but at the same time it will not initiate the `Drain` sequence
> +      and so the steps described below would not be applicable.
>
>  2. Any ``OUTPUT`` buffers queued by the client before the
>     :c:func:`VIDIOC_DECODER_CMD` was issued will be processed and decoded as
> diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst b/Documentation/media/uapi/v4l/dev-encoder.rst
> index 41139e5e48eb..7f49a7149067 100644
> --- a/Documentation/media/uapi/v4l/dev-encoder.rst
> +++ b/Documentation/media/uapi/v4l/dev-encoder.rst
> @@ -448,11 +448,11 @@ sequence was started.
>
>     .. warning::
>
> -   The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues

Ditto.

> -   are streaming. For compatibility reasons, the call to
> -   :c:func:`VIDIOC_ENCODER_CMD` will not fail even if any of the queues is not
> -   streaming, but at the same time it will not initiate the `Drain` sequence
> -   and so the steps described below would not be applicable.
> +      The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues
> +      are streaming. For compatibility reasons, the call to
> +      :c:func:`VIDIOC_ENCODER_CMD` will not fail even if any of the queues is not
> +      streaming, but at the same time it will not initiate the `Drain` sequence
> +      and so the steps described below would not be applicable.

Last minute changes after proof reading...

Thanks for fixing up and uploading the html version!

Best regards,
Tomasz
