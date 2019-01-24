Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26D2C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89065218A3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UOK4exFj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfAXIsP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:48:15 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35993 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfAXIsO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:48:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id p6so2086898wmc.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZyFAaOpUXZV4XS/JJhp8QSWsuIHGaG5DSI+WGR7Hqpw=;
        b=UOK4exFjh2jch3jVtCbKSlFgEi3JVtdnLBXV3lalCrxa3Z3E1VgYAwgaLFwhs6bi37
         iooz5XQzgWUxSZ1YP0Kzv8eMi4ZFzzTqE6v+ZhQ43F5DLhbF9slbl7hEQDnZCyRkp1gZ
         8imAFsPvyjrA5lM92azZ5lYxoyTJqbivDhQNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZyFAaOpUXZV4XS/JJhp8QSWsuIHGaG5DSI+WGR7Hqpw=;
        b=Jl+J8GUHIgkbd/pj0OLKoMkk0jl+Z9h4ywLbzGGPE/wcYXzVfMFk5t+RbIh20nv6Im
         iOr8V9KNJqksICQUkXRhrtOGnTH3nS7zkNofczHec0+0XPnP+6pXM5k44LPMei900tzD
         jy3ed7ZDiiMf8L9IKSPmGe6VBJBIpRjA/SbufKSMHuOUXODeboeFL36QcNqcf7mp9TmP
         OoWiOzSngZEEc+/kFQqJyiS94VLXsfmgjGw4Rpkc2znsZ+MEH5zUkWTM02qoJ1TS5knY
         E4sFTpmj1wjTP2TwM8/RlxtHA7mYXeOzX1KYN5at4wPI9cOO89muw7n0g289F66czddG
         Bc9A==
X-Gm-Message-State: AJcUukdPJtKXbPj537csMplMNeYY82+7T5C/saJa/1klp1Z0SHKdfPre
        eVc0VDYkJBPqnEiuTneyzMBnrg==
X-Google-Smtp-Source: ALg8bN4MgcNW3/0v+/Q90AIfHYz5VZ893974jcdbrkqMP8AlP6OXqfM4CDQYDGdT2UwnIhOE8P8RuA==
X-Received: by 2002:a1c:990c:: with SMTP id b12mr1733863wme.106.1548319692192;
        Thu, 24 Jan 2019 00:48:12 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id t70sm92112756wmd.36.2019.01.24.00.48.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 00:48:11 -0800 (PST)
Subject: Re: [PATCH 03/10] venus: helpers: export few helper functions
To:     Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-4-stanimir.varbanov@linaro.org>
 <CAPBb6MX=-uftivuSEMM9ZaV2rBO_rtr5T1xaF2hjsefnCtcRkw@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <14c09ca5-0f45-87f5-9bdc-d28f56438dfc@linaro.org>
Date:   Thu, 24 Jan 2019 10:48:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MX=-uftivuSEMM9ZaV2rBO_rtr5T1xaF2hjsefnCtcRkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

Thanks for the review!

