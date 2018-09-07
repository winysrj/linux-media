Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41707 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbeIGMsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 08:48:52 -0400
Received: by mail-yb1-f195.google.com with SMTP id u33-v6so5150359ybi.8
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 01:09:05 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id e204-v6sm2809886ywc.86.2018.09.07.01.09.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Sep 2018 01:09:04 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id 14-v6so5106798ywe.2
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 01:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <20180831074743.235010-1-acourbot@chromium.org>
In-Reply-To: <20180831074743.235010-1-acourbot@chromium.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 7 Sep 2018 17:08:52 +0900
Message-ID: <CAAFQd5ApyTYdyo4Hpo=+60gD2Jm-aWJ9SJgjm4oM8i7E-h6Nog@mail.gmail.com>
Subject: Re: [RFC PATCH] media: docs-rst: Document m2m stateless video decoder interface
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

+Maxime Ripard +Ezequiel Garcia +Nicolas Dufresne

On Fri, Aug 31, 2018 at 4:48 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> This patch documents the protocol that user-space should follow when
> communicating with stateless video decoders. It is based on the
> following references:
>
> * The current protocol used by Chromium (converted from config store to
>   request API)
>
> * The submitted Cedrus VPU driver
>
> As such, some things may not be entirely consistent with the current
> state of drivers, so it would be great if all stakeholders could point
> out these inconsistencies. :)
>
> This patch is supposed to be applied on top of the Request API V18 as
> well as the memory-to-memory video decoder interface series by Tomasz
> Figa.
>
> It should be considered an early RFC.

Thanks a lot for working on this. I'll review this patch a bit later,
but let me post links to patches on which we had some earlier
discussions, to keep things together:

https://patchwork.kernel.org/patch/10462311/
https://patchwork.kernel.org/patch/10577969/

Also CCd folks who discussed there.

Best regards,
Tomasz
