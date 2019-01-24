Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BD2C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 617B021872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QgFqV6Wz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfAXIoJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:44:09 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34663 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbfAXIni (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:43:38 -0500
Received: by mail-ot1-f66.google.com with SMTP id t5so4578302otk.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WdibVqAgbR5ok31tdt/O+WwBRfsYGvLwJnb1/CwmST4=;
        b=QgFqV6WzKgpjdFy8xOlY7wKGE4wo8hKQpaBCLDmH/VH+sKxK5DMPTb4rAd8AKAHWK/
         RK6ylLa+fF5AbTabu0OBYUBMzlPS9rxThwEJLAsDzVSbizvyMPYpIsSBMLcTvmBGbwOW
         KfiOeCIOBSJ8F0mHQVzu1Pqn37n9OJzQHKkNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WdibVqAgbR5ok31tdt/O+WwBRfsYGvLwJnb1/CwmST4=;
        b=Mpn5J1R+xlVSCmzlWFyxZo4Y6dXTgGW1+YGDqVDOllpS7wkhV/KpSlRzdBlKrp5aS8
         u3aDHSDIft+Cgr/OLY5bblwSGJ8+j+3omW1ZryIh3PZDMWAFP2s6gLyz9Ypyb3Wi0rx5
         Ceqbj1YphKxN978BBvGZv0iEr6+idVBLpbMrzA5F9EtNVAGoEEoz7PGL6eoFBRyGQ+Pk
         OA37f2EzbAPngbyXx/5/90B3qZsZzK8MnuPi9AZwWco6fQHUGK48ML0zI3CEIgXMy+DX
         HI4C292yIb2ZKEUvIlFwmf8y2ZMsTAD4l9sZKy1AYtJaoETEjOOE9kKwZi5AZZk4hg3T
         GuQA==
X-Gm-Message-State: AJcUukfNv17Gd4gO0sPypyRegCVtEW1reEsFD+9P/8V+lh08vpVeNP7S
        QKoxuVhzObbtaEjFxFYTZf7OeXp2aGQ=
X-Google-Smtp-Source: ALg8bN5k7YCHY1qH+qM4a1RbRqItR9zGalDWS2RevBAwCpAqjwLblvW2ieeiiSIAurOXQG0SE9P9Sw==
X-Received: by 2002:a9d:6d81:: with SMTP id x1mr3503372otp.17.1548319417114;
        Thu, 24 Jan 2019 00:43:37 -0800 (PST)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id 96sm9173609ota.28.2019.01.24.00.43.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 00:43:36 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id y23so4210886oia.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:43:35 -0800 (PST)
X-Received: by 2002:a54:4486:: with SMTP id v6mr555965oiv.233.1548319415393;
 Thu, 24 Jan 2019 00:43:35 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org> <20190117162008.25217-8-stanimir.varbanov@linaro.org>
In-Reply-To: <20190117162008.25217-8-stanimir.varbanov@linaro.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Thu, 24 Jan 2019 17:43:24 +0900
X-Gmail-Original-Message-ID: <CAPBb6MVPhpZkCLFhAfPhE83TSpnCjH4Zy4-Mage5s=LkU9_RzA@mail.gmail.com>
Message-ID: <CAPBb6MVPhpZkCLFhAfPhE83TSpnCjH4Zy4-Mage5s=LkU9_RzA@mail.gmail.com>
Subject: Re: [PATCH 07/10] venus: helpers: add three more helper functions
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
> This adds three more helper functions:
>  * for internal buffers reallocation, applicable when we are doing
> dynamic resolution change
>  * for initial buffer processing of capture and output queue buffer
> types
>
> All of them will be needed for stateful Codec API support.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 82 +++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  2 +
>  2 files changed, 84 insertions(+)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index f33bbfea3576..637ce7b82d94 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -322,6 +322,52 @@ int venus_helper_intbufs_free(struct venus_inst *inst)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_intbufs_free);
>
> +int venus_helper_intbufs_realloc(struct venus_inst *inst)

Does this function actually reallocate buffers? It seems to just free
what we had previously.


> +{
> +       enum hfi_version ver = inst->core->res->hfi_version;
> +       struct hfi_buffer_desc bd;
> +       struct intbuf *buf, *n;
> +       int ret;
> +
> +       list_for_each_entry_safe(buf, n, &inst->internalbufs, list) {
> +               if (buf->type == HFI_BUFFER_INTERNAL_PERSIST ||
> +                   buf->type == HFI_BUFFER_INTERNAL_PERSIST_1)
> +                       continue;
> +
> +               memset(&bd, 0, sizeof(bd));
> +               bd.buffer_size = buf->size;
> +               bd.buffer_type = buf->type;
> +               bd.num_buffers = 1;
> +               bd.device_addr = buf->da;
> +               bd.response_required = true;
> +
> +               ret = hfi_session_unset_buffers(inst, &bd);
> +
> +               dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
> +                              buf->attrs);
> +
> +               list_del_init(&buf->list);
> +               kfree(buf);
> +       }
> +
> +       ret = intbufs_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH(ver));
> +       if (ret)
> +               goto err;
> +
> +       ret = intbufs_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH_1(ver));
> +       if (ret)
> +               goto err;
> +
> +       ret = intbufs_set_buffer(inst, HFI_BUFFER_INTERNAL_SCRATCH_2(ver));
> +       if (ret)
> +               goto err;
> +
> +       return 0;
> +err:
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_intbufs_realloc);
> +
>  static u32 load_per_instance(struct venus_inst *inst)
>  {
>         u32 mbs;
> @@ -1050,6 +1096,42 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
>
> +int venus_helper_process_initial_cap_bufs(struct venus_inst *inst)
> +{
> +       struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +       struct v4l2_m2m_buffer *buf, *n;
> +       int ret;
> +
> +       v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, buf, n) {
> +               ret = session_process_buf(inst, &buf->vb);
> +               if (ret) {
> +                       return_buf_error(inst, &buf->vb);
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_process_initial_cap_bufs);
> +
> +int venus_helper_process_initial_out_bufs(struct venus_inst *inst)
> +{
> +       struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +       struct v4l2_m2m_buffer *buf, *n;
> +       int ret;
> +
> +       v4l2_m2m_for_each_src_buf_safe(m2m_ctx, buf, n) {
> +               ret = session_process_buf(inst, &buf->vb);
> +               if (ret) {
> +                       return_buf_error(inst, &buf->vb);
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_process_initial_out_bufs);
> +
>  int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>  {
>         struct venus_core *core = inst->core;
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 24faae5abd93..2ec1c1a8b416 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -69,4 +69,6 @@ int venus_helper_intbufs_realloc(struct venus_inst *inst);
>  int venus_helper_queue_dpb_bufs(struct venus_inst *inst);
>  int venus_helper_unregister_bufs(struct venus_inst *inst);
>  int venus_helper_load_scale_clocks(struct venus_core *core);
> +int venus_helper_process_initial_cap_bufs(struct venus_inst *inst);
> +int venus_helper_process_initial_out_bufs(struct venus_inst *inst);
>  #endif
> --
> 2.17.1
>
