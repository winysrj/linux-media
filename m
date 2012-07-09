Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39706 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2GIL6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 07:58:30 -0400
Message-ID: <4FFAC75B.5060506@iki.fi>
Date: Mon, 09 Jul 2012 14:58:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi> <4FF5515A.1030704@redhat.com> <4FF5980F.8030109@iki.fi> <4FF59995.4010604@redhat.com> <4FF5A119.6020903@iki.fi> <4FF5ADE3.5040600@redhat.com> <4FF7EC0E.7060200@redhat.com> <4FF7FAB6.7040508@iki.fi> <4FF885B2.3070509@redhat.com> <4FFAA1B9.6020306@iki.fi> <4FFAAC8F.5080100@redhat.com>
In-Reply-To: <4FFAAC8F.5080100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2012 01:03 PM, Hans de Goede wrote:
> Hi,
>
> On 07/09/2012 11:17 AM, Antti Palosaari wrote:
>> On 07/07/2012 09:53 PM, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 07/07/2012 11:00 AM, Antti Palosaari wrote:
>>>> Hello Hans,
>>>>
>>>> On 07/07/2012 10:58 AM, Hans de Goede wrote:
>>>>> So is your device working properly now? The reason I'm asking it
>>>>> because it is still causing a firmware version warning, and if
>>>>> it works fine I would like to lower the firmware version warning
>>>>> point, so that the warning goes away.
>>>>
>>>> I don't know what is definition of properly in that case.
>>>>
>>>> Problem is that when I use radio application from xawtv3 with that new
>>>> loopback I hear very often cracks and following errors are printed to
>>>> the radio screen:
>>>> ALSA lib pcm.c:7339:(snd_pcm_recover) underrun occurred
>>>> or
>>>> ALSA lib pcm.c:7339:(snd_pcm_recover) overrun occurred
>>>>
>>>> Looks like those does not appear, at least it does not crack so often
>>>> nor errors seen, when I use Rhythmbox to tune and "arecord -D hw:2,0
>>>> -r96000 -c2 -f S16_LE | aplay -" to listen.
>>>  >
>>>> I can guess those are not firmware related so warning texts could be
>>>> removed.
>>>
>>> Actually they may very well be firmware related. At least with my
>>> firmware there
>>> is a bug where actively asking the device for its register contents, it
>>> lets
>>> its audio stream drop.
>>>
>>> My patches fix this by waiting for the device to volunteer it register
>>> contents
>>> through its usb interrupt in endpoint, which it does at xx times / sec.
>>>
>>> So the first question would be, does this dropping of sound happen
>>> approx 1 / sec
>>> when using radio?
>>>
>>> If so this is caused by radio upating the signal strength it displays 1
>>> / sec. If
>>> you look at radio.c line 981 you will see a
>>> radio_getsignal_n_stereo(fd); call
>>> there in the main loop which gets called 1/sec. Try commenting this out.
>>>
>>> If commenting this out fixes your sound issues with radio, then the next
>>> question is are you using my 4 recent si470x patches, if not please
>>> give them a try. If you are already using them then I'm afraid that your
>>> older
>>> firmware may be broken even more then my also not so new firmware.
>>
>> I suspect these signal strength update pops are different thing. Those
>> are almost so minor you cannot even hear.
>>
>> I recorded small sample:
>> http://palosaari.fi/linux/v4l-dvb/xawtv3_radio.m4v
>>
>> And I am almost 100% sure those cracks are coming ALSA
>> underrun/overrun as error text is seen just same time when crack happens.
>
> The signal updates are what is causing the ALSA under-runs (*), the
> over-runs are the result of "catching up" after a under-run.
>
> *) Or at least an important cause of them
>
>> Commenting out line did not help.
>
> Are you sure about this? Did you do a make after commenting, are you
> sure you were using the new build to test?

Yes I ran make and new radio bin was generated. And when I make build 
error as a test build fails so it is compiling.

>> But I think I was also hearing those small pops too and likely new
>> four patches fixes those  - but it is hard to say because it cracks
>> audio all time.
>
> One other thing you can try is increasing the buffer size, using:
> radio -L 1000
>
> For example will increase it from the 500 millisecs default to 1 second

If I tune using old radio it works. If I tune using latest radio but 
with option -l 0 (./console/radio -l 0) it also works. Using "arecord -D 
hw:2,0 -r96000 -c2 -f S16_LE | aplay -" to listen. So it seems that 
latest radio with alsa loopback is only having those problems.


These are the patches:
radio-si470x: Don't unnecesarily read registers on G_TUNER
radio-si470x: Lower hardware freq seek signal treshold
radio-si470x: Always use interrupt to wait for tune/seek completion
radio-si470x: Lower firmware version requirements

And from that I can see it loads new driver as it does not warn about 
software version - only firmware.
Jul  9 14:28:29 localhost kernel: [13403.017920] Linux media interface: 
v0.10
Jul  9 14:28:29 localhost kernel: [13403.020866] Linux video capture 
interface: v2.00
Jul  9 14:28:29 localhost kernel: [13403.022744] radio-si470x 5-2:1.2: 
DeviceID=0x1242 ChipID=0x060c
Jul  9 14:28:29 localhost kernel: [13403.022747] radio-si470x 5-2:1.2: 
This driver is known to work with firmware version 14,
Jul  9 14:28:29 localhost kernel: [13403.022749] radio-si470x 5-2:1.2: 
but the device has firmware version 12.
Jul  9 14:28:29 localhost kernel: [13403.024715] radio-si470x 5-2:1.2: 
software version 1, hardware version 7
Jul  9 14:28:29 localhost kernel: [13403.024717] radio-si470x 5-2:1.2: 
If you have some trouble using this driver,
Jul  9 14:28:29 localhost kernel: [13403.024719] radio-si470x 5-2:1.2: 
please report to V4L ML at linux-media@vger.kernel.org
Jul  9 14:28:29 localhost kernel: [13403.114583] usbcore: registered new 
interface driver radio-si470x

regards
Antti


-- 
http://palosaari.fi/


