Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49367 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbcB2GBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 01:01:31 -0500
Subject: Re: [PATCH v3 22/22] sound/usb: Use Media Controller API to share
 media resources
To: Takashi Iwai <tiwai@suse.de>, mchehab@osg.samsung.com
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <0822f80e0acc5119e6f6deccf002ccadeb3b145b.1455233156.git.shuahkh@osg.samsung.com>
 <s5hpovjjlg4.wl-tiwai@suse.de> <56D0B0CB.8060709@osg.samsung.com>
 <s5hio1bjiws.wl-tiwai@suse.de> <56D1102B.8060501@osg.samsung.com>
 <s5hegbyk30q.wl-tiwai@suse.de>
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	clemens@ladisch.de, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, geliangtang@163.com,
	alsa-devel@alsa-project.org, arnd@arndb.de,
	ricard.wanderlof@axis.com, labbott@fedoraproject.org,
	chehabrafael@gmail.com, klock.android@gmail.com,
	misterpib@gmail.com, prabhakar.csengg@gmail.com,
	ricardo.ribalda@gmail.com, ruchandani.tina@gmail.com,
	takamichiho@gmail.com, tvboxspy@gmail.com, dominic.sacre@gmx.de,
	albert@huitsing.nl, crope@iki.fi, julian@jusst.de,
	pierre-louis.bossart@linux.intel.com, corbet@lwn.net,
	joe@oampo.co.uk, johan@oljud.se, dan.carpenter@oracle.com,
	pawel@osciak.com, p.zabel@pengutronix.de, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	j.anaszewski@samsung.com, jh1009.sung@samsung.com,
	k.kozlowski@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com, elfring@users.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linuxbugs@vittgam.net, gtmkramer@xs4all.nl, normalperson@yhbt.net,
	daniel@zonque.org
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56D3DEA9.9000600@osg.samsung.com>
Date: Sun, 28 Feb 2016 23:01:13 -0700
MIME-Version: 1.0
In-Reply-To: <s5hegbyk30q.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2016 12:48 AM, Takashi Iwai wrote:
> On Sat, 27 Feb 2016 03:55:39 +0100,
> Shuah Khan wrote:
>>
>> On 02/26/2016 01:50 PM, Takashi Iwai wrote:
>>> On Fri, 26 Feb 2016 21:08:43 +0100,
>>> Shuah Khan wrote:
>>>>
>>>> On 02/26/2016 12:55 PM, Takashi Iwai wrote:
>>>>> On Fri, 12 Feb 2016 00:41:38 +0100,
>>>>> Shuah Khan wrote:
>>>>>>
>>>>>> Change ALSA driver to use Media Controller API to
>>>>>> share media resources with DVB and V4L2 drivers
>>>>>> on a AU0828 media device. Media Controller specific
>>>>>> initialization is done after sound card is registered.
>>>>>> ALSA creates Media interface and entity function graph
>>>>>> nodes for Control, Mixer, PCM Playback, and PCM Capture
>>>>>> devices.
>>>>>>
>>>>>> snd_usb_hw_params() will call Media Controller enable
>>>>>> source handler interface to request the media resource.
>>>>>> If resource request is granted, it will release it from
>>>>>> snd_usb_hw_free(). If resource is busy, -EBUSY is returned.
>>>>>>
>>>>>> Media specific cleanup is done in usb_audio_disconnect().
>>>>>>
>>>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>>>> ---
>>>>>>  sound/usb/Kconfig        |   4 +
>>>>>>  sound/usb/Makefile       |   2 +
>>>>>>  sound/usb/card.c         |  14 +++
>>>>>>  sound/usb/card.h         |   3 +
>>>>>>  sound/usb/media.c        | 318 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>  sound/usb/media.h        |  72 +++++++++++
>>>>>>  sound/usb/mixer.h        |   3 +
>>>>>>  sound/usb/pcm.c          |  28 ++++-
>>>>>>  sound/usb/quirks-table.h |   1 +
>>>>>>  sound/usb/stream.c       |   2 +
>>>>>>  sound/usb/usbaudio.h     |   6 +
>>>>>>  11 files changed, 448 insertions(+), 5 deletions(-)
>>>>>>  create mode 100644 sound/usb/media.c
>>>>>>  create mode 100644 sound/usb/media.h
>>>>>>
>>>>>> diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
>>>>>> index a452ad7..ba117f5 100644
>>>>>> --- a/sound/usb/Kconfig
>>>>>> +++ b/sound/usb/Kconfig
>>>>>> @@ -15,6 +15,7 @@ config SND_USB_AUDIO
>>>>>>  	select SND_RAWMIDI
>>>>>>  	select SND_PCM
>>>>>>  	select BITREVERSE
>>>>>> +	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER && MEDIA_SUPPORT
>>>>>
>>>>> Looking at the media Kconfig again, this would be broken if
>>>>> MEDIA_SUPPORT=m and SND_USB_AUDIO=y.  The ugly workaround is something
>>>>> like:
>>>>> 	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER \
>>>>> 		if MEDIA_CONTROLLER && (MEDIA_SUPPORT=y || MEDIA_SUPPORT=SND)
>>>>
>>>> My current config is MEDIA_SUPPORT=m and SND_USB_AUDIO=y
>>>> It is working and I didn't see any issues so far.
>>>
>>> Hmm, how does it be?  In drivers/media/Makefile:
>>>
>>> ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
>>>   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
>>> endif
>>>
>>> So it's a module.  Meanwhile you have reference from usb-audio driver
>>> that is built-in kernel.  How is the symbol resolved?
>>
>> Sorry my mistake. I misspoke. My config had:
>> CONFIG_MEDIA_SUPPORT=m
>> CONFIG_MEDIA_CONTROLLER=y
>> CONFIG_SND_USB_AUDIO=m
>>
>> The following doesn't work as you pointed out.
>>
>> CONFIG_MEDIA_SUPPORT=m
>> CONFIG_MEDIA_CONTROLLER=y
>> CONFIG_SND_USB_AUDIO=y
>>
>> okay here is what will work for all of the possible
>> combinations of CONFIG_MEDIA_SUPPORT and CONFIG_SND_USB_AUDIO
>>
>> select SND_USB_AUDIO_USE_MEDIA_CONTROLLER \
>>        if MEDIA_CONTROLLER && ((MEDIA_SUPPORT=y) || (MEDIA_SUPPORT=m && SND_USB_AUDIO=m))
>>
>> The above will cover the cases when
>>
>> 1. CONFIG_MEDIA_SUPPORT and CONFIG_SND_USB_AUDIO are
>>    both modules
>>    CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER is selected
>>
>> 2. CONFIG_MEDIA_SUPPORT=y and CONFIG_SND_USB_AUDIO=m
>>    CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER is selected
>>
>> 3. CONFIG_MEDIA_SUPPORT=y and CONFIG_SND_USB_AUDIO=y
>>    CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER is selected
>>
>> 4. CONFIG_MEDIA_SUPPORT=m and CONFIG_SND_USB_AUDIO=y
>>    This is when we don't want
>>    CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER selected
>>
>> I verified all of the above combinations to make sure
>> the logic works.
>>
>> If you think of a better way to do this please let me
>> know. I will go ahead and send patch v4 with the above
>> change and you can decide if that is acceptable.
> 
> I'm not 100% sure whether CONFIG_SND_USB_AUDIO=m can be put there as
> conditional inside CONFIG_SND_USB_AUDIO definition.  Maybe a safer
> form would be like:
> 
> config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
> 	bool
> 	default y
> 	depends on SND_USB_AUDIO
> 	depends on MEDIA_CONTROLLER
> 	depends on (MEDIA_SUPPORT=y || MEDIA_SUPPORT=SND_USB_AUDIO)
> 
> and drop select from SND_USB_AUDIO.
> 
> 
>>>>> Other than that, it looks more or less OK to me.
>>>>> The way how media_stream_init() gets called is a bit worrisome, but it
>>>>> should work practically.  Another concern is about the disconnection.
>>>>> Can all function calls in media_device_delete() be safe even if it's
>>>>> called while the application still opens the MC device?
>>>>
>>>> Right. I have been looking into device removal path when
>>>> ioctls are active and I can resolve any issues that might
>>>> surface while an audio app is active when device is removed.
>>>
>>> So, it's 100% safe to call all these media_*() functions while the
>>> device is being accessed before closing?
>>>
>>
>> There is a known problem with device removal when
>> media device file is open and ioctl is in progress.
>> This isn't specific to this patch series, a general
>> problem that is related to media device removal in
>> general.
>>
>> I am working on a fix for this problem. As you said,
>> earlier, I can work on fixing issues after the merge.
> 
> OK, understood.
> 
> 

Hi Takashi,

I sent patch v4 that works for all combinations
of MEDIA_SUPPORT and SND_USB_AUDIO.

Please review and Ack if you are okay with this
version. Thanks for your help with the Kconfig
file changes.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
