Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:57074 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbeBDKhQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 05:37:16 -0500
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@s-opensource.com, arnd@arndb.de
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
 <1778442.ouJt2D3mk7@avalon>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <f2e313c8-6013-bd1b-09da-8fa4fc12814e@anw.at>
Date: Sun, 4 Feb 2018 11:37:08 +0100
MIME-Version: 1.0
In-Reply-To: <1778442.ouJt2D3mk7@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent!

> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
THX!
Don't forget the "Acked-by: Arnd Bergmann <arnd@arndb.de>" (see Patchwork:
https://patchwork.linuxtv.org/patch/46464 ).

> and taken into my tree for v4.17.
When will this merged to the media-tree trunk?
In another month or earlier?

This issue was overlooked when merging the change from Arnd in the first place.
This broke the Kernel build for older Kernels more than two months ago! I fixed
that in my holidays expecting this gets merged soon and now the build is still
broken because of this problem.

In the past Mauro merged those simple fixes soon and now it seems nobody
cares about building for older Kernels (it's broken for more than two months
now!). I mostly try to fix such issues in a short time frame (even on
vacation), but then it gets lost ... . Sorry, but this is frustrating!

We don't talk about a nice to have fix but a essential fix to get the media
build system working again. Such patches need to get merged as early as
possible in my opinion, especially when someone else sent already an "Acked-by"
(THX to Arnd).

I could have made this as a patch in the Build system also, but this would be
the wrong place, but then Hans would have merged it already and I could look
into the other build problems.

BR,
   Jasmin

*************************************************************************

On 02/02/2018 12:32 PM, Laurent Pinchart wrote:
> Hi Jasmin,
> 
> Thank you for the patch.
> 
> On Sunday, 14 January 2018 12:21:43 EET Jasmin J. wrote:
>> From: Jasmin Jessich <jasmin@anw.at>
>>
>> Commit 828ee8c71950 ("media: uvcvideo: Use ktime_t for timestamps")
>> changed to use ktime_t for timestamps. Older Kernels use a struct for
>> ktime_t, which requires the conversion function ktime_to_ns to be used on
>> some places. With this patch it will compile now also for older Kernel
>> versions.
>>
>> Signed-off-by: Jasmin Jessich <jasmin@anw.at>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> and taken into my tree for v4.17.
> 
>> ---
>>  drivers/media/usb/uvc/uvc_video.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>> b/drivers/media/usb/uvc/uvc_video.c index 5441553..1670aeb 100644
>> --- a/drivers/media/usb/uvc/uvc_video.c
>> +++ b/drivers/media/usb/uvc/uvc_video.c
>> @@ -1009,7 +1009,7 @@ static int uvc_video_decode_start(struct uvc_streaming
>> *stream,
>>
>>  		buf->buf.field = V4L2_FIELD_NONE;
>>  		buf->buf.sequence = stream->sequence;
>> -		buf->buf.vb2_buf.timestamp = uvc_video_get_time();
>> +		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
>>
>>  		/* TODO: Handle PTS and SCR. */
>>  		buf->state = UVC_BUF_STATE_ACTIVE;
>> @@ -1191,7 +1191,8 @@ static void uvc_video_decode_meta(struct uvc_streaming
>> *stream,
>>
>>  	uvc_trace(UVC_TRACE_FRAME,
>>  		  "%s(): t-sys %lluns, SOF %u, len %u, flags 0x%x, PTS %u, STC %u frame
>> SOF %u\n", -		  __func__, time, meta->sof, meta->length, meta->flags,
>> +		  __func__, ktime_to_ns(time), meta->sof, meta->length,
>> +		  meta->flags,
>>  		  has_pts ? *(u32 *)meta->buf : 0,
>>  		  has_scr ? *(u32 *)scr : 0,
>>  		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> 
> 
