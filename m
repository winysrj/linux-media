Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55353 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaANBoy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 20:44:54 -0500
Message-ID: <52D49691.4000405@iki.fi>
Date: Tue, 14 Jan 2014 03:44:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v6 07/12] v4l: add device capability flag for SDR
 receiver
References: <1388289844-2766-1-git-send-email-crope@iki.fi> <1388289844-2766-8-git-send-email-crope@iki.fi> <52C94C51.2010005@xs4all.nl>
In-Reply-To: <52C94C51.2010005@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.01.2014 14:13, Hans Verkuil wrote:
> On 12/29/2013 05:03 AM, Antti Palosaari wrote:
>> VIDIOC_QUERYCAP IOCTL is used to query device capabilities. Add new
>> capability flag to inform given device supports SDR capture.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
>> ---
>>   include/uapi/linux/videodev2.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index c50e449..f596b7b 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -267,6 +267,8 @@ struct v4l2_capability {
>>   #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
>>   #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
>>
>> +#define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
>> +
>>   #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>>   #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>>   #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
>>
>
> This new capability needs to be documented in DocBook as well (vidioc-querycap.xml).

It is already.

regards
Antti


-- 
http://palosaari.fi/
