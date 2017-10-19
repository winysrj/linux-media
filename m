Return-path: <linux-media-owner@vger.kernel.org>
Received: from nat-hk.nvidia.com ([203.18.50.4]:48802 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751592AbdJSHYX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 03:24:23 -0400
Subject: Re: [PATCH resend] [media] uvcvideo: zero seq number when disabling
 stream
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1505456871-12680-1-git-send-email-hansy@nvidia.com>
 <2456831.iuhP316MQr@avalon>
 <alpine.DEB.2.20.1710181042550.11231@axis700.grange>
From: Hans Yang <hansy@nvidia.com>
Message-ID: <4037e7e9-e017-e096-8020-94395260655b@nvidia.com>
Date: Thu, 19 Oct 2017 15:23:06 +0800
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1710181042550.11231@axis700.grange>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Guennadi,

On 2017年10月18日 16:52, Guennadi Liakhovetski wrote:
> Hi Laurent,
> 
> On Mon, 16 Oct 2017, Laurent Pinchart wrote:
> 
>> Hi Hans,
>>
>> (CC'ing Guennadi Liakhovetski)
>>
>> Thank you for the patch.
>>
>> On Friday, 15 September 2017 09:27:51 EEST Hans Yang wrote:
>>> For bulk-based devices, when disabling the video stream,
>>> in addition to issue CLEAR_FEATURE(HALT), it is better to set
>>> alternate setting 0 as well or the sequnce number in host
>>> side will probably not reset to zero.
>>
>> The USB 2.0 specificatin states in the description of the SET_INTERFACE
>> request that "If a device only supports a default setting for the specified
>> interface, then a STALL may be returned in the Status stage of the request".
>>
>> The Linux implementation of usb_set_interface() deals with this by handling
>> STALL conditions and manually clearing HALT for all endpoints in the
>> interface, but I'm still concerned that this change could break existing bulk-
>> based cameras. Do you know what other operating systems do when disabling the
>> stream on bulk cameras ? According to a comment in the driver Windows calls
>> CLEAR_FEATURE(HALT), but the situation might have changed since that was
>> tested.

Sorry I did not mention that it is about SS bulk-based cameras using 
sequence number technique.
 From my observations, invoking usb_clear_halt() will reset the endpoint 
in the device side via CLEAR_FEATURE(HALT)
and reset the sequence number as well; however usb_reset_endpoint() does 
not reset the host side endpoint with xhci driver,
then the sequence number will mismatch in next time stream enable.
I can always observe this through a bus analyzer on Linux implementation 
whatever X86 or ARM based.
This is not observed on the Windows.

>>
>> Guennadi, how do your bulk-based cameras handle this ?
> 
> I don't know what design decisions are implemented there, but I tested a
> couple of cameras for sending a STREAMOFF after a few captured buffers,
> sleeping for a couple of seconds, requeuing buffers, sending STREAMON and
> capturing a few more - that seems to have worked. "Seems" because I only
> used a modified version of capture-example, I haven't checked buffer
> contents.
> 
> BTW, Hans, may I ask - what cameras did you use?

I have three SS bulk-based cameras as follows:
e-con Systems See3CAM_CU130 (2560:c1d0)
Leopard ZED (2b03:f580)
Intel(R) RealSense(TM) Camera SR300 (8086:0aa5)

I can observe the same issue on all above;
besides, to reproduce issue do not let the camera enter suspend because 
it will *help* to reset the sequence number through usb_set_interface(0).

> 
> Thanks
> Guennadi
> 
>>> Then in next time video stream start, the device will expect
>>> host starts packet from 0 sequence number but host actually
>>> continue the sequence number from last transaction and this
>>> causes transaction errors.
>>
>> Do you mean the DATA0/DATA1 toggle ? Why does the host continue toggling the
>> PID from the last transation ? The usb_clear_halt() function calls
>> usb_reset_endpoint() which should reset the DATA PID toggle.
>>
>>> This commit fixes this by adding set alternate setting 0 back
>>> as what isoch-based devices do.
>>>
>>> Below error message will also be eliminated for some devices:
>>> uvcvideo: Non-zero status (-71) in video completion handler.
>>>
>>> Signed-off-by: Hans Yang <hansy@nvidia.com>
>>> ---
>>>   drivers/media/usb/uvc/uvc_video.c | 5 ++---
>>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>>> b/drivers/media/usb/uvc/uvc_video.c index fb86d6af398d..ad80c2a6da6a 100644
>>> --- a/drivers/media/usb/uvc/uvc_video.c
>>> +++ b/drivers/media/usb/uvc/uvc_video.c
>>> @@ -1862,10 +1862,9 @@ int uvc_video_enable(struct uvc_streaming *stream,
>>> int enable)
>>>
>>>   	if (!enable) {
>>>   		uvc_uninit_video(stream, 1);
>>> -		if (stream->intf->num_altsetting > 1) {
>>> -			usb_set_interface(stream->dev->udev,
>>> +		usb_set_interface(stream->dev->udev,
>>>   					  stream->intfnum, 0);
>>> -		} else {
>>> +		if (stream->intf->num_altsetting == 1) {
>>>   			/* UVC doesn't specify how to inform a bulk-based device
>>>   			 * when the video stream is stopped. Windows sends a
>>>   			 * CLEAR_FEATURE(HALT) request to the video streaming
>>
>> -- 
>> Regards,
>>
>> Laurent Pinchart
>>

Regards,
Hans Yang
--nvpublic--
