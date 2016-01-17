Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50115 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbcAQVWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2016 16:22:44 -0500
Subject: Re: [PATCH v2 26/31] sound/usb: Update ALSA driver to use Managed
 Media Controller API
To: Takashi Iwai <tiwai@suse.de>
References: <cover.1452800265.git.shuahkh@osg.samsung.com>
 <fd72f02797d595fc1c53b16fccec4d204430995e.1452800273.git.shuahkh@osg.samsung.com>
 <s5hmvs7t133.wl-tiwai@suse.de> <56999103.6000005@osg.samsung.com>
 <s5h1t9huc45.wl-tiwai@suse.de>
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	clemens@ladisch.de, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, mchehab@osg.samsung.com,
	alsa-devel@alsa-project.org, arnd@arndb.de,
	ricard.wanderlof@axis.com, labbott@fedoraproject.org,
	chehabrafael@gmail.com, misterpib@gmail.com,
	prabhakar.csengg@gmail.com, ricardo.ribalda@gmail.com,
	ruchandani.tina@gmail.com, takamichiho@gmail.com,
	tvboxspy@gmail.com, dominic.sacre@gmx.de, crope@iki.fi,
	julian@jusst.de, pierre-louis.bossart@linux.intel.com,
	corbet@lwn.net, joe@oampo.co.uk, johan@oljud.se,
	dan.carpenter@oracle.com, pawel@osciak.com, p.zabel@pengutronix.de,
	perex@perex.cz, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, k.kozlowski@samsung.com,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	sw0312.kim@samsung.com, elfring@users.sourceforge.net,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linuxbugs@vittgam.net,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, daniel@zonque.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <569C0614.2000004@osg.samsung.com>
