Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33224 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbeK0BwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 20:52:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so13608836wrr.0
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 06:57:40 -0800 (PST)
Subject: Re: [PATCH v3] media: venus: amend buffer size for bitstream plane
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Malathi Gottam <mgottam@codeaurora.org>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1543227173-2160-1-git-send-email-mgottam@codeaurora.org>
 <d74281c8-a177-12a3-9e72-7a7db3014943@xs4all.nl>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <f6106d20-abee-979c-8ac1-6c9115e8373c@linaro.org>
Date: Mon, 26 Nov 2018 16:57:37 +0200
MIME-Version: 1.0
In-Reply-To: <d74281c8-a177-12a3-9e72-7a7db3014943@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 11/26/18 3:37 PM, Hans Verkuil wrote:
> On 11/26/2018 11:12 AM, Malathi Gottam wrote:
>> Accept the buffer size requested by client and compare it
>> against driver calculated size and set the maximum to
>> bitstream plane.
>>
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> 
> Sorry, this isn't allowed. It is the driver that sets the sizeimage value,
> never the other way around.

I think for decoders (OUTPUT queue) and encoders (CAPTURE queue) we
allowed userspace to set sizeimage for buffers. See [1] Initialization
paragraph point 2:

    ``sizeimage``
       desired size of ``CAPTURE`` buffers; the encoder may adjust it to
       match hardware requirements

Similar patch we be needed for decoder as well.

> 
> If you need to allocate larger buffers, then use VIDIOC_CREATE_BUFS instead
> of VIDIOC_REQBUFS.
> 
> What problem are you trying to solve with this patch?
> 
> Regards,
> 
> 	Hans
> 

-- 
regards,
Stan

[1] https://www.spinics.net/lists/linux-media/msg142049.html
