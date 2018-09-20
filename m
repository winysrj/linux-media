Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:45741 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbeITJVX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 05:21:23 -0400
Received: by mail-io1-f65.google.com with SMTP id e12-v6so6246257iok.12
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 20:40:09 -0700 (PDT)
Received: from mail-it0-f50.google.com (mail-it0-f50.google.com. [209.85.214.50])
        by smtp.gmail.com with ESMTPSA id t64-v6sm394547ita.13.2018.09.19.20.40.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Sep 2018 20:40:08 -0700 (PDT)
Received: by mail-it0-f50.google.com with SMTP id h1-v6so10589173itj.4
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 20:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <1537314192-26892-1-git-send-email-vgarodia@codeaurora.org>
 <1537314192-26892-2-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MXMv_TD2dbxyM+D2p3pWfCJpQ-_FHK6WdkAEgBhwTdL6g@mail.gmail.com>
 <97b94b9b-f028-cb8b-a3db-67626dc517ab@linaro.org> <175fcecf3be715d2a20b71746c648f1e@codeaurora.org>
In-Reply-To: <175fcecf3be715d2a20b71746c648f1e@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 20 Sep 2018 12:31:39 +0900
Message-ID: <CAPBb6MUo6X+L7UYgmw8qUe_2CiZEBKGxaREFhZGRU1jGq0fO=g@mail.gmail.com>
Subject: Re: [PATCH v9 1/5] venus: firmware: add routine to reset ARM9
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2018 at 2:55 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> On 2018-09-19 20:30, Stanimir Varbanov wrote:
> > Hi Alex,
> >
> > On 09/19/2018 10:32 AM, Alexandre Courbot wrote:
> >> On Wed, Sep 19, 2018 at 8:43 AM Vikash Garodia
> >> <vgarodia@codeaurora.org> wrote:
> >>>
> >>> Add routine to reset the ARM9 and brings it out of reset. Also
> >>> abstract the Venus CPU state handling with a new function. This
> >>> is in preparation to add PIL functionality in venus driver.
> >>>
> >>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> >>> ---
> >>>  drivers/media/platform/qcom/venus/core.h         |  2 ++
> >>>  drivers/media/platform/qcom/venus/firmware.c     | 33
> >>> ++++++++++++++++++++++++
> >>>  drivers/media/platform/qcom/venus/firmware.h     | 11 ++++++++
> >>>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++-------
> >>>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 +++++
> >>>  5 files changed, 57 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/drivers/media/platform/qcom/venus/core.h
> >>> b/drivers/media/platform/qcom/venus/core.h
> >>> index 2f02365..dfd5c10 100644
> >>> --- a/drivers/media/platform/qcom/venus/core.h
> >>> +++ b/drivers/media/platform/qcom/venus/core.h
> >>> @@ -98,6 +98,7 @@ struct venus_caps {
> >>>   * @dev:               convenience struct device pointer
> >>>   * @dev_dec:   convenience struct device pointer for decoder device
> >>>   * @dev_enc:   convenience struct device pointer for encoder device
> >>> + * @no_tz:     a flag that suggests presence of trustzone
> >>
> >> Looks like it suggests the absence of trustzone?
> >>
> >> Actually I would rename it as use_tz and set it if TrustZone is used.
> >> This would avoid double-negative statements like what we see below.
> >
> > I find this suggestion reasonable.
>
> Initially i planned to keep it as a positive flag. The reason behind
> keeping it
> as no_tz was to keep the default value of this flag to 0 indicating tz
> is present
> by default.
> I can switch it to use_tz though and set it in firmware_init after the
> presence of
> firmware node is checked.

Making sure the flag is explicitly initialized instead of relying on
default initialization is another good reason to have that change
IMHO. :)

