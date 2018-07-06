Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54135 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932429AbeGFPMc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 11:12:32 -0400
Received: by mail-wm0-f66.google.com with SMTP id b188-v6so15246955wme.3
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2018 08:12:32 -0700 (PDT)
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Alexandre Courbot <acourbot@chromium.org>, vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MUBi+Dn5v4PKngxztFgKd6CA7bC1pKvWd1GMY9NJFoyZQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <b26cb8df-fac3-5941-9941-a6b3ca8af62e@linaro.org>
Date: Fri, 6 Jul 2018 18:12:29 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUBi+Dn5v4PKngxztFgKd6CA7bC1pKvWd1GMY9NJFoyZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 07/02/2018 11:51 AM, Alexandre Courbot wrote:
> On Mon, Jul 2, 2018 at 4:44 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>>
>> Exisiting code returns the max of the decoded
> 
> s/Exisiting/Existing
> 
> Also the lines of your commit message look pretty short - I think the
> standard for kernel log messges is 72 chars?
> 
>> size and buffer size. It turns out that buffer
>> size is always greater due to hardware alignment
>> requirement. As a result, payload size given to
>> client is incorrect. This change ensures that
>> the bytesused is assigned to actual payload size.
>>
>> Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
>> index d079aeb..ada1d2f 100644
>> --- a/drivers/media/platform/qcom/venus/vdec.c
>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>> @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>>
>>                 vb = &vbuf->vb2_buf;
>>                 vb->planes[0].bytesused =
>> -                       max_t(unsigned int, opb_sz, bytesused);
>> +                       min_t(unsigned int, opb_sz, bytesused);
> 
> Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> Tested-by: Alexandre Courbot <acourbot@chromium.org>
> 
> This indeed reports the correct size to the client. If bytesused were
> larger than the size of the buffer we would be having some trouble
> anyway.
> 
> Actually in my tree I was using the following patch:
> 
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -924,13 +924,12 @@ static void vdec_buf_done(struct venus_inst
> *inst, unsigned int buf_type,
> 
>                vb = &vbuf->vb2_buf;
>                vb->planes[0].bytesused =
> -                       max_t(unsigned int, opb_sz, bytesused);
> +                       min_t(unsigned int, opb_sz, bytesused);
>                vb->planes[0].data_offset = data_offset;
>                vb->timestamp = timestamp_us * NSEC_PER_USEC;
>                vbuf->sequence = inst->sequence_cap++;
>                if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
>                        const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
> -                       vb->planes[0].bytesused = bytesused;

Actually this line doesn't exist in mainline driver. And I don't see a
reason why to set bytesused twice.

>                        v4l2_event_queue_fh(&inst->fh, &ev);
> 
> Given that we are now taking the minimum of these two values, it seems
> to me that we don't need to set bytesused again in case we are dealing
> with the last buffer? Stanimir, what do you think?
> 

-- 
regards,
Stan
