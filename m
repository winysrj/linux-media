Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:39500 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHXLMi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:12:38 -0400
Received: by mail-io0-f195.google.com with SMTP id l7-v6so6415689iok.6
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:14 -0700 (PDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com. [209.85.214.46])
        by smtp.gmail.com with ESMTPSA id 20-v6sm330390itk.28.2018.08.24.00.39.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Aug 2018 00:39:12 -0700 (PDT)
Received: by mail-it0-f46.google.com with SMTP id x79-v6so4583283ita.1
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org> <1535034528-11590-2-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1535034528-11590-2-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 24 Aug 2018 16:38:59 +0900
Message-ID: <CAPBb6MUZawT84Wcrhi+MEyn+zSCWOpn_iOZMMudZz+_Urixsrw@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] venus: firmware: add routine to reset ARM9
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> Add routine to reset the ARM9 and brings it out of reset. Also
> abstract the Venus CPU state handling with a new function. This
> is in preparation to add PIL functionality in venus driver.
>
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.h         |  2 ++
>  drivers/media/platform/qcom/venus/firmware.c     | 33 ++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h     | 11 ++++++++
>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++-------
>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 +++++
>  5 files changed, 57 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 2f02365..dfd5c10 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -98,6 +98,7 @@ struct venus_caps {
>   * @dev:               convenience struct device pointer
>   * @dev_dec:   convenience struct device pointer for decoder device
>   * @dev_enc:   convenience struct device pointer for encoder device
> + * @no_tz:     a flag that suggests presence of trustzone
>   * @lock:      a lock for this strucure
>   * @instances: a list_head of all instances
>   * @insts_count:       num of instances
> @@ -129,6 +130,7 @@ struct venus_core {
>         struct device *dev;
>         struct device *dev_dec;
>         struct device *dev_enc;
> +       bool no_tz;
>         struct mutex lock;
>         struct list_head instances;
>         atomic_t insts_count;
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index c4a5778..a9d042e 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -22,10 +22,43 @@
>  #include <linux/sizes.h>
>  #include <linux/soc/qcom/mdt_loader.h>
>
> +#include "core.h"
>  #include "firmware.h"
> +#include "hfi_venus_io.h"
>
>  #define VENUS_PAS_ID                   9
>  #define VENUS_FW_MEM_SIZE              (6 * SZ_1M)

This is making a strong assumption about the size of the FW memory
region, which in practice is not always true (I had to reduce it to
5MB). How about having this as a member of venus_core, which is
initialized in venus_load_fw() from the actual size of the memory
region? You could do this as an extra patch that comes before this
one.
