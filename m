Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42232 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbbGPHJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 03:09:07 -0400
Subject: Re: [PATCH 8/9] hackrf: add support for transmitter
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1433592188-31748-1-git-send-email-crope@iki.fi>
 <1433592188-31748-8-git-send-email-crope@iki.fi> <55755FE2.4070302@xs4all.nl>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55A75891.9000408@iki.fi>
Date: Thu, 16 Jul 2015 10:09:05 +0300
MIME-Version: 1.0
In-Reply-To: <55755FE2.4070302@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 06/08/2015 12:26 PM, Hans Verkuil wrote:
> Hi Antti,
>
> I've got one comment:
>
> On 06/06/2015 02:03 PM, Antti Palosaari wrote:
>> HackRF SDR device has both receiver and transmitter. There is limitation
>> that receiver and transmitter cannot be used at the same time
>> (half-duplex operation). That patch implements transmitter support to
>> existing receiver only driver.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/usb/hackrf/hackrf.c | 855 ++++++++++++++++++++++++++++----------
>>   1 file changed, 640 insertions(+), 215 deletions(-)
>>
>> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
>> index 5bd291b..6ad6937 100644
>> --- a/drivers/media/usb/hackrf/hackrf.c
>> +++ b/drivers/media/usb/hackrf/hackrf.c
>> +/*
>> + * TODO: That blocks whole transmitter device open when receiver is opened and
>> + * the other way around, even only streaming is not allowed. Better solution
>> + * needed...
>
> Exactly. Why not use a similar approach as for video:
>
> Return EBUSY when the applications tries to call:
>
> S_FREQUENCY, S_MODULATOR, S_TUNER or REQBUFS/CREATE_BUFS and the other
> vb2 queue is marked 'busy'. The check for REQBUFS/CREATE_BUFS can be done
> in hackrf_queue_setup.
>
> You should always be able to open a device node in V4L2.

It is now changed. All the other operations are allowed, but not 
streaming. Driver caches configuration values for both RX and TX mode 
and those are programmed when streaming is started.

regards
Antti

-- 
http://palosaari.fi/
