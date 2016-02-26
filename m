Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45174 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbcBZUIs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 15:08:48 -0500
Subject: Re: [PATCH v3 22/22] sound/usb: Use Media Controller API to share
 media resources
To: Takashi Iwai <tiwai@suse.de>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <0822f80e0acc5119e6f6deccf002ccadeb3b145b.1455233156.git.shuahkh@osg.samsung.com>
 <s5hpovjjlg4.wl-tiwai@suse.de>
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	clemens@ladisch.de, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, mchehab@osg.samsung.com,
	geliangtang@163.com, alsa-devel@alsa-project.org, arnd@arndb.de,
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
Message-ID: <56D0B0CB.8060709@osg.samsung.com>
Date: Fri, 26 Feb 2016 13:08:43 -0700
MIME-Version: 1.0
In-Reply-To: <s5hpovjjlg4.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2016 12:55 PM, Takashi Iwai wrote:
> On Fri, 12 Feb 2016 00:41:38 +0100,
> Shuah Khan wrote:
>>
>> Change ALSA driver to use Media Controller API to
>> share media resources with DVB and V4L2 drivers
>> on a AU0828 media device. Media Controller specific
>> initialization is done after sound card is registered.
>> ALSA creates Media interface and entity function graph
>> nodes for Control, Mixer, PCM Playback, and PCM Capture
>> devices.
>>
>> snd_usb_hw_params() will call Media Controller enable
>> source handler interface to request the media resource.
>> If resource request is granted, it will release it from
>> snd_usb_hw_free(). If resource is busy, -EBUSY is returned.
>>
>> Media specific cleanup is done in usb_audio_disconnect().
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  sound/usb/Kconfig        |   4 +
>>  sound/usb/Makefile       |   2 +
>>  sound/usb/card.c         |  14 +++
>>  sound/usb/card.h         |   3 +
>>  sound/usb/media.c        | 318 +++++++++++++++++++++++++++++++++++++++++++++++
>>  sound/usb/media.h        |  72 +++++++++++
>>  sound/usb/mixer.h        |   3 +
>>  sound/usb/pcm.c          |  28 ++++-
>>  sound/usb/quirks-table.h |   1 +
>>  sound/usb/stream.c       |   2 +
>>  sound/usb/usbaudio.h     |   6 +
>>  11 files changed, 448 insertions(+), 5 deletions(-)
>>  create mode 100644 sound/usb/media.c
>>  create mode 100644 sound/usb/media.h
>>
>> diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
>> index a452ad7..ba117f5 100644
>> --- a/sound/usb/Kconfig
>> +++ b/sound/usb/Kconfig
>> @@ -15,6 +15,7 @@ config SND_USB_AUDIO
>>  	select SND_RAWMIDI
>>  	select SND_PCM
>>  	select BITREVERSE
>> +	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER && MEDIA_SUPPORT
> 
> Looking at the media Kconfig again, this would be broken if
> MEDIA_SUPPORT=m and SND_USB_AUDIO=y.  The ugly workaround is something
> like:
> 	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER \
> 		if MEDIA_CONTROLLER && (MEDIA_SUPPORT=y || MEDIA_SUPPORT=SND)

My current config is MEDIA_SUPPORT=m and SND_USB_AUDIO=y
It is working and I didn't see any issues so far. Maybe
the current change is good. I am hoping kbuild-bot can
find issues (if any) once it gets merged.

> 
> Other than that, it looks more or less OK to me.
> The way how media_stream_init() gets called is a bit worrisome, but it
> should work practically.  Another concern is about the disconnection.
> Can all function calls in media_device_delete() be safe even if it's
> called while the application still opens the MC device?

Right. I have been looking into device removal path when
ioctls are active and I can resolve any issues that might
surface while an audio app is active when device is removed.

> 
> In anyway, such a thing can be improved later once after we get this
> merged, too.  So, feel fee to take my ack.
> 
>  Acked-by: Takashi Iwai <tiwai@suse.de>

thanks for the Ack
-- Shuah

> 
> 
> thanks,
> 
> Takashi
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
