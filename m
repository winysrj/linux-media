Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B83FC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 323AD218A4
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LxXc2tJ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfAXIni (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:43:38 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34786 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbfAXInd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:43:33 -0500
Received: by mail-oi1-f193.google.com with SMTP id r62so4237226oie.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hVDl9dIUoiCG6PuhpYJsDmUi5clSLHBybMHGEZVmHMg=;
        b=LxXc2tJ+71bGWx9FuaNFu9pEswntN6fcNpmCDaP7n2vbjHQ3PVe+kVVjjDv+C5FKLK
         8QNoOqQ5sM+MjS4Z95G2QxanUaZqHTwyk9AyoHCoRn2Z8zq5Vt8NUBeUs0XmgIUIyPnS
         xxqWNL6kgpwjTJ925LM3rf7zmpdnO+Ok5pb2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hVDl9dIUoiCG6PuhpYJsDmUi5clSLHBybMHGEZVmHMg=;
        b=jcD6xN6fpr5VPPm0w8CQONDx5mwJRiJvaLpILY5PTYhxTBXiVMzBp58PM6KgJWJsjU
         x3aByA1/iaZjauLOPmwztAehjRpXgAz0xQBdyvI1XVj0DRf2UCH8xeMQuHfdoW6lGjko
         tOXhUkbL/RywUO5uUPdX0Zf+7JADB/pbk5+l8JXj9ruXXmykT3IQbC8LTeGNGf2Td+/R
         VNhEI3DfODvSfvkSwwinf1p7NU5loNok9qBsUF0kFa94YLcB0IRXGNHT5oMx1o/bJINS
         9YINBIwxSjttPaE+BCb7xMRx9gNfcyTf0skwUE8NnhYk28MXBMkvKBwUcRMLj3l4Zqje
         kspA==
X-Gm-Message-State: AHQUAub4cFeOmRNPFRD6tMmODFZ+ApddFkA+Q/rWLme+GkG+D9e4yFL/
        iR13oHJxkOFf5J2E/qm/1Dd43GILha4=
X-Google-Smtp-Source: ALg8bN4UhRoTsZduXCsxG3MDikbEDBnWHWWpiWHV6ROKGwkC2TxLPSJaMpfu0dp/EeI7j1lpWqjjhQ==
X-Received: by 2002:aca:720a:: with SMTP id p10mr515598oic.169.1548319412284;
        Thu, 24 Jan 2019 00:43:32 -0800 (PST)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com. [209.85.167.180])
        by smtp.gmail.com with ESMTPSA id l108sm8987461otc.23.2019.01.24.00.43.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 00:43:31 -0800 (PST)
Received: by mail-oi1-f180.google.com with SMTP id r62so4237175oie.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:43:31 -0800 (PST)
X-Received: by 2002:aca:f103:: with SMTP id p3mr535530oih.94.1548319410841;
 Thu, 24 Jan 2019 00:43:30 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org> <20190117162008.25217-4-stanimir.varbanov@linaro.org>
