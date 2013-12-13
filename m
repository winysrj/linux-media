Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4236 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3LMN7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 08:59:24 -0500
Message-ID: <52AB129D.7050708@xs4all.nl>
Date: Fri, 13 Dec 2013 14:58:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 3/4] v4l: add new tuner types for SDR
References: <1386806043-5331-1-git-send-email-crope@iki.fi> <1386806043-5331-4-git-send-email-crope@iki.fi> <52A96ABF.50905@xs4all.nl> <52A9EE96.4050306@iki.fi>
In-Reply-To: <52A9EE96.4050306@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2013 06:12 PM, Antti Palosaari wrote:
> On 12.12.2013 09:50, Hans Verkuil wrote:
>> On 12/12/2013 12:54 AM, Antti Palosaari wrote:
>>> Define tuner types V4L2_TUNER_ADC and V4L2_TUNER_SDR for SDR usage.
>>>
>>> ADC is used for setting sampling rate (sampling frequency) to SDR
>>> device.
>>>
>>> Another tuner type, SDR, is possible RF tuner. Is is used to
>>> down-convert RF frequency to range ADC could sample. It is optional
>>> for SDR device.
>>>
>>> Also add checks to VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY and
>>> VIDIOC_ENUM_FREQ_BANDS only allow these two tuner types when device
>>> type is SDR (VFL_TYPE_SDR).
>>
>> Shouldn't you also adapt s_hw_freq_seek?
> 
> nope! I don't see how SDR could do hardware seek as demodulator is 
> needed to make decision if radio channel is valid or not. On SDR 
> receiver that demodulator is implemented by application software, DSP, 
> thus name software defined radio.
> 
> Maybe it could be mapped to signal strength measurement, but it is 
> another story to think.

Fair enough, but in that case I would add:

	/* s_hw_freq_seek is not supported for SDR for now */
	if (vfd->vfl_type == VFL_TYPE_SDR)
		return -EINVAL;

at the beginning of v4l_s_hw_freq_seek().

Regards,

	Hans
