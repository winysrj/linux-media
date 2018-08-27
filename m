Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:52091 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbeH0Gzw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 02:55:52 -0400
Received: by mail-it0-f66.google.com with SMTP id e14-v6so9194754itf.1
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2018 20:11:11 -0700 (PDT)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com. [209.85.223.179])
        by smtp.gmail.com with ESMTPSA id y189-v6sm3486797itd.26.2018.08.26.20.11.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Aug 2018 20:11:11 -0700 (PDT)
Received: by mail-io0-f179.google.com with SMTP id y3-v6so11717978ioc.5
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2018 20:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-3-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MXydrrfbWOps-xV4eRzgN6n6pT45B2C=H5tuF2pZOesZQ@mail.gmail.com> <ee7f8db9-8624-9e08-7ea2-7ea99c0ad289@linaro.org>
In-Reply-To: <ee7f8db9-8624-9e08-7ea2-7ea99c0ad289@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 27 Aug 2018 12:10:59 +0900
Message-ID: <CAPBb6MWYE2o+nPXeaVGq6Pvymb4NAivf6aM2srX++=fpAU6SwA@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] venus: firmware: move load firmware in a separate function
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

On Fri, Aug 24, 2018 at 6:01 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> On 08/24/2018 10:39 AM, Alexandre Courbot wrote:
> > On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
> >>
> >> Separate firmware loading part into a new function.
> >>
> >> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/core.c     |  4 +-
> >>  drivers/media/platform/qcom/venus/firmware.c | 55 ++++++++++++++++++----------
> >>  drivers/media/platform/qcom/venus/firmware.h |  2 +-
> >>  3 files changed, 38 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> >> index bb6add9..75b9785 100644
> >> --- a/drivers/media/platform/qcom/venus/core.c
> >> +++ b/drivers/media/platform/qcom/venus/core.c
> >> @@ -84,7 +84,7 @@ static void venus_sys_error_handler(struct work_struct *work)
> >>
> >>         pm_runtime_get_sync(core->dev);
> >>
> >> -       ret |= venus_boot(core->dev, core->res->fwname);
> >> +       ret |= venus_boot(core);
> >>
> >>         ret |= hfi_core_resume(core, true);
> >>
> >> @@ -284,7 +284,7 @@ static int venus_probe(struct platform_device *pdev)
> >>         if (ret < 0)
> >>                 goto err_runtime_disable;
> >>
> >> -       ret = venus_boot(dev, core->res->fwname);
> >> +       ret = venus_boot(core);
> >>         if (ret)
> >>                 goto err_runtime_disable;
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> >> index a9d042e..34224eb 100644
> >> --- a/drivers/media/platform/qcom/venus/firmware.c
> >> +++ b/drivers/media/platform/qcom/venus/firmware.c
> >> @@ -60,20 +60,18 @@ int venus_set_hw_state(struct venus_core *core, bool resume)
> >>         return 0;
> >>  }
> >>
> >> -int venus_boot(struct device *dev, const char *fwname)
> >> +static int venus_load_fw(struct venus_core *core, const char *fwname,
> >> +                        phys_addr_t *mem_phys, size_t *mem_size)
> >
> > Following the remarks of the previous patch, you would have mem_phys
> > and mem_size as members of venus_core (probably renamed as fw_mem_addr
> > and fw_mem_size).
> >
> >>  {
> >>         const struct firmware *mdt;
> >>         struct device_node *node;
> >> -       phys_addr_t mem_phys;
> >> +       struct device *dev;
> >>         struct resource r;
> >>         ssize_t fw_size;
> >> -       size_t mem_size;
> >>         void *mem_va;
> >>         int ret;
> >>
> >> -       if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
> >> -               return -EPROBE_DEFER;
> >
> > !IS_ENABLED(CONFIG_QCOM_MDT_LOADER) is not a condition that can change
> > at runtime, and returning -EPROBE_DEFER in that case seems erroneous
> > to me. Instead, wouldn't it make more sense to make the driver depend
> > on QCOM_MDT_LOADER?
>
> That was made on purpose, for more info git show b8f9bdc151e4a

Ah, I see. Still, in the current form it seems like
qcom_scm_is_available() is not resolved thanks to a compiler
optimization. Wouldn't it be more explicit to do something like

#if IS_ENABLED(CONFIG_QCOM_MDT_LOADER)
if (!qcom_scm_is_available())
    return -EPROBE_DEFER;
#endif

instead?
