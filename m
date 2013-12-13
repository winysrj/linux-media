Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3202 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3LMP3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:29:42 -0500
Message-ID: <52AB27CC.6030806@xs4all.nl>
Date: Fri, 13 Dec 2013 16:29:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 2/2] v4l2: enable FMT IOCTLs for SDR
References: <1386867447-1018-1-git-send-email-crope@iki.fi> <1386867447-1018-3-git-send-email-crope@iki.fi> <52AB1D71.6060000@xs4all.nl> <52AB21FF.5060903@iki.fi>
In-Reply-To: <52AB21FF.5060903@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2013 04:04 PM, Antti Palosaari wrote:
> On 13.12.2013 16:45, Hans Verkuil wrote:
>> On 12/12/2013 05:57 PM, Antti Palosaari wrote:
>>> Enable format IOCTLs for SDR use. There are used for negotiate used
>>> data stream format.
>>>
>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>> ---
>>>   drivers/media/v4l2-core/v4l2-dev.c   | 12 ++++++++++++
>>>   drivers/media/v4l2-core/v4l2-ioctl.c | 26 ++++++++++++++++++++++++++
>>>   2 files changed, 38 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>>> index c9cf54c..d67286ba 100644
>>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>>> @@ -563,6 +563,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
>>>   	bool is_vid = vdev->vfl_type == VFL_TYPE_GRABBER;
>>>   	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
>>>   	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
>>> +	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
>>>   	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
>>>   	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
>>>
>>> @@ -612,6 +613,17 @@ static void determine_valid_ioctls(struct video_device *vdev)
>>>   	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
>>>   		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
>>>
>>> +	if (is_sdr && is_rx) {
>>
>> I would drop the is_rx part. If there even is something like a SDR transmitter,
>> then I would still expect that the same ioctls are needed.
> 
> There is TX devices too, I am looking it later, maybe on March at earliest.
> 
>>> +		/* SDR specific ioctls */
>>> +		if (ops->vidioc_enum_fmt_vid_cap)
>>> +			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
>>> +		if (ops->vidioc_g_fmt_vid_cap)
>>> +			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
>>> +		if (ops->vidioc_s_fmt_vid_cap)
>>> +			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
>>> +		if (ops->vidioc_try_fmt_vid_cap)
>>> +			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
>>
>> We need sdr-specific ops: vidioc_enum/g/s/try_sdr_cap.
> 
> Yes. But it could be done very easily later as it does not have effect 
> to V4L2 API.

It's much easier to do it right the first time, then to add it in later :-)

Spoken from personal experience...

Anyway, this really should be implemented like that. Things can get very
confusing otherwise.

Regards,

	Hans
