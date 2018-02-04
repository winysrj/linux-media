Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:50126 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751597AbeBDLJ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 06:09:29 -0500
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
To: "Jasmin J." <jasmin@anw.at>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com,
        arnd@arndb.de
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
 <1778442.ouJt2D3mk7@avalon> <f2e313c8-6013-bd1b-09da-8fa4fc12814e@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e67396cf-c048-b915-d998-306fe44f7186@xs4all.nl>
Date: Sun, 4 Feb 2018 12:09:24 +0100
MIME-Version: 1.0
In-Reply-To: <f2e313c8-6013-bd1b-09da-8fa4fc12814e@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,

On 02/04/2018 11:37 AM, Jasmin J. wrote:
> Hi Laurent!
> 
>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> THX!
> Don't forget the "Acked-by: Arnd Bergmann <arnd@arndb.de>" (see Patchwork:
> https://patchwork.linuxtv.org/patch/46464 ).
> 
>> and taken into my tree for v4.17.
> When will this merged to the media-tree trunk?

We're waiting for the end of the 4.16 merge window. So until it closes no
4.17 pull requests will be merged.

> In another month or earlier?
> 
> This issue was overlooked when merging the change from Arnd in the first place.
> This broke the Kernel build for older Kernels more than two months ago! I fixed
> that in my holidays expecting this gets merged soon and now the build is still
> broken because of this problem.
> 
> In the past Mauro merged those simple fixes soon and now it seems nobody
> cares about building for older Kernels (it's broken for more than two months
> now!). I mostly try to fix such issues in a short time frame (even on
> vacation), but then it gets lost ... . Sorry, but this is frustrating!

Both Mauro (a USB regression) and myself (a nasty v4l2-compat-ioctl32.c bug fix)
have been very busy lately leaving us little time for other things.

For me that meant that I simply did (and still don't) have time to look at
fixing the media_build.

The media_build is also broken worse than usual AFAIK, so it isn't a quick fix
I can do in between other jobs.

> 
> We don't talk about a nice to have fix but a essential fix to get the media
> build system working again. Such patches need to get merged as early as
> possible in my opinion, especially when someone else sent already an "Acked-by"
> (THX to Arnd).
> 
> I could have made this as a patch in the Build system also, but this would be
> the wrong place, but then Hans would have merged it already and I could look
> into the other build problems.

I'm OK to take a patch and then revert it later when the real fix has been merged.

BTW, if you are interested then I would be more than happy to hand over media_build
maintenance to you. I can't give it the attention it deserves, I am well aware of
that. And I don't see that changing in the foreseeable future.

Regards,

	Hans

> 
> BR,
>    Jasmin
> 
> *************************************************************************
> 
> On 02/02/2018 12:32 PM, Laurent Pinchart wrote:
>> Hi Jasmin,
>>
>> Thank you for the patch.
>>
>> On Sunday, 14 January 2018 12:21:43 EET Jasmin J. wrote:
>>> From: Jasmin Jessich <jasmin@anw.at>
>>>
>>> Commit 828ee8c71950 ("media: uvcvideo: Use ktime_t for timestamps")
>>> changed to use ktime_t for timestamps. Older Kernels use a struct for
>>> ktime_t, which requires the conversion function ktime_to_ns to be used on
>>> some places. With this patch it will compile now also for older Kernel
>>> versions.
>>>
>>> Signed-off-by: Jasmin Jessich <jasmin@anw.at>
>>
>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>> and taken into my tree for v4.17.
>>
>>> ---
>>>  drivers/media/usb/uvc/uvc_video.c | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>>> b/drivers/media/usb/uvc/uvc_video.c index 5441553..1670aeb 100644
>>> --- a/drivers/media/usb/uvc/uvc_video.c
>>> +++ b/drivers/media/usb/uvc/uvc_video.c
>>> @@ -1009,7 +1009,7 @@ static int uvc_video_decode_start(struct uvc_streaming
>>> *stream,
>>>
>>>  		buf->buf.field = V4L2_FIELD_NONE;
>>>  		buf->buf.sequence = stream->sequence;
>>> -		buf->buf.vb2_buf.timestamp = uvc_video_get_time();
>>> +		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
>>>
>>>  		/* TODO: Handle PTS and SCR. */
>>>  		buf->state = UVC_BUF_STATE_ACTIVE;
>>> @@ -1191,7 +1191,8 @@ static void uvc_video_decode_meta(struct uvc_streaming
>>> *stream,
>>>
>>>  	uvc_trace(UVC_TRACE_FRAME,
>>>  		  "%s(): t-sys %lluns, SOF %u, len %u, flags 0x%x, PTS %u, STC %u frame
>>> SOF %u\n", -		  __func__, time, meta->sof, meta->length, meta->flags,
>>> +		  __func__, ktime_to_ns(time), meta->sof, meta->length,
>>> +		  meta->flags,
>>>  		  has_pts ? *(u32 *)meta->buf : 0,
>>>  		  has_scr ? *(u32 *)scr : 0,
>>>  		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
>>
>>
