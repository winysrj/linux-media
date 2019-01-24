Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7C4C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F791218A6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="KCdML0Z9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfAXKYF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:24:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52056 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfAXKYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:24:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so2528594wmj.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 02:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/6eAB8ques1NwxcFxFQ1zKWCiUEhKsBvxTsGl74yzaM=;
        b=KCdML0Z9qz8MaYNcigWo5kc5G7sHqfyV/hiDqXCkIUo+w9bcXisPgdRRzdgTUDFye5
         5xiOMZfdIPR7v8bwpcG8AbmAEKqc7HOQPjJxpx9Wwun4pelOhI7xQngJL9TrXYMppBiX
         aFloOOnLvIF+kHNThym+RCsrMNQ2sm2a6QUJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/6eAB8ques1NwxcFxFQ1zKWCiUEhKsBvxTsGl74yzaM=;
        b=oJC8vLLbdLewTCeegBWD9qjdkXpYESRn1dWWQo+ThGV57yby/DN6hxplA3azORG69b
         ZezLYj8Jb45sdJ8y6cep/MG5O0feeS7hXfCb/nQKBIki+ttDPz5bbiNx0D+kzyK718VI
         6COQLL0WzFNKSkVCF4IGyLSkgB/wfZ/7x39ko1YQ2IWPyOYqD6brBA8J5pGF+/+9LurT
         N4OP1kUfvPePQh8p7aVIsIBdK6J3OhdT9oBJ8ZzIiU77vlIBLNfX1BOnOdCJG+DlJpaK
         TPw8o31tgPG9rfDWKsDCdJTeKrFgRiB3nUBWIP1sErcBcjnSj162GA1FzwTcm0Z5j3UQ
         rSfw==
X-Gm-Message-State: AJcUukdspe9mf/ITTBR7+2x5acw3cGY0fnLK7xxIuViT8WnYDtCrJjjH
        MhR5b2bAYMG5PNzF8bxjrF65MA==
X-Google-Smtp-Source: ALg8bN5+JkKxaZwg9xYqO0wUTW6a9IFRZIbeARjG4AKXeG8fOCIM5wU+fXERJUn0vuS7cuBUJXMJ1Q==
X-Received: by 2002:a1c:9855:: with SMTP id a82mr1931950wme.20.1548325442556;
        Thu, 24 Jan 2019 02:24:02 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id u204sm97956479wmu.30.2019.01.24.02.24.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:24:01 -0800 (PST)
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     mgottam@codeaurora.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org>
 <d6aeca13e4f3da78fd00c69258e115d1@codeaurora.org>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <1663ea51-1fa0-6e29-715d-9d67aabb5ca9@linaro.org>
Date:   Thu, 24 Jan 2019 12:24:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d6aeca13e4f3da78fd00c69258e115d1@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Malathi,

