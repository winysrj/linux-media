Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.180.41]:44508 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752451AbdHVUJt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 16:09:49 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 771853E155
        for <linux-media@vger.kernel.org>; Tue, 22 Aug 2017 14:22:40 -0500 (CDT)
Subject: Re: [PATCH v2] venus: fix copy/paste error in return_buf_error
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170818160719.GA4899@embeddedgus>
 <ba079222-f2e2-2988-b028-f996a19a7247@mm-sol.com>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <aa12d8d5-fa8f-7dc7-bdbe-68c53dfcfb1a@embeddedor.com>
Date: Tue, 22 Aug 2017 14:22:35 -0500
MIME-Version: 1.0
In-Reply-To: <ba079222-f2e2-2988-b028-f996a19a7247@mm-sol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/21/2017 04:14 AM, Stanimir Varbanov wrote:
> Thanks Gustavo!
>

Glad to help. :)

> On 08/18/2017 07:07 PM, Gustavo A. R. Silva wrote:
>> Call function v4l2_m2m_dst_buf_remove_by_buf() instead of
>> v4l2_m2m_src_buf_remove_by_buf()
>>
>> Addresses-Coverity-ID: 1415317
>> Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>> Changes in v2:
>>  Stanimir Varbanov confirmed this is a bug. The correct fix is to call
>>  function v4l2_m2m_dst_buf_remove_by_buf instead of function
>>  v4l2_m2m_src_buf_remove_by_buf in the _else_ branch.
>>
>>  drivers/media/platform/qcom/venus/helpers.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>
>>
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> index 5f4434c..2d61879 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -243,7 +243,7 @@ static void return_buf_error(struct venus_inst *inst,
>>  	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>  		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
>>  	else
>> -		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
>> +		v4l2_m2m_dst_buf_remove_by_buf(m2m_ctx, vbuf);
>>
>>  	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>>  }
>>
>

-- 
Gustavo A. R. Silva
