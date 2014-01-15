Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3067 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaAOSSi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 13:18:38 -0500
Message-ID: <52D6D0E9.4050605@xs4all.nl>
Date: Wed, 15 Jan 2014 19:18:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v6 07/12] v4l: add device capability flag for SDR
 receiver
References: <1388289844-2766-1-git-send-email-crope@iki.fi> <1388289844-2766-8-git-send-email-crope@iki.fi> <52C94C51.2010005@xs4all.nl> <52D49691.4000405@iki.fi> <52D6C488.5090207@iki.fi>
In-Reply-To: <52D6C488.5090207@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2014 06:25 PM, Antti Palosaari wrote:
> On 14.01.2014 03:44, Antti Palosaari wrote:
>> On 05.01.2014 14:13, Hans Verkuil wrote:
>>> On 12/29/2013 05:03 AM, Antti Palosaari wrote:
>>>> VIDIOC_QUERYCAP IOCTL is used to query device capabilities. Add new
>>>> capability flag to inform given device supports SDR capture.
>>>>
>>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>>> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>> ---
>>>>   include/uapi/linux/videodev2.h | 2 ++
>>>>   1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/include/uapi/linux/videodev2.h
>>>> b/include/uapi/linux/videodev2.h
>>>> index c50e449..f596b7b 100644
>>>> --- a/include/uapi/linux/videodev2.h
>>>> +++ b/include/uapi/linux/videodev2.h
>>>> @@ -267,6 +267,8 @@ struct v4l2_capability {
>>>>   #define V4L2_CAP_RADIO            0x00040000  /* is a radio device */
>>>>   #define V4L2_CAP_MODULATOR        0x00080000  /* has a modulator */
>>>>
>>>> +#define V4L2_CAP_SDR_CAPTURE        0x00100000  /* Is a SDR capture
>>>> device */
>>>> +
>>>>   #define V4L2_CAP_READWRITE              0x01000000  /* read/write
>>>> systemcalls */
>>>>   #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>>>>   #define V4L2_CAP_STREAMING              0x04000000  /* streaming
>>>> I/O ioctls */
>>>>
>>>
>>> This new capability needs to be documented in DocBook as well
>>> (vidioc-querycap.xml).
>>
>> It is already.
> 
> There is following related flags:
> 
> V4L2_CAP_TUNER
> V4L2_CAP_RADIO
> V4L2_CAP_MODULATOR
> V4L2_CAP_SDR_CAPTURE
> 
> V4L2_CAP_TUNER flag is overlapping with all these and is redundant at 
> least currently. Lets take a example as a radio device. There is 
> V4L2_CAP_RADIO flag to say it is radio and then there is flag 
> V4L2_CAP_TUNER which means signal is coming from antenna? So there could 
> be radio device without V4L2_CAP_TUNER flag, for example radio over IP, 
> right?

The tuner cap is important to tell the difference between a radio tuner
and a radio modulator. In addition you need this capability tell userspace
that the video capture device has a tuner. Video capture without a tuner
is quite common.

> Due to that I started thinking relation of V4L2_CAP_SDR_CAPTURE and 
> V4L2_CAP_TUNER and V4L2_CAP_RADIO flags. ADC is pretty much mandatory
> element of SDR receiver (and DAC SDR transmitter). Whilst ADC is 
> mandatory, RF tuner is not. So should I map V4L2_CAP_TUNER to indicate 
> there is RF tuner?

I don't think so. The capabilities really tell userspace what APIs are
supported by the driver. Even though the ADC is perhaps not a 'real' tuner,
the tuner API is still used to program it.

Regards,

	Hans

