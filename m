Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab1FNNjV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 09:39:21 -0400
Message-ID: <4DF76486.1090809@redhat.com>
Date: Tue, 14 Jun 2011 10:39:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com> <4DF758AF.3010301@redhat.com> <4DF75C84.9000200@redhat.com>
In-Reply-To: <4DF75C84.9000200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-06-2011 10:05, Mauro Carvalho Chehab escreveu:
> Em 14-06-2011 09:48, Hans de Goede escreveu:
>> Hi,
>>
>> On 06/14/2011 04:01 AM, Mauro Carvalho Chehab wrote:
>>> Hi Devin,
>>>
>>> I've made a few fixes for your alsa_stream.c, used on tvtime.
>>> They are at:
>>>     http://git.linuxtv.org/xawtv3.git
>>>
>>>
>>> In particular, those are the more interesting ones:
>>>
>>> commit a1bb5ade5c2b09d6d6d624d18025f9e2c4398495
>>>      alsa_stream: negotiate the frame rate
>>>
>>> Without this patch, one of my em28xx devices doesn't work. It uses
>>> 32 k rate, while the playback minimal rate is 44.1 k.
>>> I've changed the entire frame rate logic, to be more reliable, and to
>>> avoid needing to do frame rate conversion, if both capture and playback
>>> devices support the same rate.
>>>
>>> commit 8adb3d7442b22022b9ca897b0b914962adf41270
>>>      alsa_stream: Reduce CPU usage by putting the thread into blocking mode
>>>
>>> This is just an optimization. I can't see why are you using a non-block
>>> mode, as it works fine blocking.
>>>
>>> commit c67f7aeb86c1caceb7ab30439d169356ea5b1e72
>>>      alsa_stream.c: use mmap mode instead of the normal mode
>>>
>>> Instead of using the normal way, this patch implements mmap mode, and change
>>> it to be the default mode. This should also help to reduce CPU usage.
>>>
>>
>> hmm, does this include automatic fallback to read mode if mmap mode is not
>> available, mmap mode does not work with a number of devices (such as pulseaudio's
>> alsa plugin).
> 
> No, it doesn't. I'm about to add an option at xawtv3 to allow users to manually
> select between mmap/normal, and to change the input/output devices.

The options are there:
	http://git.linuxtv.org/xawtv3.git?a=commit;h=81fc25c5c551ab54fbd90fa6aacd563f03ff73d3

this adds support for -v option inside the alsa_stream, and adds 3 options to allow
manually enabling/disabling mmap and changing the detected alsa devices.

> 
> Well, pulseaudio is a bad behavioured boy that has several broken things, like
> preventing the removal of a V4L2 device for nothing. I won't be surprised if we
> notice even more problems with pulseaudio and V4L devices. At least on my test
> with fedora 15, audio is playing, even if pulseaudio is loaded.
> 
> It should be noticed that the driver tries first to access the alsa driver directly,
> by using hw:0,0 output device. If it fails, it falls back to plughw:0,0. I'm not sure
> what's the name of the pulseaudio output, but I suspect that both are just bypassing
> pulseaudio, with is good ;)
> 
>>
>> Regards,
>>
>> Hans
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

