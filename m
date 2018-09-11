Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46956 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbeIKLyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 07:54:11 -0400
Subject: Re: [PATCH 2/2] vicodec: set state->info before calling the
 encode/decode funcs
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180910150040.39265-1-hverkuil@xs4all.nl>
 <20180910150040.39265-2-hverkuil@xs4all.nl>
 <d58b839f60c07bef6e08184de243380550e75171.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4f8c2f84-c385-afdc-138d-5eb1533809ba@xs4all.nl>
Date: Tue, 11 Sep 2018 08:56:14 +0200
MIME-Version: 1.0
In-Reply-To: <d58b839f60c07bef6e08184de243380550e75171.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 05:37 PM, Ezequiel Garcia wrote:
> On Mon, 2018-09-10 at 17:00 +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> state->info was NULL since I completely forgot to set state->info.
>> Oops.
>>
>> Reported-by: Ezequiel Garcia <ezequiel@collabora.com>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> For both patches:
> 
> Tested-by: Ezequiel Garcia <ezequiel@collabora.com>
> 
> With these changes, now this gstreamer pipeline no longer
> crashes:
> 
> gst-launch-1.0 -v videotestsrc num-buffers=30 ! video/x-raw,width=1280,height=720 ! v4l2fwhtenc capture-io-mode=mmap output-io-mode=mmap ! v4l2fwhtdec
> capture-io-mode=mmap output-io-mode=mmap ! fakesink
> 
> A few things:
> 
>   * You now need to mark "[PATCH] vicodec: fix sparse warning" as invalid.

I'll wait for that to be merged (it's already in a pending pull request), then
rework this patch and add your other patches for a new pull request.

>   * v4l2fwhtenc/v4l2fwhtdec elements are not upstream yet.
>   * Gstreamer doesn't end properly; and it seems to negotiate
>     different sizes for encoded and decoded unless explicitly set.

As mentioned before, vicodec isn't fully compliant with the upcoming
codec spec, and is also missing certain features (selection support,
support for custom bytesperline values, padding, midstream resolution
changes). Patches are welcome.

If you are working on gstreamer elements for this codec, then it would
be great if you could look at making the driver compliant. I have no
plans to work on vicodec until that codec spec is fully finalized, so
you can go ahead with that if you want to.

Would be really nice, and after all, that's why I wrote vicodec!

Regards,

	Hans

> 
> Thanks!
> 
>>  drivers/media/platform/vicodec/vicodec-core.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
>> index fdd77441a47b..5d42a8414283 100644
>> --- a/drivers/media/platform/vicodec/vicodec-core.c
>> +++ b/drivers/media/platform/vicodec/vicodec-core.c
>> @@ -176,12 +176,15 @@ static int device_process(struct vicodec_ctx *ctx,
>>  	}
>>  
>>  	if (ctx->is_enc) {
>> -		unsigned int size = v4l2_fwht_encode(state, p_in, p_out);
>> -
>> -		vb2_set_plane_payload(&out_vb->vb2_buf, 0, size);
>> +		state->info = q_out->info;
>> +		ret = v4l2_fwht_encode(state, p_in, p_out);
>> +		if (ret < 0)
>> +			return ret;
>> +		vb2_set_plane_payload(&out_vb->vb2_buf, 0, ret);
>>  	} else {
>> +		state->info = q_cap->info;
>>  		ret = v4l2_fwht_decode(state, p_in, p_out);
>> -		if (ret)
>> +		if (ret < 0)
>>  			return ret;
>>  		vb2_set_plane_payload(&out_vb->vb2_buf, 0, q_cap->sizeimage);
>>  	}
> 
