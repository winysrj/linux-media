Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33622 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbbIARkt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 13:40:49 -0400
Subject: Re: [alsa-devel] Linux 4.2 ALSA snd-usb-audio inconsistent lock state
 warn in PCM nonatomic mode
To: Clemens Ladisch <clemens@ladisch.de>
References: <55E4D9BE.2040308@osg.samsung.com> <55E564ED.4050609@ladisch.de>
Cc: alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <55E5E31F.6040802@osg.samsung.com>
Date: Tue, 1 Sep 2015 11:40:47 -0600
MIME-Version: 1.0
In-Reply-To: <55E564ED.4050609@ladisch.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2015 02:42 AM, Clemens Ladisch wrote:
> Shuah Khan wrote:
>> +++ b/sound/usb/stream.c
>> pcm->private_data = as;
>> pcm->private_free = snd_usb_audio_pcm_free;
>> pcm->info_flags = 0;
>> + pcm->nonatomic = true;
> 
> Why do you think you need nonatomic mode in the USB audio driver?
> 

Short answer is that the need is not a generic one, but a device
specific need to add a fewature. Now the longer version below.

This is for a for AU0828 Hauppauge HVR950Q media device. snd-usb-audio
driver provides Audio Capture support on this device with DVB and Video
drivers driving the device for Digital and Video functions.

I have been working on adding Media Controller support for this chip
as chip specific feature in ALSA. This will allow sharing resources
such as the tuner across the drivers that control the device (DVB,
Video, snd-usb-audio). Media Controller framework uses a mutex to
protect access to resources, hence there is a need to hold this mutex
from SNDRV_PCM_TRIGGER_START and SNDRV_PCM_TRIGGER_STOP which could run
in IRQ context.

The Media Controller mutex can't be converted to a spinlock as it would
break I2C drivers. During review, the idea to run PCM in non-atomic mode
came up as a way to solve the problem. The actual solution would
run PCM in nonatomic context only for the AU0828 Hauppauge HVR950Q chip.

The above change is a quick try to see if PCM nonatomic works with this
device. I have to figure out another way to solve the problem as this
isn't an option.

Hope this helps answer your question. If you would like more information
on the ALSA Media Controller work for this device, I can provide links
to the previous patch series.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