On 1/21/19 1:20 PM, mgottam@codeaurora.org wrote:
> On 2019-01-17 21:50, Stanimir Varbanov wrote:
>> This refactored code for start/stop streaming vb2 operations and
>> adds a state machine handling similar to the one in stateful codec
>> API documentation. One major change is that now the HFI session is
>> started on STREAMON(OUTPUT) and stopped on REQBUF(OUTPUT,count=0),
>> during that time streamoff(cap,out) just flush buffers but doesn't
>> stop the session. The other major change is that now the capture
>> and output queues are completely separated.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h    |  20 +-
>>  drivers/media/platform/qcom/venus/helpers.c |  23 +-
>>  drivers/media/platform/qcom/venus/helpers.h |   5 +
>>  drivers/media/platform/qcom/venus/vdec.c    | 449 ++++++++++++++++----
>>  4 files changed, 389 insertions(+), 108 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/core.h
>> b/drivers/media/platform/qcom/venus/core.h
>> index 79c7e816c706..5a133c203455 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -218,6 +218,15 @@ struct venus_buffer {
>>
>>  #define to_venus_buffer(ptr)    container_of(ptr, struct
>> venus_buffer, vb)
>>
>> +#define DEC_STATE_UNINIT        0
>> +#define DEC_STATE_INIT            1
>> +#define DEC_STATE_CAPTURE_SETUP        2
>> +#define DEC_STATE_STOPPED        3
>> +#define DEC_STATE_SEEK            4
>> +#define DEC_STATE_DRAIN            5
>> +#define DEC_STATE_DECODING        6
>> +#define DEC_STATE_DRC            7
>> +
>>  /**
>>   * struct venus_inst - holds per instance paramerters
>>   *
>> @@ -241,6 +250,10 @@ struct venus_buffer {
>>   * @colorspace:    current color space
>>   * @quantization:    current quantization
>>   * @xfer_func:    current xfer function
>> + * @codec_state:    current codec API state (see DEC/ENC_STATE_)
>> + * @reconf_wait:    wait queue for resolution change event
>> + * @ten_bits:        does new stream is 10bits depth
>> + * @buf_count:        used to count number number of buffers (reqbuf(0))
>>   * @fps:        holds current FPS
>>   * @timeperframe:    holds current time per frame structure
>>   * @fmt_out:    a reference to output format structure
>> @@ -255,8 +268,6 @@ struct venus_buffer {
>>   * @opb_buftype:    output picture buffer type
>>   * @opb_fmt:        output picture buffer raw format
>>   * @reconfig:    a flag raised by decoder when the stream resolution
>> changed
>> - * @reconfig_width:    holds the new width
>> - * @reconfig_height:    holds the new height
>>   * @hfi_codec:        current codec for this instance in HFI space
>>   * @sequence_cap:    a sequence counter for capture queue
>>   * @sequence_out:    a sequence counter for output queue
>> @@ -296,6 +307,9 @@ struct venus_inst {
>>      u8 ycbcr_enc;
>>      u8 quantization;
>>      u8 xfer_func;
>> +    unsigned int codec_state;
>> +    wait_queue_head_t reconf_wait;
>> +    int buf_count;
>>      u64 fps;
>>      struct v4l2_fract timeperframe;
>>      const struct venus_format *fmt_out;
>> @@ -310,8 +324,6 @@ struct venus_inst {
>>      u32 opb_buftype;
>>      u32 opb_fmt;
>>      bool reconfig;
>> -    u32 reconfig_width;
>> -    u32 reconfig_height;
>>      u32 hfi_codec;
>>      u32 sequence_cap;
>>      u32 sequence_out;
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c
>> b/drivers/media/platform/qcom/venus/helpers.c
>> index 637ce7b82d94..25d8cceccae4 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -1030,16 +1030,15 @@ void venus_helper_vb2_buf_queue(struct
>> vb2_buffer *vb)
>>
>>      v4l2_m2m_buf_queue(m2m_ctx, vbuf);
>>
>> -    if (!(inst->streamon_out & inst->streamon_cap))
>> -        goto unlock;
>> -
>> -    ret = is_buf_refed(inst, vbuf);
>> -    if (ret)
>> -        goto unlock;
>> +    if (IS_OUT(vb->vb2_queue, inst) || IS_CAP(vb->vb2_queue, inst)) {
>> +        ret = is_buf_refed(inst, vbuf);
>> +        if (ret)
>> +            goto unlock;
>>
>> -    ret = session_process_buf(inst, vbuf);
>> -    if (ret)
>> -        return_buf_error(inst, vbuf);
>> +        ret = session_process_buf(inst, vbuf);
>> +        if (ret)
>> +            return_buf_error(inst, vbuf);
>> +    }
>>
>>  unlock:
>>      mutex_unlock(&inst->lock);
> 
> Hi Stan,
> 
> In case of encoder, we are queuing buffers only after both planes are
> streamed on.
> As we don’t have any reconfig event in case of encoder,
> it’s better if we stick to the earlier implementation of queuing buffers.
> 
> So I would recommend to add a check for the same in the below way :
> 
> diff --git a/drivers/media/platform/qcom/venus/helpers.c
> b/drivers/media/platform/qcom/venus/helpers.c
> index 25d8cce..cc490fe2 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -1029,6 +1029,8 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer
> *vb)
>         mutex_lock(&inst->lock);
> 
>         v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> +       if (inst->session_type == VIDC_SESSION_TYPE_ENC &&
> !(inst->streamon_out & inst->streamon_cap))
> +               goto unlock;
> 
>         if (IS_OUT(vb->vb2_queue, inst) || IS_CAP(vb->vb2_queue, inst)) {
>                 ret = is_buf_refed(inst, vbuf);
> 
> Please provide your view.

I agree that this change is needed for encoder and will incorporate such
a change in next version.

-- 
regards,
Stan
