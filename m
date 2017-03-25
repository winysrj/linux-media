Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33879 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdCYXOt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 19:14:49 -0400
Received: by mail-wr0-f182.google.com with SMTP id l43so13211418wre.1
        for <linux-media@vger.kernel.org>; Sat, 25 Mar 2017 16:14:42 -0700 (PDT)
Subject: Re: [PATCH v7 5/9] media: venus: vdec: add video decoder files
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
 <1489423058-12492-6-git-send-email-stanimir.varbanov@linaro.org>
 <52b39f43-6f70-0cf6-abaf-4bb5bd2b3d86@xs4all.nl>
 <1490379663.5935.13.camel@ndufresne.ca>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <80de2361-e941-abc4-7900-3102d6ce07a4@linaro.org>
Date: Sun, 26 Mar 2017 01:14:39 +0200
MIME-Version: 1.0
In-Reply-To: <1490379663.5935.13.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 24.03.2017 20:21, Nicolas Dufresne wrote:
> Le vendredi 24 mars 2017 à 15:41 +0100, Hans Verkuil a écrit :
>>> +static const struct venus_format vdec_formats[] = {
>>> +     {
>>> +             .pixfmt = V4L2_PIX_FMT_NV12,
>>> +             .num_planes = 1,
>>> +             .type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
>>
>> Just curious: is NV12 the only uncompressed format supported by the
>> hardware?
>> Or just the only one that is implemented here?

yes, at least to my knowledge (except below UBWC).

>
> The downstream kernel[0], from Qualcomm have:
>
>         {
>                 .name = "UBWC YCbCr Semiplanar 4:2:0",
>                 .description = "UBWC Y/CbCr 4:2:0",
>                 .fourcc = V4L2_PIX_FMT_NV12_UBWC,
>                 .num_planes = 2,
>                 .get_frame_size = get_frame_size_nv12_ubwc,
>                 .type = CAPTURE_PORT,
>         },
>         {
>                 .name = "UBWC YCbCr Semiplanar 4:2:0 10bit",
>                 .description = "UBWC Y/CbCr 4:2:0 10bit",
>                 .fourcc = V4L2_PIX_FMT_NV12_TP10_UBWC,
>                 .num_planes = 2,
>                 .get_frame_size = get_frame_size_nv12_ubwc_10bit,
>                 .type = CAPTURE_PORT,
>         },
>
> I have no idea what UBWC stands for. The performance in NV12 is more
> then decent from my testing. Though, there is no 10bit variant.

UBWC is some kind of compressed format for NV12 [1]. This format is 
applicable for the newer venus hardware revisions and I planed to add it 
later on (when Adreno GPU driver starts handle it).

regards,
Stan

[1] 
https://android.googlesource.com/kernel/msm/+/android-7.1.0_r0.2/include/media/msm_media_info.h#151
