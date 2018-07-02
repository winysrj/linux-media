Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:55332 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753148AbeGBIpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:45:38 -0400
Received: by mail-it0-f66.google.com with SMTP id 16-v6so11026566itl.5
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:45:37 -0700 (PDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com. [209.85.223.177])
        by smtp.gmail.com with ESMTPSA id x8-v6sm3009770ith.17.2018.07.02.01.45.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:45:35 -0700 (PDT)
Received: by mail-io0-f177.google.com with SMTP id k3-v6so14045855iog.3
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 2 Jul 2018 17:45:24 +0900
Message-ID: <CAPBb6MXH7BpOXW++TxgsdRBr5C7PsHLO8jZtysGiNwUbkNW+BQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/27] Venus updates
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

Thanks for this very well organized series and sorry for not giving
feedback earlier.

I have tested this version against the 4.14 Chrome OS kernel tree (+ a
few extra changes to comply with the codec API) and it was working
flawlessly.

Therefore,

Tested-by: Alexandre Courbot <acourbot@chromium.org>

For the whole series.

I have a few comments/questions on some patches, would be great if you
could take a look. Also wondering what is your plan regarding codec
API compliance? Do you plan to integrate it into the current series,
or work on it after merging this initial work? Both ways would be ok
as far as I am concerned.

Cheers,
Alex.


On Thu, Jun 28, 2018 at 12:27 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi,
>
> Here is v4 with following changes:
>
> - fixed kbuild test robot in 12/27.
> - fixed destination of memcpy in fill_xxx functions.
>
> v3 can be found at https://lkml.org/lkml/2018/6/13/464
>
> regards,
> Stan
>
> Stanimir Varbanov (27):
>   venus: hfi_msgs: correct pointer increment
>   venus: hfi: preparation to support venus 4xx
>   venus: hfi: update sequence event to handle more properties
>   venus: hfi_cmds: add set_properties for 4xx version
>   venus: hfi: support session continue for 4xx version
>   venus: hfi: handle buffer output2 type as well
>   venus: hfi_venus: add halt AXI support for Venus 4xx
>   venus: hfi_venus: fix suspend function for venus 3xx versions
>   venus: hfi_venus: move set of default properties to core init
>   venus: hfi_venus: add suspend functionality for Venus 4xx
>   venus: core,helpers: add two more clocks found in Venus 4xx
>   venus: hfi_parser: add common capability parser
>   venus: helpers: rename a helper function and use buffer mode from caps
>   venus: helpers: add a helper function to set dynamic buffer mode
>   venus: helpers: add helper function to set actual buffer size
>   venus: core: delete not used buffer mode flags
>   venus: helpers: add buffer type argument to a helper
>   venus: helpers: add a new helper to set raw format
>   venus: helpers,vdec,venc: add helpers to set work mode and core usage
>   venus: helpers: extend set_num_bufs helper with one more argument
>   venus: helpers: add a helper to return opb buffer sizes
>   venus: vdec: get required input buffers as well
>   venus: vdec: a new function for output configuration
>   venus: helpers: move frame size calculations on common place
>   venus: implementing multi-stream support
>   venus: core: add sdm845 DT compatible and resource data
>   venus: add HEVC codec support
>
>  .../devicetree/bindings/media/qcom,venus.txt       |   1 +
>  drivers/media/platform/qcom/venus/Makefile         |   3 +-
>  drivers/media/platform/qcom/venus/core.c           | 107 ++++
>  drivers/media/platform/qcom/venus/core.h           | 100 ++--
>  drivers/media/platform/qcom/venus/helpers.c        | 555 +++++++++++++++++++--
>  drivers/media/platform/qcom/venus/helpers.h        |  23 +-
>  drivers/media/platform/qcom/venus/hfi.c            |  12 +-
>  drivers/media/platform/qcom/venus/hfi.h            |  10 +
>  drivers/media/platform/qcom/venus/hfi_cmds.c       |  62 ++-
>  drivers/media/platform/qcom/venus/hfi_helper.h     | 112 ++++-
>  drivers/media/platform/qcom/venus/hfi_msgs.c       | 399 +++------------
>  drivers/media/platform/qcom/venus/hfi_parser.c     | 278 +++++++++++
>  drivers/media/platform/qcom/venus/hfi_parser.h     |  45 ++
>  drivers/media/platform/qcom/venus/hfi_venus.c      | 109 +++-
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |  10 +
>  drivers/media/platform/qcom/venus/vdec.c           | 326 +++++++-----
>  drivers/media/platform/qcom/venus/venc.c           | 220 ++++----
>  17 files changed, 1694 insertions(+), 678 deletions(-)
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.h
>
> --
> 2.14.1
>
