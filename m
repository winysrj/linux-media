Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48350 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaAMSaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 13:30:55 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so3482441eaj.15
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 10:30:54 -0800 (PST)
Message-ID: <52D43125.9010601@googlemail.com>
Date: Mon, 13 Jan 2014 19:32:05 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] em28xx: fix check for audio only usb interfaces when
 changing the usb alternate setting
References: <1389447750-2642-1-git-send-email-fschaefer.oss@googlemail.com> <1389447750-2642-2-git-send-email-fschaefer.oss@googlemail.com> <20140112153729.6f87cd2e@samsung.com>
In-Reply-To: <20140112153729.6f87cd2e@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.01.2014 18:37, Mauro Carvalho Chehab wrote:
> Em Sat, 11 Jan 2014 14:42:30 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Previously, we've been assuming that the video endpoints are always at usb
>> interface 0. Hence, if vendor audio endpoints are provided at a separate
>> interface, they were supposed to be at interface number > 0.
>> Instead of checking for (interface number > 0) to determine if an interface is a
>> pure audio interface, dev->is_audio_only should be checked.
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>   drivers/media/usb/em28xx/em28xx-audio.c |   15 +++++++++++++--
>>   1 Datei geändert, 13 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
>> index b2ae954..18b745f 100644
>> --- a/drivers/media/usb/em28xx/em28xx-audio.c
>> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
>> @@ -243,11 +243,22 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
>>   	}
>>   
>>   	runtime->hw = snd_em28xx_hw_capture;
>> -	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
>> -		if (dev->ifnum)
>> +	if (dev->adev.users == 0 && (dev->alt == 0 || dev->is_audio_only)) {
>> +		if (dev->is_audio_only)
>> +			/* vendor audio is on a separate interface */
>>   			dev->alt = 1;
>>   		else
>> +			/* vendor audio is on the same interface as video */
>>   			dev->alt = 7;
>> +			/*
>> +			 * FIXME: The intention seems to be to select the alt
>> +			 * setting with the largest wMaxPacketSize for the video
>> +			 * endpoint.
>> +			 * At least dev->alt and dev->dvb_alt_isoc should be
>> +			 * used instead, but we should probably not touch it at
>> +			 * all if it is already >0, because wMaxPacketSize of
>> +			 * the audio endpoints seems to be the same for all.
>> +			 */
> Actually, it should take into account only the analog case, since, in
> digital mode, the audio comes via the MPEG stream instead.
Yes, of course you are absolutely right.
I will fix the comment.

>
> Ok, it makes sense to return -EBUSY if one tries to use it while using
> DVB.
>
>>   
>>   		dprintk("changing alternate number on interface %d to %d\n",
>>   			dev->ifnum, dev->alt);
>