In-Reply-To: <20190117162008.25217-4-stanimir.varbanov@linaro.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Thu, 24 Jan 2019 17:43:19 +0900
X-Gmail-Original-Message-ID: <CAPBb6MX=-uftivuSEMM9ZaV2rBO_rtr5T1xaF2hjsefnCtcRkw@mail.gmail.com>
Message-ID: <CAPBb6MX=-uftivuSEMM9ZaV2rBO_rtr5T1xaF2hjsefnCtcRkw@mail.gmail.com>
Subject: Re: [PATCH 03/10] venus: helpers: export few helper functions
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Here we export few helper function to use them from decoder to
> implement more granular control needed for stateful Codec API
> compliance.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 29 ++++++++++++---------
>  drivers/media/platform/qcom/venus/helpers.h |  7 +++++
>  2 files changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 86105de81af2..f33bbfea3576 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -88,7 +88,7 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_check_codec);
>
> -static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
> +int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
>  {
>         struct intbuf *buf;
>         int ret = 0;
> @@ -109,6 +109,7 @@ static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
>  fail:
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(venus_helper_queue_dpb_bufs);
>
>  int venus_helper_free_dpb_bufs(struct venus_inst *inst)
>  {
> @@ -287,7 +288,7 @@ static const unsigned int intbuf_types_4xx[] = {
>         HFI_BUFFER_INTERNAL_PERSIST_1,
>  };
>
> -static int intbufs_alloc(struct venus_inst *inst)
> +int venus_helper_intbufs_alloc(struct venus_inst *inst)
>  {
>         const unsigned int *intbuf;
>         size_t arr_sz, i;
> @@ -313,11 +314,13 @@ static int intbufs_alloc(struct venus_inst *inst)
>         intbufs_unset_buffers(inst);
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(venus_helper_intbufs_alloc);
>
> -static int intbufs_free(struct venus_inst *inst)
> +int venus_helper_intbufs_free(struct venus_inst *inst)
>  {
>         return intbufs_unset_buffers(inst);
>  }
> +EXPORT_SYMBOL_GPL(venus_helper_intbufs_free);
>
>  static u32 load_per_instance(struct venus_inst *inst)
>  {
> @@ -348,7 +351,7 @@ static u32 load_per_type(struct venus_core *core, u32 session_type)
>         return mbs_per_sec;
>  }
>
> -static int load_scale_clocks(struct venus_core *core)
> +int venus_helper_load_scale_clocks(struct venus_core *core)
>  {
>         const struct freq_tbl *table = core->res->freq_tbl;
>         unsigned int num_rows = core->res->freq_tbl_size;
> @@ -397,6 +400,7 @@ static int load_scale_clocks(struct venus_core *core)
>         dev_err(dev, "failed to set clock rate %lu (%d)\n", freq, ret);
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(venus_helper_load_scale_clocks);
>
>  static void fill_buffer_desc(const struct venus_buffer *buf,
>                              struct hfi_buffer_desc *bd, bool response)
> @@ -481,7 +485,7 @@ static bool is_dynamic_bufmode(struct venus_inst *inst)
>         return caps->cap_bufs_mode_dynamic;
>  }
>
> -static int session_unregister_bufs(struct venus_inst *inst)
> +int venus_helper_unregister_bufs(struct venus_inst *inst)
>  {
>         struct venus_buffer *buf, *n;
>         struct hfi_buffer_desc bd;
> @@ -498,6 +502,7 @@ static int session_unregister_bufs(struct venus_inst *inst)
>
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(venus_helper_unregister_bufs);
>
>  static int session_register_bufs(struct venus_inst *inst)
>  {
> @@ -1018,8 +1023,8 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
>         if (inst->streamon_out & inst->streamon_cap) {
>                 ret = hfi_session_stop(inst);
>                 ret |= hfi_session_unload_res(inst);
> -               ret |= session_unregister_bufs(inst);
> -               ret |= intbufs_free(inst);
> +               ret |= venus_helper_unregister_bufs(inst);
> +               ret |= venus_helper_intbufs_free(inst);
>                 ret |= hfi_session_deinit(inst);
>
>                 if (inst->session_error || core->sys_error)
> @@ -1030,7 +1035,7 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
>
>                 venus_helper_free_dpb_bufs(inst);
>
> -               load_scale_clocks(core);
> +               venus_helper_load_scale_clocks(core);
>                 INIT_LIST_HEAD(&inst->registeredbufs);
>         }
>
> @@ -1050,7 +1055,7 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>         struct venus_core *core = inst->core;
>         int ret;
>
> -       ret = intbufs_alloc(inst);
> +       ret = venus_helper_intbufs_alloc(inst);
>         if (ret)
>                 return ret;
>
> @@ -1058,7 +1063,7 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>         if (ret)
>                 goto err_bufs_free;
>
> -       load_scale_clocks(core);
> +       venus_helper_load_scale_clocks(core);
>
>         ret = hfi_session_load_res(inst);
>         if (ret)
> @@ -1079,9 +1084,9 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>  err_unload_res:
>         hfi_session_unload_res(inst);
>  err_unreg_bufs:
> -       session_unregister_bufs(inst);
> +       venus_helper_unregister_bufs(inst);
>  err_bufs_free:
> -       intbufs_free(inst);
> +       venus_helper_intbufs_free(inst);
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_vb2_start_streaming);
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 2475f284f396..24faae5abd93 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -18,6 +18,7 @@
>  #include <media/videobuf2-v4l2.h>
>
>  struct venus_inst;
> +struct venus_core;
>
>  bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt);
>  struct vb2_v4l2_buffer *venus_helper_find_buf(struct venus_inst *inst,
> @@ -62,4 +63,10 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst);
>  int venus_helper_free_dpb_bufs(struct venus_inst *inst);
>  int venus_helper_power_enable(struct venus_core *core, u32 session_type,
>                               bool enable);
> +int venus_helper_intbufs_alloc(struct venus_inst *inst);
> +int venus_helper_intbufs_free(struct venus_inst *inst);
> +int venus_helper_intbufs_realloc(struct venus_inst *inst);

I think this function is only declared in patch 7?



> +int venus_helper_queue_dpb_bufs(struct venus_inst *inst);
> +int venus_helper_unregister_bufs(struct venus_inst *inst);
> +int venus_helper_load_scale_clocks(struct venus_core *core);
>  #endif
> --
> 2.17.1
>
