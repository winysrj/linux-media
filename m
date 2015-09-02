Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33706 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbIBOyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2015 10:54:23 -0400
Subject: Re: [alsa-devel] Linux 4.2 ALSA snd-usb-audio inconsistent lock state
 warn in PCM nonatomic mode
To: Clemens Ladisch <clemens@ladisch.de>
References: <55E4D9BE.2040308@osg.samsung.com> <55E564ED.4050609@ladisch.de>
 <55E5E31F.6040802@osg.samsung.com> <55E5E625.5010403@ladisch.de>
Cc: alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <55E70D97.1010206@osg.samsung.com>
Date: Wed, 2 Sep 2015 08:54:15 -0600
MIME-Version: 1.0
In-Reply-To: <55E5E625.5010403@ladisch.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2015 11:53 AM, Clemens Ladisch wrote:
> Shuah Khan wrote:> On 09/01/2015 02:42 AM, Clemens Ladisch wrote:
>>> Shuah Khan wrote:
>>>> +++ b/sound/usb/stream.c
>>>> pcm->private_data = as;
>>>> pcm->private_free = snd_usb_audio_pcm_free;
>>>> pcm->info_flags = 0;
>>>> + pcm->nonatomic = true;
>>>
>>> Why do you think you need nonatomic mode in the USB audio driver?
>>
>> I have been working on adding Media Controller support for this chip
>> as chip specific feature in ALSA. This will allow sharing resources
>> such as the tuner across the drivers that control the device (DVB,
>> Video, snd-usb-audio). Media Controller framework uses a mutex to
>> protect access to resources, hence there is a need to hold this mutex
>> from SNDRV_PCM_TRIGGER_START and SNDRV_PCM_TRIGGER_STOP which could run
>> in IRQ context.
> 
> Resources should be managed in the hw_params/hw_free callbacks.
> 

snd_usb_hw_params() and snd_usb_hw_free() are the two places
I could add resource access logic and try if that works for
what I am trying to do. Thanks for the tip.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