Date: Sun, 17 Jan 2016 14:22:28 -0700
MIME-Version: 1.0
In-Reply-To: <s5h1t9huc45.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/16/2016 02:06 AM, Takashi Iwai wrote:
> On Sat, 16 Jan 2016 01:38:27 +0100,
> Shuah Khan wrote:
>>
>> On 01/15/2016 06:38 AM, Takashi Iwai wrote:
>>> On Thu, 14 Jan 2016 20:52:28 +0100,
>>> Shuah Khan wrote:
>>>>
>>>> Change ALSA driver to use Managed Media Managed Controller
>>>> API to share tuner with DVB and V4L2 drivers that control
>>>> AU0828 media device.  Media device is created based on a
>>>> newly added field value in the struct snd_usb_audio_quirk.
>>>> Using this approach, the media controller API usage can be
>>>> added for a specific device. In this patch, Media Controller
>>>> API is enabled for AU0828 hw. snd_usb_create_quirk() will
>>>> check this new field, if set will create a media device using
>>>> media_device_get_devres() interface.
>>>>
>>>> media_device_get_devres() will allocate a new media device
>>>> devres or return an existing one, if it finds one.
>>>>
>>>> During probe, media usb driver could have created the media
>>>> device devres. It will then initialze (if necessary) and
>>>> register the media device if it isn't already initialized
>>>> and registered. Media device unregister is done from
>>>> usb_audio_disconnect().
>>>>
>>>> During probe, media usb driver could have created the
>>>> media device devres. It will then register the media
>>>> device if it isn't already registered. Media device
>>>> unregister is done from usb_audio_disconnect().
>>>>
>>>> New structure media_ctl is added to group the new
>>>> fields to support media entity and links. This new
>>>> structure is added to struct snd_usb_substream.
>>>>
>>>> A new entity_notify hook and a new ALSA capture media
>>>> entity are registered from snd_usb_pcm_open() after
>>>> setting up hardware information for the PCM device.
>>>>
>>>> When a new entity is registered, Media Controller API
>>>> interface media_device_register_entity() invokes all
>>>> registered entity_notify hooks for the media device.
>>>> ALSA entity_notify hook parses all the entity list to
>>>> find a link from decoder it ALSA entity. This indicates
>>>> that the bridge driver created a link from decoder to
>>>> ALSA capture entity.
>>>>
>>>> ALSA will attempt to enable the tuner to link the tuner
>>>> to the decoder calling enable_source handler if one is
>>>> provided by the bridge driver prior to starting Media
>>>> pipeline from snd_usb_hw_params(). If enable_source returns
>>>> with tuner busy condition, then snd_usb_hw_params() will fail
>>>> with -EBUSY. Media pipeline is stopped from snd_usb_hw_free().
>>>>
>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>> ---
>>>> Changes since v1: Addressed Takasi Iwai's comments on v1
>>>> - Move config defines to Kconfig and add logic
>>>>   to Makefile to conditionally compile media.c
>>>> - Removed extra includes from media.c
>>>> - Added snd_usb_autosuspend() in error leg
>>>> - Removed debug related code that was missed in v1
>>>>
>>>>  sound/usb/Kconfig        |   7 ++
>>>>  sound/usb/Makefile       |   4 +
>>>>  sound/usb/card.c         |   7 ++
>>>>  sound/usb/card.h         |   1 +
>>>>  sound/usb/media.c        | 190 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>  sound/usb/media.h        |  56 ++++++++++++++
>>>>  sound/usb/pcm.c          |  28 +++++--
>>>>  sound/usb/quirks-table.h |   1 +
>>>>  sound/usb/quirks.c       |   5 ++
>>>>  sound/usb/stream.c       |   2 +
>>>>  sound/usb/usbaudio.h     |   1 +
>>>>  11 files changed, 297 insertions(+), 5 deletions(-)
>>>>  create mode 100644 sound/usb/media.c
>>>>  create mode 100644 sound/usb/media.h
>>>>
>>>> diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
>>>> index a452ad7..8d5cdab 100644
>>>> --- a/sound/usb/Kconfig
>>>> +++ b/sound/usb/Kconfig
>>>> @@ -15,6 +15,7 @@ config SND_USB_AUDIO
>>>>  	select SND_RAWMIDI
>>>>  	select SND_PCM
>>>>  	select BITREVERSE
>>>> +	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER && (MEDIA_SUPPORT || MEDIA_SUPPORT_MODULE)
>>>
>>> This looks wrong as a Kconfig syntax.  "... if MEDIA_CONTROLLER"
>>> should work, I suppose?
>>
>> The conditional select syntax is used in several Kconfig
>> files. You are right about (MEDIA_SUPPORT || MEDIA_SUPPORT_MODULE)
>> Adding checks for that is unnecessary.
> 
> Well, my point was that check should be like:
>    select SND_USB_AUDIO_XXX if MEDIA_CONTROLLER && MEDIA_SUPPORT

Thank you for your patience in helping me through this.

I looked into this more and there is no need to check
for MEDIA_SUPPORT. MEDIA_CONTROLLER defined in

if MEDIA_SUPPORT
endif # MEDIA_SUPPORT

block, checking for MEDIA_SUPPORT is unnecessary.

> 
> There is a revere-select, so this menu itself doesn't play any role.
> 
> If you want this item selectable, drop select from SND_USB_AUDIO but
> just have proper dependencies for this item:

Yes Agreed.

> 
> config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
> 	bool "USB Audio/MIDI driver with Media Controller Support"
> 	depends on SND_USB_AUDIO
> 	depends on MEDIA_CONTROLLER
> 	default y
> 
> (Whether default y or not is a remaining question: usually we keep it 
>  empty (i.e. no), but I put it here since you had it.)
> 
> If you want this auto-selected unconditionally, drop the prompt and
> superfluous dependency (and don't set default y):

Yes I want this auto-selected unconditionally so it won't be
disabled by mistake which would lead to errors because ALSA
will be out of sync with DVB and Analog in the way they try
to get access to media resources.

Yes the below will work.

> 
> config SND_USB_AUDIO
> 	....
> 	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER
> 	....
> 
> config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
> 	bool
> 

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
