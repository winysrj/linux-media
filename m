Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4156 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaJUPnY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 11:43:24 -0400
Message-ID: <54467EFB.7050800@xs4all.nl>
Date: Tue, 21 Oct 2014 17:42:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Shuah Khan <shuahkh@osg.samsung.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, m.chehab@samsung.com,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	crope@iki.fi, olebowle@gmx.com, dheitmueller@kernellabs.com,
	ramakrmu@cisco.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com, perex@perex.cz,
	prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
	linux@eikelenboom.it, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com>	<cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>	<543FB374.8020604@metafoo.de>	<543FC3CD.8050805@osg.samsung.com>	<s5h38aow1ub.wl-tiwai@suse.de>	<543FD1EC.5010206@osg.samsung.com>	<s5hy4sgumjo.wl-tiwai@suse.de>	<543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de>
In-Reply-To: <s5htx34ul3w.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/16/2014 04:48 PM, Takashi Iwai wrote:
> At Thu, 16 Oct 2014 08:39:14 -0600,
> Shuah Khan wrote:
>>
>> On 10/16/2014 08:16 AM, Takashi Iwai wrote:
>>> At Thu, 16 Oct 2014 08:10:52 -0600,
>>> Shuah Khan wrote:
>>>>
>>>> On 10/16/2014 08:01 AM, Takashi Iwai wrote:
>>>>> At Thu, 16 Oct 2014 07:10:37 -0600,
>>>>> Shuah Khan wrote:
>>>>>>
>>>>>> On 10/16/2014 06:00 AM, Lars-Peter Clausen wrote:
>>>>>>> On 10/14/2014 04:58 PM, Shuah Khan wrote:
>>>>>>> [...]
>>>>>>>>        switch (cmd) {
>>>>>>>>        case SNDRV_PCM_TRIGGER_START:
>>>>>>>> +        err = media_get_audio_tkn(&subs->dev->dev);
>>>>>>>> +        if (err == -EBUSY) {
>>>>>>>> +            dev_info(&subs->dev->dev, "%s device is busy\n",
>>>>>>>> +                    __func__);
>>>>>>>
>>>>>>> In my opinion this should not dev_info() as this is out of band error
>>>>>>> signaling and also as the potential to spam the log. The userspace
>>>>>>> application is already properly notified by the return code.
>>>>>>>
>>>>>>
>>>>>> Yes it has the potential to flood the dmesg especially with alsa,
>>>>>> I will remove the dev_info().
>>>>>
>>>>> Yes.  And, I think doing this in the trigger isn't the best.
>>>>> Why not in open & close?
>>>>
>>>> My first cut of this change was in open and close. I saw pulseaudio
>>>> application go into this loop trying to open the device. To avoid
>>>> such problems, I went with trigger stat and stop. That made all the
>>>> pulseaudio continues attempts to open problems go away.
>>>
>>> But now starting the stream gives the error, and PA would loop it
>>> again, no?
>>>
>>>
>>>>> Also, is this token restriction needed only for PCM?  No mixer or
>>>>> other controls?
>>>>
>>>> snd_pcm_ops are the only ones media drivers implement and use. So
>>>> I don't think mixer is needed. If it is needed, it is not to hard
>>>> to add for that case.
>>>
>>> Well, then I wonder what resource does actually conflict with
>>> usb-audio and media drivers at all...?
>>>
>>
>> audio for dvb/v4l apps gets disrupted when audio app starts. For
>> example, dvb or v4l app tuned to a channel, and when an audio app
>> starts. audio path needs protected to avoid conflicts between
>> digital and analog applications as well.
>
> OK, then concentrating on only PCM is fine.
>
> But, I'm still not convinced about doing the token management in the
> trigger.  The reason -EBUSY doesn't work is that it's the very same
> error code when a PCM device is blocked by other processes.  And
> -EAGAIN is interpreted by PCM core to -EBUSY for historical reasons.
>
> How applications (e.g. PA) should behave if the token get fails?
> Shouldn't it retry or totally give up?

Quite often media apps open the alsa device at the start and then switch
between TV, radio or DVB mode. If the alsa device would claim the tuner
just by being opened (as opposed to actually using the tuner, which happens
when you start streaming), then that would make it impossible for the
application to switch tuner mode. In general you want to avoid that open()
will start configuring hardware since that can quite often be slow. Tuner
configuration in particular can be slow since several common tuners need
to load firmware over i2c. You only want to do that when it is really needed,
and not when some application (udev!) opens the device just to examine what
sort of device it is.

So claiming the tuner in the trigger seems to be the right place. If
returning EBUSY is a poor error code for alsa, then we can use something else
for that. EACCES perhaps?

Regards,

	Hans