>
> >>
> >>>   * @lock:      a lock for this strucure
> >>>   * @instances: a list_head of all instances
> >>>   * @insts_count:       num of instances
> >>> @@ -129,6 +130,7 @@ struct venus_core {
> >>>         struct device *dev;
> >>>         struct device *dev_dec;
> >>>         struct device *dev_enc;
> >>> +       bool no_tz;
> >>>         struct mutex lock;
> >>>         struct list_head instances;
> >>>         atomic_t insts_count;
> >>> diff --git a/drivers/media/platform/qcom/venus/firmware.c
> >>> b/drivers/media/platform/qcom/venus/firmware.c
> >>> index c4a5778..f2ae2f0 100644
> >>> --- a/drivers/media/platform/qcom/venus/firmware.c
> >>> +++ b/drivers/media/platform/qcom/venus/firmware.c
> >>> @@ -22,10 +22,43 @@
> >>>  #include <linux/sizes.h>
> >>>  #include <linux/soc/qcom/mdt_loader.h>
> >>>
> >>> +#include "core.h"
> >>>  #include "firmware.h"
> >>> +#include "hfi_venus_io.h"
> >>>
> >>>  #define VENUS_PAS_ID                   9
> >>>  #define VENUS_FW_MEM_SIZE              (6 * SZ_1M)
> >>> +#define VENUS_FW_START_ADDR            0x0
> >>> +
> >>> +static void venus_reset_cpu(struct venus_core *core)
> >>> +{
> >>> +       void __iomem *base = core->base;
> >>> +
> >>> +       writel(0, base + WRAPPER_FW_START_ADDR);
> >>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_FW_END_ADDR);
> >>> +       writel(0, base + WRAPPER_CPA_START_ADDR);
> >>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_CPA_END_ADDR);
> >>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_START_ADDR);
> >>> +       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_END_ADDR);
> >>> +       writel(0x0, base + WRAPPER_CPU_CGC_DIS);
> >>> +       writel(0x0, base + WRAPPER_CPU_CLOCK_CONFIG);
> >>> +
> >>> +       /* Bring ARM9 out of reset */
> >>> +       writel(0, base + WRAPPER_A9SS_SW_RESET);
> >>> +}
> >>> +
> >>> +int venus_set_hw_state(struct venus_core *core, bool resume)
> >>> +{
> >>> +       if (!core->no_tz)
> >>
> >> This is the kind of double negative statement I was referring do
> >> above: "if we do not not have TrustZone". Turning it into
> >>
> >>     if (core->use_tz)
> >>
> >> would save the reader a few neurons. :)
> >>
> >>> +               return qcom_scm_set_remote_state(resume, 0);
> >>> +
> >>> +       if (resume)
> >>> +               venus_reset_cpu(core);
> >>> +       else
> >>> +               writel(1, core->base + WRAPPER_A9SS_SW_RESET);
> >>> +
> >>> +       return 0;
> >>> +}
> >>>
> >>>  int venus_boot(struct device *dev, const char *fwname)
> >>>  {
> >>> diff --git a/drivers/media/platform/qcom/venus/firmware.h
> >>> b/drivers/media/platform/qcom/venus/firmware.h
> >>> index 428efb5..397570c 100644
> >>> --- a/drivers/media/platform/qcom/venus/firmware.h
> >>> +++ b/drivers/media/platform/qcom/venus/firmware.h
> >>> @@ -18,5 +18,16 @@
> >>>
> >>>  int venus_boot(struct device *dev, const char *fwname);
> >>>  int venus_shutdown(struct device *dev);
> >>> +int venus_set_hw_state(struct venus_core *core, bool suspend);
> >>> +
> >>> +static inline int venus_set_hw_state_suspend(struct venus_core
> >>> *core)
> >>> +{
> >>> +       return venus_set_hw_state(core, false);
> >>> +}
> >>> +
> >>> +static inline int venus_set_hw_state_resume(struct venus_core *core)
> >>> +{
> >>> +       return venus_set_hw_state(core, true);
> >>> +}
> >>
> >> I think these two venus_set_hw_state_suspend() and
> >> venus_set_hw_state_resume() are superfluous, if you want to make the
> >> state explicit you can also define an enum { SUSPEND, RESUME } to use
> >> as argument of venus_set_hw_state() and call it directly.
> >
> > Infact this was by my request, and I wanted to avoid enum and have the
> > type of the action in the function name and also avoid one extra
> > function argument. Of course it is a matter of taste.

That's reasonable as well. I really don't feel strongly about this, so
please feel free to keep it as it is.
