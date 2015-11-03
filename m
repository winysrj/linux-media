Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56864 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbbKCQGy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2015 11:06:54 -0500
Subject: Re: [PATCH MC Next Gen v2 2/3] sound/usb: Create media mixer function
 and control interface entities
To: Takashi Iwai <tiwai@suse.de>
References: <cover.1445380851.git.shuahkh@osg.samsung.com>
 <2f95ce0190c05e994e02bdc4393be21ec7609adf.1445380851.git.shuahkh@osg.samsung.com>
 <s5hzizbweye.wl-tiwai@suse.de> <562D4B9E.7010006@osg.samsung.com>
Cc: mchehab@osg.samsung.com, perex@perex.cz, chehabrafael@gmail.com,
	hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5638DB95.3070007@osg.samsung.com>
Date: Tue, 3 Nov 2015 09:06:45 -0700
MIME-Version: 1.0
In-Reply-To: <562D4B9E.7010006@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/25/2015 03:37 PM, Shuah Khan wrote:
> On 10/22/2015 01:16 AM, Takashi Iwai wrote:
>> On Wed, 21 Oct 2015 01:25:15 +0200,
>> Shuah Khan wrote:
>>>
>>> Add support for creating MEDIA_ENT_F_AUDIO_MIXER entity for
>>> each mixer and a MEDIA_INTF_T_ALSA_CONTROL control interface
>>> entity that links to mixer entities. MEDIA_INTF_T_ALSA_CONTROL
>>> entity corresponds to the control device for the card.
>>>
>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>> ---
>>>   sound/usb/card.c     |  5 +++
>>>   sound/usb/media.c    | 89
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   sound/usb/media.h    | 20 ++++++++++++
>>>   sound/usb/mixer.h    |  1 +
>>>   sound/usb/usbaudio.h |  1 +
>>>   5 files changed, 116 insertions(+)
>>>
>>> diff --git a/sound/usb/card.c b/sound/usb/card.c
>>> index 469d2bf..d004cb4 100644
>>> --- a/sound/usb/card.c
>>> +++ b/sound/usb/card.c
>>> @@ -560,6 +560,9 @@ static int usb_audio_probe(struct usb_interface
>>> *intf,
>>>       if (err < 0)
>>>           goto __error;
>>>
>>> +    /* Create media entities for mixer and control dev */
>>> +    media_mixer_init(chip);
>>> +
>>>       usb_chip[chip->index] = chip;
>>>       chip->num_interfaces++;
>>>       chip->probing = 0;
>>> @@ -616,6 +619,8 @@ static void usb_audio_disconnect(struct
>>> usb_interface *intf)
>>>           list_for_each(p, &chip->midi_list) {
>>>               snd_usbmidi_disconnect(p);
>>>           }
>>> +        /* delete mixer media resources */
>>> +        media_mixer_delete(chip);
>>>           /* release mixer resources */
>>>           list_for_each_entry(mixer, &chip->mixer_list, list) {
>>>               snd_usb_mixer_disconnect(mixer);
>>> diff --git a/sound/usb/media.c b/sound/usb/media.c
>>> index 0cbfee6..a26ea8b 100644
>>> --- a/sound/usb/media.c
>>> +++ b/sound/usb/media.c
>>> @@ -199,4 +199,93 @@ void media_stop_pipeline(struct
>>> snd_usb_substream *subs)
>>>       if (mctl)
>>>           media_disable_source(mctl);
>>>   }
>>> +
>>> +int media_mixer_init(struct snd_usb_audio *chip)
>>> +{
>>> +    struct device *ctl_dev = &chip->card->ctl_dev;
>>> +    struct media_intf_devnode *ctl_intf;
>>> +    struct usb_mixer_interface *mixer;
>>> +    struct media_device *mdev;
>>> +    struct media_mixer_ctl *mctl;
>>> +    u32 intf_type = MEDIA_INTF_T_ALSA_CONTROL;
>>> +    int ret;
>>> +
>>> +    mdev = media_device_find_devres(&chip->dev->dev);
>>> +    if (!mdev)
>>> +        return -ENODEV;
>>> +
>>> +    ctl_intf = (struct media_intf_devnode *)
>>> chip->ctl_intf_media_devnode;
>>
>> Why do we need cast?  Can't chip->ctl_intf_media_devnode itself be
>> struct media_intf_devndoe pointer?
> 
> Yeah. There is no need to cast here. I will fix it.

Sorry I misspoke. The reason for this cast is ctl_intf_media_devnode
is void to avoid including media.h and other media files in usbaudio.h

The same approach I took for card.h when adding media_ctl to
struct snd_usb_substream

Does this sound reasonable or would you rather see these to be
their respective struct pointers which would require including
media.h in these headers?

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
