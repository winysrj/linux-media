Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33351 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbeKLW1S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 17:27:18 -0500
Received: by mail-wm1-f66.google.com with SMTP id f19-v6so8788634wmb.0
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 04:34:12 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH] media: venus: amend buffer size for bitstream plane
To: Tomasz Figa <tfiga@chromium.org>, mgottam@codeaurora.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
References: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5BcFr11Hpngpn6hNL91OibAxUv25yh2qMohgfxsKusACw@mail.gmail.com>
Message-ID: <8fe1d205-c5e7-01a0-9569-d3268911cddd@linaro.org>
Date: Mon, 12 Nov 2018 14:34:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BcFr11Hpngpn6hNL91OibAxUv25yh2qMohgfxsKusACw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 10/23/2018 05:50 AM, Tomasz Figa wrote:
> Hi Malathi,
> 
> On Tue, Oct 9, 2018 at 4:58 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>>
>> For lower resolutions, incase of encoder, the compressed
>> frame size is more than half of the corresponding input
>> YUV. Keep the size as same as YUV considering worst case.
>>
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>> ---
>>  drivers/media/platform/qcom/venus/helpers.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> index 2679adb..05c5423 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -649,7 +649,7 @@ u32 venus_helper_get_framesz(u32 v4l2_fmt, u32 width, u32 height)
>>         }
>>
>>         if (compressed) {
>> -               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
>> +               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2;
>>                 return ALIGN(sz, SZ_4K);
>>         }
> 
> Note that the driver should not enforce one particular buffer size for
> bitstream buffers unless it's a workaround for broken firmware or
> hardware. The userspace should be able to select the desired size.

Good point! Yes, we have to extend set_fmt to allow bigger sizeimage for
the compressed buffers (not only for encoder).

-- 
regards,
Stan
