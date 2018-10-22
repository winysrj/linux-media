Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43767 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbeJVOI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 10:08:58 -0400
Received: by mail-oi1-f194.google.com with SMTP id s69-v6so31192558oie.10
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 22:51:56 -0700 (PDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com. [209.85.167.176])
        by smtp.gmail.com with ESMTPSA id v124-v6sm10512090oie.48.2018.10.21.22.51.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Oct 2018 22:51:55 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id 22-v6so31249486oiz.2
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 22:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <1539782303-4091-1-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1539782303-4091-1-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 22 Oct 2018 14:51:43 +0900
Message-ID: <CAPBb6MWxUNyJEkAUATa7BiXgU1JefoxFseXuaLb+_XsLish8Pw@mail.gmail.com>
Subject: Re: [PATCH v12 0/5] Venus updates - PIL
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On Wed, Oct 17, 2018 at 10:18 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> This version of the series
> * updates the tz flag to unsigned
>
> Stanimir Varbanov (1):
>   venus: firmware: register separate platform_device for firmware loader
>
> Vikash Garodia (4):
>   venus: firmware: add routine to reset ARM9
>   venus: firmware: move load firmware in a separate function
>   venus: firmware: add no TZ boot and shutdown routine
>   dt-bindings: media: Document bindings for venus firmware device
>
>  .../devicetree/bindings/media/qcom,venus.txt       |  14 +-
>  drivers/media/platform/qcom/venus/core.c           |  24 ++-
>  drivers/media/platform/qcom/venus/core.h           |   6 +
>  drivers/media/platform/qcom/venus/firmware.c       | 235 +++++++++++++++++++--
>  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
>  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
>  7 files changed, 274 insertions(+), 43 deletions(-)

The series:

Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
Tested-by: Alexandre Courbot <acourbot@chromium.org>
