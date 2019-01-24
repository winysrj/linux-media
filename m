Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2693FC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0C9B2084C
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="PboRJuOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfAXJ7R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:59:17 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35713 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfAXJ7F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:59:05 -0500
Received: by mail-wr1-f67.google.com with SMTP id 96so5776479wrb.2
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 01:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iRSEopFd+AHR1Xrk3tr3l3cIpLaGxkm3eJb/szQtbWI=;
        b=PboRJuOZ7vQb7QTOTDCTpv+pdmQBiIvhFX69bWZQASbvtwPj+0Cgp5+Bkzr+QIigOz
         GeDM62Ic9Yq0OHjy38jFXIyFVOIfqLxzSOQ1RpIoswzCtoH0zaDdxCarGgCXbZj6D9jo
         +Nvj0uwqZcz3og7JbEYsnbPmMlcdpIcm2XSAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iRSEopFd+AHR1Xrk3tr3l3cIpLaGxkm3eJb/szQtbWI=;
        b=MoLjnrz0qgE1zyuW+jaxmeJBdnhqQXbBSvgfJkx9gQ7iNPIGdzCT5Jm6OqFIX8jxAw
         Y/nhSjdupgT10qRmdvDIloVYuN0bIMA1CEgAMrp70JIC5RSVojhkqscExkXuSAnYZhP+
         cIUplSDU/kRaEbpPAfRLOvn/v2kRunIzXFTpHVBowxeM34lgOJnjPeaD/oH4kfnu0jgn
         0X8aJuQjZURzIUQ6BMRxhmzcMlzLDuBaUokVp9SLiKNbZEsmj5f7HGft54fLQT2fPRjh
         vQatf1a0QY0rypEz9toeiBBJlaFhVUlp4IInRWqz2LB+gJwGhvMXDDKAzXTPlR0SQNJ9
         877w==
X-Gm-Message-State: AJcUukc2k8AG4dP2WzDWRiXufb6PFMv71i/LUbS1PrzuBg//Hi9mD1m8
        smoZ8sB1zQdil21wrJE7ia5PvA==
X-Google-Smtp-Source: ALg8bN54V/MwJB+4mFIs+zTyjSrnLqnnGoJWaz1N+qDWbPm4NSW6wbRXfU4xLAEX960Tc7kJSr8XrQ==
X-Received: by 2002:adf:b6a1:: with SMTP id j33mr6456628wre.55.1548323944084;
        Thu, 24 Jan 2019 01:59:04 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id x3sm97679856wrd.19.2019.01.24.01.59.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 01:59:03 -0800 (PST)
Subject: Re: [PATCH 08/10] venus: vdec_ctrls: get real minimum buffers for
 capture
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
 <20190117162008.25217-9-stanimir.varbanov@linaro.org>
 <CAPBb6MWJXWLcGh3dbejiYzyqT6OB1_FN6zrcZFO5DbxqXSAWjQ@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <c9ce287b-e064-9fbe-6ee0-176253e0de84@linaro.org>
Date:   Thu, 24 Jan 2019 11:59:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MWJXWLcGh3dbejiYzyqT6OB1_FN6zrcZFO5DbxqXSAWjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

Thanks for the comments!

On 1/24/19 10:43 AM, Alexandre Courbot wrote:
> On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Until now we returned num_output_bufs set during reqbuf but
>> that could be wrong when we implement stateful Codec API. So
>> get the minimum buffers for capture from HFI. This is supposed
>> to be called after stream header parsing, i.e. after dequeue
>> v4l2 event for change resolution.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/vdec_ctrls.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/vdec_ctrls.c b/drivers/media/platform/qcom/venus/vdec_ctrls.c
>> index f4604b0cd57e..e1da87bf52bc 100644
>> --- a/drivers/media/platform/qcom/venus/vdec_ctrls.c
>> +++ b/drivers/media/platform/qcom/venus/vdec_ctrls.c
>> @@ -16,6 +16,7 @@
>>  #include <media/v4l2-ctrls.h>
>>
>>  #include "core.h"
>> +#include "helpers.h"
>>  #include "vdec.h"
>>
>>  static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
>> @@ -47,7 +48,9 @@ static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>>  {
>>         struct venus_inst *inst = ctrl_to_inst(ctrl);
>>         struct vdec_controls *ctr = &inst->controls.dec;
>> +       struct hfi_buffer_requirements bufreq;
>>         union hfi_get_property hprop;
>> +       enum hfi_version ver = inst->core->res->hfi_version;
>>         u32 ptype = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
>>         int ret;
>>
>> @@ -71,7 +74,9 @@ static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>>                 ctrl->val = ctr->post_loop_deb_mode;
>>                 break;
>>         case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
>> -               ctrl->val = inst->num_output_bufs;
>> +               ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
>> +               if (!ret)
>> +                       ctrl->val = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
> 
> What happens if venus_helper_get_bufreq() returns an error? It seems
> that we just happily continue with whatever the previous value of
> ctrl->val was. It seems like we do the same with other controls as
> well.

I agree that this is wrong, I think no-one userspace client used that
g_ctrls controls :)

> 
> I think you can fix this globally by initializing ret to 0 at the
> beginning of the function, and then returning ret instead of 0 at the
> end. That way all errors would be propagated. Of course please check
> that this is relevant for other controls following this scheme before
> doing so. :)
> 

yes, I will do!

-- 
regards,
Stan