On 1/24/19 10:43 AM, Alexandre Courbot wrote:
> On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Here we export few helper function to use them from decoder to
>> implement more granular control needed for stateful Codec API
>> compliance.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/helpers.c | 29 ++++++++++++---------
>>  drivers/media/platform/qcom/venus/helpers.h |  7 +++++
>>  2 files changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> index 86105de81af2..f33bbfea3576 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -88,7 +88,7 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
>>  }
>>  EXPORT_SYMBOL_GPL(venus_helper_check_codec);
>>
>> -static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
>> +int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
>>  {
>>         struct intbuf *buf;
>>         int ret = 0;
>> @@ -109,6 +109,7 @@ static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
>>  fail:
>>         return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(venus_helper_queue_dpb_bufs);
>>
>>  int venus_helper_free_dpb_bufs(struct venus_inst *inst)
>>  {
>> @@ -287,7 +288,7 @@ static const unsigned int intbuf_types_4xx[] = {
>>         HFI_BUFFER_INTERNAL_PERSIST_1,
>>  };
>>
>> -static int intbufs_alloc(struct venus_inst *inst)
>> +int venus_helper_intbufs_alloc(struct venus_inst *inst)
>>  {
>>         const unsigned int *intbuf;
>>         size_t arr_sz, i;
>> @@ -313,11 +314,13 @@ static int intbufs_alloc(struct venus_inst *inst)
>>         intbufs_unset_buffers(inst);
>>         return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(venus_helper_intbufs_alloc);
>>
>> -static int intbufs_free(struct venus_inst *inst)
>> +int venus_helper_intbufs_free(struct venus_inst *inst)
>>  {
>>         return intbufs_unset_buffers(inst);
>>  }
>> +EXPORT_SYMBOL_GPL(venus_helper_intbufs_free);
>>
>>  static u32 load_per_instance(struct venus_inst *inst)
>>  {
>> @@ -348,7 +351,7 @@ static u32 load_per_type(struct venus_core *core, u32 session_type)
>>         return mbs_per_sec;
>>  }
>>
>> -static int load_scale_clocks(struct venus_core *core)
>> +int venus_helper_load_scale_clocks(struct venus_core *core)
>>  {
>>         const struct freq_tbl *table = core->res->freq_tbl;
>>         unsigned int num_rows = core->res->freq_tbl_size;
>> @@ -397,6 +400,7 @@ static int load_scale_clocks(struct venus_core *core)
>>         dev_err(dev, "failed to set clock rate %lu (%d)\n", freq, ret);
>>         return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(venus_helper_load_scale_clocks);
>>
>>  static void fill_buffer_desc(const struct venus_buffer *buf,
>>                              struct hfi_buffer_desc *bd, bool response)
>> @@ -481,7 +485,7 @@ static bool is_dynamic_bufmode(struct venus_inst *inst)
>>         return caps->cap_bufs_mode_dynamic;
>>  }
>>
>> -static int session_unregister_bufs(struct venus_inst *inst)
>> +int venus_helper_unregister_bufs(struct venus_inst *inst)
>>  {
>>         struct venus_buffer *buf, *n;
>>         struct hfi_buffer_desc bd;
>> @@ -498,6 +502,7 @@ static int session_unregister_bufs(struct venus_inst *inst)
>>
>>         return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(venus_helper_unregister_bufs);
>>
>>  static int session_register_bufs(struct venus_inst *inst)
>>  {
>> @@ -1018,8 +1023,8 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
>>         if (inst->streamon_out & inst->streamon_cap) {
>>                 ret = hfi_session_stop(inst);
>>                 ret |= hfi_session_unload_res(inst);
>> -               ret |= session_unregister_bufs(inst);
>> -               ret |= intbufs_free(inst);
>> +               ret |= venus_helper_unregister_bufs(inst);
>> +               ret |= venus_helper_intbufs_free(inst);
>>                 ret |= hfi_session_deinit(inst);
>>
>>                 if (inst->session_error || core->sys_error)
>> @@ -1030,7 +1035,7 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
>>
>>                 venus_helper_free_dpb_bufs(inst);
>>
>> -               load_scale_clocks(core);
>> +               venus_helper_load_scale_clocks(core);
>>                 INIT_LIST_HEAD(&inst->registeredbufs);
>>         }
>>
>> @@ -1050,7 +1055,7 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>>         struct venus_core *core = inst->core;
>>         int ret;
>>
>> -       ret = intbufs_alloc(inst);
>> +       ret = venus_helper_intbufs_alloc(inst);
>>         if (ret)
>>                 return ret;
>>
>> @@ -1058,7 +1063,7 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>>         if (ret)
>>                 goto err_bufs_free;
>>
>> -       load_scale_clocks(core);
>> +       venus_helper_load_scale_clocks(core);
>>
>>         ret = hfi_session_load_res(inst);
>>         if (ret)
>> @@ -1079,9 +1084,9 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>>  err_unload_res:
>>         hfi_session_unload_res(inst);
>>  err_unreg_bufs:
>> -       session_unregister_bufs(inst);
>> +       venus_helper_unregister_bufs(inst);
>>  err_bufs_free:
>> -       intbufs_free(inst);
>> +       venus_helper_intbufs_free(inst);
>>         return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(venus_helper_vb2_start_streaming);
>> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
>> index 2475f284f396..24faae5abd93 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.h
>> +++ b/drivers/media/platform/qcom/venus/helpers.h
>> @@ -18,6 +18,7 @@
>>  #include <media/videobuf2-v4l2.h>
>>
>>  struct venus_inst;
>> +struct venus_core;
>>
>>  bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt);
>>  struct vb2_v4l2_buffer *venus_helper_find_buf(struct venus_inst *inst,
>> @@ -62,4 +63,10 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst);
>>  int venus_helper_free_dpb_bufs(struct venus_inst *inst);
>>  int venus_helper_power_enable(struct venus_core *core, u32 session_type,
>>                               bool enable);
>> +int venus_helper_intbufs_alloc(struct venus_inst *inst);
>> +int venus_helper_intbufs_free(struct venus_inst *inst);
>> +int venus_helper_intbufs_realloc(struct venus_inst *inst);
> 
> I think this function is only declared in patch 7?
> 

yes that is typo which I saw after sending the patches. Fixed already.

-- 
regards,
Stan
