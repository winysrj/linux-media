Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:35078 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbcLEM1e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 07:27:34 -0500
Received: by mail-wj0-f174.google.com with SMTP id v7so288492471wjy.2
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 04:26:40 -0800 (PST)
Subject: Re: [PATCH v4 1/9] media: v4l2-mem2mem: extend m2m APIs for more
 accurate buffer management
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1480583001-32236-1-git-send-email-stanimir.varbanov@linaro.org>
 <1480583001-32236-2-git-send-email-stanimir.varbanov@linaro.org>
 <464b3cd6-f5b4-ed26-717d-929d6957c015@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <97244804-a2f7-ebe4-123b-a13eeeac4136@linaro.org>
Date: Mon, 5 Dec 2016 14:26:36 +0200
MIME-Version: 1.0
In-Reply-To: <464b3cd6-f5b4-ed26-717d-929d6957c015@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 12/05/2016 01:25 PM, Hans Verkuil wrote:
> On 12/01/2016 10:03 AM, Stanimir Varbanov wrote:
>> this add functions for:
>>   - remove buffers from src/dst queue by index
>>   - remove exact buffer from src/dst queue
>>
>> also extends m2m API to iterate over a list of src/dst buffers
>> in safely and non-safely manner.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/v4l2-core/v4l2-mem2mem.c | 37 +++++++++++++++
>>  include/media/v4l2-mem2mem.h           | 83 ++++++++++++++++++++++++++++++++++
>>  2 files changed, 120 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> index 6bc27e7b2a33..d689e7bb964f 100644
>> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
>> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> @@ -126,6 +126,43 @@ void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx)
>>  }
>>  EXPORT_SYMBOL_GPL(v4l2_m2m_buf_remove);
>>  
>> +void v4l2_m2m_buf_remove_exact(struct v4l2_m2m_queue_ctx *q_ctx,
>> +			       struct vb2_v4l2_buffer *vbuf)
> 
> I'd call this v4l2_m2m_buf_remove_by_buf to be consistent with _by_idx.

Thanks, I will rename it.

-- 
regards,
Stan
