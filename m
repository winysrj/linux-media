Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab2GENlP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 09:41:15 -0400
Message-ID: <4FF59995.4010604@redhat.com>
Date: Thu, 05 Jul 2012 15:41:41 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi> <4FF5515A.1030704@redhat.com> <4FF5980F.8030109@iki.fi>
In-Reply-To: <4FF5980F.8030109@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/05/2012 03:35 PM, Antti Palosaari wrote:

<snip>

>> I believe you're doing something wrong ...
>>
>>> I compiled radio from http://git.linuxtv.org/xawtv3.git to tune and
>>  > "arecord  -r96000 -c2 -f S16_LE | aplay - " to play sound. Just
>> silent white noise is heard.
>>
>> You're not specifying which device arecord should record from so likely
>> it is taking
>> the default input of your soundcard (line/mic in), rather then recording
>> from the
>> radio device.
>
> I tried to define hw:1,0 etc. but only hw:0,0 exists.
>
>> Note the latest radio from http://git.linuxtv.org/xawtv3.git will do the
>> digital loopback of
>> the sound itself, so try things again with running arecord / aplay, if
>> you then start radio
>> and exit again (so that you can see its startup messages) you should see
>> something like this:
>>
>> "Using alsa loopback: cap: hw:1,0 (/dev/radio0), out: default"
>>
>> Note radio will automatically select the correct alsa device to record
>> from for the radio-usb-stick.
>
> For some reason I don't see that happening.

Hmm, so it seems that for some reason alsa is not working with the usb
"sound-card" part of the usb-stick. Can you try doing:

ls /dev/snd/

Before and after plugging in the device, you should get a new
PCMC?D0c device there.

Otherwise see if you can enable some debugging options for snd-usb-audio
and find out why it is not liking your device (and maybe at a quirk for
it somewhere) ? If you do end up adding a quirk please let me know
and I'll test with mine to ensure the quirck does not break working versions :)

Regards,

Hans

