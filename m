Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab2GIKDc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 06:03:32 -0400
Message-ID: <4FFAAC8F.5080100@redhat.com>
Date: Mon, 09 Jul 2012 12:03:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi> <4FF5515A.1030704@redhat.com> <4FF5980F.8030109@iki.fi> <4FF59995.4010604@redhat.com> <4FF5A119.6020903@iki.fi> <4FF5ADE3.5040600@redhat.com> <4FF7EC0E.7060200@redhat.com> <4FF7FAB6.7040508@iki.fi> <4FF885B2.3070509@redhat.com> <4FFAA1B9.6020306@iki.fi>
In-Reply-To: <4FFAA1B9.6020306@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/09/2012 11:17 AM, Antti Palosaari wrote:
> On 07/07/2012 09:53 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 07/07/2012 11:00 AM, Antti Palosaari wrote:
>>> Hello Hans,
>>>
>>> On 07/07/2012 10:58 AM, Hans de Goede wrote:
>>>> So is your device working properly now? The reason I'm asking it
>>>> because it is still causing a firmware version warning, and if
>>>> it works fine I would like to lower the firmware version warning
>>>> point, so that the warning goes away.
>>>
>>> I don't know what is definition of properly in that case.
>>>
>>> Problem is that when I use radio application from xawtv3 with that new
>>> loopback I hear very often cracks and following errors are printed to
>>> the radio screen:
>>> ALSA lib pcm.c:7339:(snd_pcm_recover) underrun occurred
>>> or
>>> ALSA lib pcm.c:7339:(snd_pcm_recover) overrun occurred
>>>
>>> Looks like those does not appear, at least it does not crack so often
>>> nor errors seen, when I use Rhythmbox to tune and "arecord -D hw:2,0
>>> -r96000 -c2 -f S16_LE | aplay -" to listen.
>>  >
>>> I can guess those are not firmware related so warning texts could be
>>> removed.
>>
>> Actually they may very well be firmware related. At least with my
>> firmware there
>> is a bug where actively asking the device for its register contents, it
>> lets
>> its audio stream drop.
>>
>> My patches fix this by waiting for the device to volunteer it register
>> contents
>> through its usb interrupt in endpoint, which it does at xx times / sec.
>>
>> So the first question would be, does this dropping of sound happen
>> approx 1 / sec
>> when using radio?
>>
>> If so this is caused by radio upating the signal strength it displays 1
>> / sec. If
>> you look at radio.c line 981 you will see a
>> radio_getsignal_n_stereo(fd); call
>> there in the main loop which gets called 1/sec. Try commenting this out.
>>
>> If commenting this out fixes your sound issues with radio, then the next
>> question is are you using my 4 recent si470x patches, if not please
>> give them a try. If you are already using them then I'm afraid that your
>> older
>> firmware may be broken even more then my also not so new firmware.
>
> I suspect these signal strength update pops are different thing. Those are almost so minor you cannot even hear.
>
> I recorded small sample:
> http://palosaari.fi/linux/v4l-dvb/xawtv3_radio.m4v
>
> And I am almost 100% sure those cracks are coming ALSA underrun/overrun as error text is seen just same time when crack happens.

The signal updates are what is causing the ALSA under-runs (*), the over-runs are the result of "catching up" after a under-run.

*) Or at least an important cause of them

> Commenting out line did not help.

Are you sure about this? Did you do a make after commenting, are you sure you were using the new build to test?

> But I think I was also hearing those small pops too and likely new four patches fixes those  - but it is hard to say because it cracks audio all time.

One other thing you can try is increasing the buffer size, using:
radio -L 1000

For example will increase it from the 500 millisecs default to 1 second

Regards,

Hans
