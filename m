Return-path: <linux-media-owner@vger.kernel.org>
Received: from dehamd003.servertools24.de ([31.47.254.18]:35305 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbbIASEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 14:04:42 -0400
Message-ID: <55E5E625.5010403@ladisch.de>
Date: Tue, 01 Sep 2015 19:53:41 +0200
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>
CC: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] Linux 4.2 ALSA snd-usb-audio inconsistent lock state
	warn in PCM nonatomic mode
References: <55E4D9BE.2040308@osg.samsung.com> <55E564ED.4050609@ladisch.de>
	<55E5E31F.6040802@osg.samsung.com>
In-Reply-To: <55E5E31F.6040802@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shuah Khan wrote:> On 09/01/2015 02:42 AM, Clemens Ladisch wrote:
>> Shuah Khan wrote:
>>> +++ b/sound/usb/stream.c
>>> pcm->private_data = as;
>>> pcm->private_free = snd_usb_audio_pcm_free;
>>> pcm->info_flags = 0;
>>> + pcm->nonatomic = true;
>>
>> Why do you think you need nonatomic mode in the USB audio driver?
>
> I have been working on adding Media Controller support for this chip
> as chip specific feature in ALSA. This will allow sharing resources
> such as the tuner across the drivers that control the device (DVB,
> Video, snd-usb-audio). Media Controller framework uses a mutex to
> protect access to resources, hence there is a need to hold this mutex
> from SNDRV_PCM_TRIGGER_START and SNDRV_PCM_TRIGGER_STOP which could run
> in IRQ context.

Resources should be managed in the hw_params/hw_free callbacks.


Regards,
Clemens
