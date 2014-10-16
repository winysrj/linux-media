Return-path: <linux-media-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39746 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaJPJQ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 05:16:59 -0400
Message-ID: <543F8D07.4050807@openwrt.org>
Date: Thu, 16 Oct 2014 11:16:55 +0200
From: John Crispin <blogic@openwrt.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] uvcvideo: add a new quirk UVC_QUIRK_SINGLE_ISO
References: <1412966473-5407-1-git-send-email-blogic@openwrt.org> <12847942.ZB1FmjiI8c@avalon>
In-Reply-To: <12847942.ZB1FmjiI8c@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/10/2014 14:03, Laurent Pinchart wrote:
> Hi John,
>
> On Friday 10 October 2014 20:41:12 John Crispin wrote:
>> The following patch adds the usb ids for the iPassion chip. This chip is
>> found on D-Link DIR-930 IP cameras. For them to work this patch needs to be
>> applied. I am almost certain that this is the incorrect fix. Could someone
>> shed a bit of light on how i should really implement the fix ?
> First of all, could you explain how the camera misbehaves without this patch 
> set ?

good question, i created this patch 2 years ago. normally people will
install mjpeg-streamer on these units and that just gave black frames if
i remember correctly. digging through the GPL drop i found this patch.
i will need a couple of days to get my test unit back. once i have it
here i will do some tests and the let you know the exact symptoms.

    John

>> Signed-off-by: John Crispin <blogic@openwrt.org>
>> ---
>>  drivers/media/usb/uvc/uvc_video.c |    2 ++
>>  drivers/media/usb/uvc/uvcvideo.h  |    1 +
>>  2 files changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>> b/drivers/media/usb/uvc/uvc_video.c index 9144a2f..61381fd 100644
>> --- a/drivers/media/usb/uvc/uvc_video.c
>> +++ b/drivers/media/usb/uvc/uvc_video.c
>> @@ -1495,6 +1495,8 @@ static int uvc_init_video_isoc(struct uvc_streaming
>> *stream, if (npackets == 0)
>>  		return -ENOMEM;
>>
>> +	if (stream->dev->quirks & UVC_QUIRK_SINGLE_ISO)
>> +		npackets = 1;
>>  	size = npackets * psize;
>>
>>  	for (i = 0; i < UVC_URBS; ++i) {
>> diff --git a/drivers/media/usb/uvc/uvcvideo.h
>> b/drivers/media/usb/uvc/uvcvideo.h index b1f69a6..b6df4f8 100644
>> --- a/drivers/media/usb/uvc/uvcvideo.h
>> +++ b/drivers/media/usb/uvc/uvcvideo.h
>> @@ -147,6 +147,7 @@
>>  #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
>>  #define UVC_QUIRK_PROBE_DEF		0x00000100
>>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
>> +#define UVC_QUIRK_SINGLE_ISO		0x00000400
>>
>>  /* Format flags */
>>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001
