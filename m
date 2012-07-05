Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab2GEPH7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 11:07:59 -0400
Message-ID: <4FF5ADE3.5040600@redhat.com>
Date: Thu, 05 Jul 2012 17:08:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi> <4FF5515A.1030704@redhat.com> <4FF5980F.8030109@iki.fi> <4FF59995.4010604@redhat.com> <4FF5A119.6020903@iki.fi>
In-Reply-To: <4FF5A119.6020903@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/05/2012 04:13 PM, Antti Palosaari wrote:
> On 07/05/2012 04:41 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 07/05/2012 03:35 PM, Antti Palosaari wrote:
>>
>> <snip>
>>
>>>> I believe you're doing something wrong ...
>>>>
>>>>> I compiled radio from http://git.linuxtv.org/xawtv3.git to tune and
>>>>  > "arecord  -r96000 -c2 -f S16_LE | aplay - " to play sound. Just
>>>> silent white noise is heard.
>>>>
>>>> You're not specifying which device arecord should record from so likely
>>>> it is taking
>>>> the default input of your soundcard (line/mic in), rather then recording
>>>> from the
>>>> radio device.
>>>
>>> I tried to define hw:1,0 etc. but only hw:0,0 exists.
>>>
>>>> Note the latest radio from http://git.linuxtv.org/xawtv3.git will do the
>>>> digital loopback of
>>>> the sound itself, so try things again with running arecord / aplay, if
>>>> you then start radio
>>>> and exit again (so that you can see its startup messages) you should see
>>>> something like this:
>>>>
>>>> "Using alsa loopback: cap: hw:1,0 (/dev/radio0), out: default"
>>>>
>>>> Note radio will automatically select the correct alsa device to record
>>>> from for the radio-usb-stick.
>>>
>>> For some reason I don't see that happening.
>>
>> Hmm, so it seems that for some reason alsa is not working with the usb
>> "sound-card" part of the usb-stick. Can you try doing:
>>
>> ls /dev/snd/
>>
>> Before and after plugging in the device, you should get a new
>> PCMC?D0c device there.
>
> Two files appears, controlC2 and pcmC2D0c.
>
>> Otherwise see if you can enable some debugging options for snd-usb-audio
>> and find out why it is not liking your device (and maybe at a quirk for
>> it somewhere) ? If you do end up adding a quirk please let me know
>> and I'll test with mine to ensure the quirck does not break working
>> versions :)
>
> And now I can hear the voice too using "arecord -D hw:2,0 -r96000 -c2 -f S16_LE | aplay -".
 >
 > But loopback is still missing.

So if you start radio before starting the arecord, it won't do the loopback for you?
Have you compiled xawtv with alsa support? (this requires the libalsa headers to be installed)

Regards,

Hans
