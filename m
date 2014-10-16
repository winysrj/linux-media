Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40922 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaJPOjR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 10:39:17 -0400
Message-ID: <543FD892.6010209@osg.samsung.com>
Date: Thu, 16 Oct 2014 08:39:14 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, m.chehab@samsung.com,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	crope@iki.fi, olebowle@gmx.com, dheitmueller@kernellabs.com,
	hverkuil@xs4all.nl, ramakrmu@cisco.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, prabhakar.csengg@gmail.com,
	tim.gardner@canonical.com, linux@eikelenboom.it,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de>
In-Reply-To: <s5hy4sgumjo.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/16/2014 08:16 AM, Takashi Iwai wrote:
> At Thu, 16 Oct 2014 08:10:52 -0600,
> Shuah Khan wrote:
>>
>> On 10/16/2014 08:01 AM, Takashi Iwai wrote:
>>> At Thu, 16 Oct 2014 07:10:37 -0600,
>>> Shuah Khan wrote:
>>>>
>>>> On 10/16/2014 06:00 AM, Lars-Peter Clausen wrote:
>>>>> On 10/14/2014 04:58 PM, Shuah Khan wrote:
>>>>> [...]
>>>>>>       switch (cmd) {
>>>>>>       case SNDRV_PCM_TRIGGER_START:
>>>>>> +        err = media_get_audio_tkn(&subs->dev->dev);
>>>>>> +        if (err == -EBUSY) {
>>>>>> +            dev_info(&subs->dev->dev, "%s device is busy\n",
>>>>>> +                    __func__);
>>>>>
>>>>> In my opinion this should not dev_info() as this is out of band error
>>>>> signaling and also as the potential to spam the log. The userspace
>>>>> application is already properly notified by the return code.
>>>>>
>>>>
>>>> Yes it has the potential to flood the dmesg especially with alsa,
>>>> I will remove the dev_info().
>>>
>>> Yes.  And, I think doing this in the trigger isn't the best.
>>> Why not in open & close?
>>
>> My first cut of this change was in open and close. I saw pulseaudio
>> application go into this loop trying to open the device. To avoid
>> such problems, I went with trigger stat and stop. That made all the
>> pulseaudio continues attempts to open problems go away.
> 
> But now starting the stream gives the error, and PA would loop it
> again, no?
> 
> 
>>> Also, is this token restriction needed only for PCM?  No mixer or
>>> other controls?
>>
>> snd_pcm_ops are the only ones media drivers implement and use. So
>> I don't think mixer is needed. If it is needed, it is not to hard
>> to add for that case.
> 
> Well, then I wonder what resource does actually conflict with
> usb-audio and media drivers at all...?
> 

audio for dvb/v4l apps gets disrupted when audio app starts. For
example, dvb or v4l app tuned to a channel, and when an audio app
starts. audio path needs protected to avoid conflicts between
digital and analog applications as well.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
