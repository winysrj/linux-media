Return-path: <linux-media-owner@vger.kernel.org>
Received: from antispam02.maxim-ic.com ([205.153.101.183]:40449 "EHLO
	antispam02.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2HGIvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 04:51:40 -0400
Message-ID: <5020D3E2.8080600@maxim-ic.com>
Date: Tue, 7 Aug 2012 09:37:54 +0100
From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: Fix uvc_fixup_video_ctrl() format search
References: <1296180273.17673.5.camel@svmlwks101> <201102191335.54479.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102191335.54479.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 19/02/11 12:35, Laurent Pinchart wrote:
> Hi Stephan,
>
> On Friday 28 January 2011 03:04:33 Stephan Lachowsky wrote:
>> The scheme used to index format in uvc_fixup_video_ctrl() is not robust:
>> format index is based on descriptor ordering, which does not necessarily
>> match bFormatIndex ordering.  Searching for first matching format will
>> prevent uvc_fixup_video_ctrl() from using the wrong format/frame to make
>> adjustments.
> Thanks for the patch. It's missing your Signed-off-by line, can I add it ?
Sorry for the late reply, you certainly may.
>> ---
>>   drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
>>   1 files changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_video.c
>> b/drivers/media/video/uvc/uvc_video.c index 5673d67..545c029 100644
>> --- a/drivers/media/video/uvc/uvc_video.c
>> +++ b/drivers/media/video/uvc/uvc_video.c
>> @@ -89,15 +89,19 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query,
>> __u8 unit, static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
>>   	struct uvc_streaming_control *ctrl)
>>   {
>> -	struct uvc_format *format;
>> +	struct uvc_format *format = NULL;
>>   	struct uvc_frame *frame = NULL;
>>   	unsigned int i;
>>
>> -	if (ctrl->bFormatIndex <= 0 ||
>> -	    ctrl->bFormatIndex > stream->nformats)
>> -		return;
>> +	for (i = 0; i < stream->nformats; ++i) {
>> +		if (stream->format[i].index == ctrl->bFormatIndex) {
>> +			format = &stream->format[i];
>> +			break;
>> +		}
>> +	}
>>
>> -	format = &stream->format[ctrl->bFormatIndex - 1];
>> +	if (format == NULL)
>> +		return;
>>
>>   	for (i = 0; i < format->nframes; ++i) {
>>   		if (format->frame[i].bFrameIndex == ctrl->bFrameIndex) {

