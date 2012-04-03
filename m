Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46919 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2DCK7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2012 06:59:16 -0400
Received: by qatm19 with SMTP id m19so2876616qat.19
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2012 03:59:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7AD4DB.9040403@samsung.com>
References: <1333440294-382-1-git-send-email-sachin.kamat@linaro.org>
	<4F7AD4DB.9040403@samsung.com>
Date: Tue, 3 Apr 2012 16:29:15 +0530
Message-ID: <CAK9yfHxzveHSG3ihTe3=yL7+oTDY2i72fTydF5Vw3R7TEnezMg@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-tv: Fix compiler warning in mixer_video.c file
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok. Please ignore my patch.

Looks like this series has not yet made into mainline.

On 03/04/2012, Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
> Hi Sachin Kamat,
> Thanks for the patch.
> However, the patch is already a duplicate of
>
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/45756/focus=45752
>
> Regards,
> Tomasz Stanislawski
>
> On 04/03/2012 10:04 AM, Sachin Kamat wrote:
>> Fixes the following warning:
>>
>> mixer_video.c:857:3: warning: format ‘%lx’ expects argument of type
>> ‘long unsigned int’, but argument 5 has type ‘unsigned int’ [-Wformat]
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/video/s5p-tv/mixer_video.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-tv/mixer_video.c
>> b/drivers/media/video/s5p-tv/mixer_video.c
>> index f7ca5cc..bb33d7c 100644
>> --- a/drivers/media/video/s5p-tv/mixer_video.c
>> +++ b/drivers/media/video/s5p-tv/mixer_video.c
>> @@ -854,7 +854,7 @@ static int queue_setup(struct vb2_queue *vq, const
>> struct v4l2_format *pfmt,
>>  	for (i = 0; i < fmt->num_subframes; ++i) {
>>  		alloc_ctxs[i] = layer->mdev->alloc_ctx;
>>  		sizes[i] = PAGE_ALIGN(planes[i].sizeimage);
>> -		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
>> +		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
>>  	}
>>
>>  	if (*nbuffers == 0)
>
>


-- 
With warm regards,
Sachin
