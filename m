Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34055 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752862AbeEUOxL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 10:53:11 -0400
Received: by mail-wr0-f196.google.com with SMTP id j1-v6so5354016wrm.1
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 07:53:10 -0700 (PDT)
Subject: Re: [PATCH v2 04/29] venus: hfi_cmds: add set_properties for 4xx
 version
To: Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-5-stanimir.varbanov@linaro.org>
 <CAAFQd5Aw70jUdaNXwZzkf22u5-2bmmCNBO9FkpQLNPo_9nwSzQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <2bb37924-82cc-c38d-6f99-fd62d875c3ab@linaro.org>
Date: Mon, 21 May 2018 17:53:08 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Aw70jUdaNXwZzkf22u5-2bmmCNBO9FkpQLNPo_9nwSzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 05/18/2018 05:16 PM, Tomasz Figa wrote:
> On Tue, May 15, 2018 at 5:13 PM Stanimir Varbanov <
> stanimir.varbanov@linaro.org> wrote:
> 
>> Adds set_properties method to handle newer 4xx properties and
>> fall-back to 3xx for the rest.
> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>   drivers/media/platform/qcom/venus/hfi_cmds.c | 64
> +++++++++++++++++++++++++++-
>>   1 file changed, 63 insertions(+), 1 deletion(-)
> 
>> diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c
> b/drivers/media/platform/qcom/venus/hfi_cmds.c
>> index 1cfeb7743041..6bd287154796 100644
>> --- a/drivers/media/platform/qcom/venus/hfi_cmds.c
>> +++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
> 
> [snip]
> 
>> +       case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
>> +               /* not implemented on Venus 4xx */
> 
> Shouldn't return -EINVAL here, similar to what
> pkt_session_set_property_1x() does for unknown property?

Probably the right error code should be ENOTSUPP, but I kind of
following the rule to silently not return the error to simplify the
callers of set_property (otherwise I have to have a version conditional
code in the callers).

> 
>> +               break;
>> +       default:
>> +               ret = pkt_session_set_property_3xx(pkt, cookie, ptype,
> pdata);
>> +               break;
> 
> nit: How about simply return pkt_session_set_property_3xx(pkt, cookie,
> ptype, pdata); and removing the |ret| variable completely, since the return
> below the switch can just return 0 all the time?

OK, I will do that way.

> 
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>>   int pkt_session_get_property(struct hfi_session_get_property_pkt *pkt,
>>                               void *cookie, u32 ptype)
>>   {
>> @@ -1181,7 +1240,10 @@ int pkt_session_set_property(struct
> hfi_session_set_property_pkt *pkt,
>>          if (hfi_ver == HFI_VERSION_1XX)
>>                  return pkt_session_set_property_1x(pkt, cookie, ptype,
> pdata);
> 
>> -       return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
>> +       if (hfi_ver == HFI_VERSION_3XX)
>> +               return pkt_session_set_property_3xx(pkt, cookie, ptype,
> pdata);
>> +
>> +       return pkt_session_set_property_4xx(pkt, cookie, ptype, pdata);
> 
> nit: Since we're adding third variant, I'd consider using function pointers
> here, but no strong opinion.

Let's keep that for future improvements.

-- 
regards,
Stan
