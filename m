Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34218 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbeH0GtI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 02:49:08 -0400
Received: by mail-io0-f193.google.com with SMTP id c22-v6so11722696iob.1
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2018 20:04:29 -0700 (PDT)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com. [209.85.214.54])
        by smtp.gmail.com with ESMTPSA id k18-v6sm5074649iom.73.2018.08.26.20.04.27
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Aug 2018 20:04:27 -0700 (PDT)
Received: by mail-it0-f54.google.com with SMTP id p129-v6so8754729ite.3
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2018 20:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-2-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MUZawT84Wcrhi+MEyn+zSCWOpn_iOZMMudZz+_Urixsrw@mail.gmail.com> <51cc9d6b-0483-76a6-d413-3f5cc63f3f56@linaro.org>
In-Reply-To: <51cc9d6b-0483-76a6-d413-3f5cc63f3f56@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 27 Aug 2018 12:04:15 +0900
Message-ID: <CAPBb6MWMQeXAabnis0iJxE91MCSscacbim3T_K6VF6OODw5TuQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] venus: firmware: add routine to reset ARM9
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: vgarodia@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
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

On Fri, Aug 24, 2018 at 5:57 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> On 08/24/2018 10:38 AM, Alexandre Courbot wrote:
> > On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
> >>
> >> Add routine to reset the ARM9 and brings it out of reset. Also
> >> abstract the Venus CPU state handling with a new function. This
> >> is in preparation to add PIL functionality in venus driver.
> >>
> >> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/core.h         |  2 ++
> >>  drivers/media/platform/qcom/venus/firmware.c     | 33 ++++++++++++++++++++++++
> >>  drivers/media/platform/qcom/venus/firmware.h     | 11 ++++++++
> >>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++-------
> >>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 +++++
> >>  5 files changed, 57 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> >> index 2f02365..dfd5c10 100644
> >> --- a/drivers/media/platform/qcom/venus/core.h
> >> +++ b/drivers/media/platform/qcom/venus/core.h
> >> @@ -98,6 +98,7 @@ struct venus_caps {
> >>   * @dev:               convenience struct device pointer
> >>   * @dev_dec:   convenience struct device pointer for decoder device
> >>   * @dev_enc:   convenience struct device pointer for encoder device
> >> + * @no_tz:     a flag that suggests presence of trustzone
> >>   * @lock:      a lock for this strucure
> >>   * @instances: a list_head of all instances
> >>   * @insts_count:       num of instances
> >> @@ -129,6 +130,7 @@ struct venus_core {
> >>         struct device *dev;
> >>         struct device *dev_dec;
> >>         struct device *dev_enc;
> >> +       bool no_tz;
> >>         struct mutex lock;
> >>         struct list_head instances;
> >>         atomic_t insts_count;
> >> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> >> index c4a5778..a9d042e 100644
> >> --- a/drivers/media/platform/qcom/venus/firmware.c
> >> +++ b/drivers/media/platform/qcom/venus/firmware.c
> >> @@ -22,10 +22,43 @@
> >>  #include <linux/sizes.h>
> >>  #include <linux/soc/qcom/mdt_loader.h>
> >>
> >> +#include "core.h"
> >>  #include "firmware.h"
> >> +#include "hfi_venus_io.h"
> >>
> >>  #define VENUS_PAS_ID                   9
> >>  #define VENUS_FW_MEM_SIZE              (6 * SZ_1M)
> >
> > This is making a strong assumption about the size of the FW memory
> > region, which in practice is not always true (I had to reduce it to
> > 5MB). How about having this as a member of venus_core, which is
>
> Why you reduced to 5MB? Is there an issue with 6MB or you don't want to
> waste reserved memory?

The DT layout of our board only has 5MB reserved for Venus.

> > initialized in venus_load_fw() from the actual size of the memory
> > region? You could do this as an extra patch that comes before this
> > one.
> >
>
> The size is 6MB by historical reasons and they are no more valid, so I
> think we could safely decrease to 5MB. I could prepare a patch for that.

Whether we settle with 6MB or 5MB, that size remains arbitrary and not
based on the actual firmware size. And __qcom_mdt_load() does check
that the firmware fits the memory area. So I don't understand what
extra safety is added by ensuring the memory region is larger than a
given number of megabytes?
