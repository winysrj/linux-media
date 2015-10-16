Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57069 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbbJPJQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 05:16:45 -0400
Message-ID: <5620C004.4090407@xs4all.nl>
Date: Fri, 16 Oct 2015 11:14:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/13] hackrf: add support for transmitter
References: <1441144769-29211-1-git-send-email-crope@iki.fi> <1441144769-29211-11-git-send-email-crope@iki.fi> <55E96D26.8090109@xs4all.nl> <5620BB1D.3050703@xs4all.nl> <5620BC79.9040004@iki.fi>
In-Reply-To: <5620BC79.9040004@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/16/2015 10:59 AM, Antti Palosaari wrote:
> 
> 
> On 10/16/2015 11:53 AM, Hans Verkuil wrote:
>> On 09/04/2015 12:06 PM, Hans Verkuil wrote:
>>> Hi Antti,
>>>
>>> Two comments, see below:
>>>
>>> On 09/01/2015 11:59 PM, Antti Palosaari wrote:
>>>> HackRF SDR device has both receiver and transmitter. There is limitation
>>>> that receiver and transmitter cannot be used at the same time
>>>> (half-duplex operation). That patch implements transmitter support to
>>>> existing receiver only driver.
>>>>
>>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>>> ---
>>>>   drivers/media/usb/hackrf/hackrf.c | 923 ++++++++++++++++++++++++++------------
>>>>   1 file changed, 648 insertions(+), 275 deletions(-)
>>>>
>>>> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
>>>> -static unsigned int hackrf_convert_stream(struct hackrf_dev *dev,
>>>> -		void *dst, void *src, unsigned int src_len)
>>>> +void hackrf_copy_stream(struct hackrf_dev *dev, void *dst,
>>>
>>> Is there any reason 'static' was removed here? It's not used externally as
>>> far as I can tell.
>>>
>>>> +			void *src, unsigned int src_len)
>>>>   {
>>>>   	memcpy(dst, src, src_len);
>>>>
>>>
>>> <snip>
>>>
>>>> +static int hackrf_s_modulator(struct file *file, void *fh,
>>>> +		       const struct v4l2_modulator *a)
>>>> +{
>>>> +	struct hackrf_dev *dev = video_drvdata(file);
>>>> +	int ret;
>>>> +
>>>> +	dev_dbg(dev->dev, "index=%d\n", a->index);
>>>> +
>>>> +	if (a->index == 0)
>>>> +		ret = 0;
>>>> +	else if (a->index == 1)
>>>> +		ret = 0;
>>>> +	else
>>>> +		ret = -EINVAL;
>>>> +
>>>> +	return ret;
>>>> +}
>>>
>>> Why implement this at all? It's not doing anything. I'd just drop s_modulator
>>> support.
>>>
>>> If there is a reason why you do need it, then simplify it to:
>>>
>>> 	return a->index > 1 ? -EINVAL : 0;
>>
>> Oops, I was wrong. You need this regardless for the simple reason that the spec
>> mandates it. And indeed without s_modulator v4l2-compliance will fail.
>>
>> I've put back this function, but replacing the index check with the one-liner I
>> suggested above.
>>
>> I'm merging this hackrf patch series with that change and a small fix for the
>> krobot 'unused intf' warning, so you don't need to do anything.
>>
>> Thanks for doing this work!
> 
> OK, good! Update also documentation changelog / history kernel version 
> number to one which is correct (~4.0 => 4.4).

Done!

	Hans
