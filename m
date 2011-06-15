Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1FONnP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 09:43:15 -0400
Message-ID: <4DF8B716.1020406@redhat.com>
Date: Wed, 15 Jun 2011 15:43:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com>
In-Reply-To: <4DF77405.2070104@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/14/2011 04:45 PM, Mauro Carvalho Chehab wrote:
> Em 14-06-2011 11:37, Hans de Goede escreveu:
>> Hi,
>>
>> On 06/14/2011 04:17 PM, Mauro Carvalho Chehab wrote:
>>> Em 14-06-2011 10:52, Devin Heitmueller escreveu:
>>
>> <snip>
>>
>>> Yes.
>>>
>>> The default for capture is the one detected via sysfs.
>>>
>>> The default for playback is not really hw:0,0. It defaults to the first hw: that it is not
>>> associated with a video device.
>>>
>>
>> I have a really weird idea, why not make the default output device be "default", so that
>> xawtv will use whatever the distro (or user if overriden by the user) has configured as
>> default alsa output device?
>>
>> This will do the right thing for pulseaudio and not pulseaudio users alike.
>
> Pulseaudio sucks.

<sigh> Can we stop the pulseaudio bashing please, it is not really constructive. Pulseaudio
is happily used by many people and is the default on all major distros. So we will need
to support whether you like it or not.

Also usually when people complain about pulseaudio, they are actually being bitten by
bugs elsewhere, but blame pulseaudio, because that seems to be the popular thing
to do. And in this case as usual the problem is with the alsa code in xawtv, not in
pulseaudio. The alsa code in xawtv is buggy in several places, and makes assumptions
it should not (like capture and playback device having a shared period size).

See what happens when I pass "-alsa-pb default" argument to pulseaudio:
>
> 1) ssh section. User is the same as the console owner:
>
> ALSA lib pulse.c:229:(pulse_connect) PulseAudio: Unable to connect: Connection refused
> Cannot open ALSA Playback device default: Connection refused
>

Right, because ConsoleKit ensures that devices like floppydrives, cdroms, audio cards,
webcams, etc. are only available to users sitting behind the console, usually this works
by setting acls on the /dev/foo nodes, so if you're logged in to the console, you can
also access those same devices over ssh, as an unintended side effect. The pulseaudio
daemon actually asks ConsoleKit if the pid on the other end of the unix domain socket
belongs to a session marked as being behind the locale console. Which an ssh session is
not. So this is fully expected.

> 2) console, with mmap enabled:
>
> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
> Access type not available for playback: Invalid argument
> Unable to set parameters for playback stream: Invalid argument
> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz with mmap enabled
> write error: File descriptor in bad state
> ...
> write error: File descriptor in bad state

As already said pulseaudio does not support mmap mode, the reason we are getting
weird errors here is due to a bug in xawtv's alsa params setting code error handling,
which leads to the I don't do mmap mode error not getting caught.

>
> 3) console, with mmap disabled:
>
> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz
> write error: Input/output error
> ...
> write error: Input/output error
>

This is a combination of the assumption there is a shared period size between
the input device and the output device + the broken error handling.
Actually you're lucky, in my case the non proper error handling leads to a
segfault.

I've just pushed an initial set of fixes to the xawtv repo. I'm working on
another set. First thing of that set will be removing the mmap support you
added since it is worthless, quoting from the alsa API documentation:

"If you like to use the compatibility functions in mmap mode, there are
read / write routines equaling to standard read / write transfers. Using
these functions discards the benefits of direct access to memory region.
See the snd_pcm_mmap_readi(), snd_pcm_writei(), snd_pcm_readn() and
snd_pcm_writen() functions."

Note the "Using these functions discards the benefits of direct access to
memory" bit. Properly implementing mmap support is quite hard actually,
and given that we're talking audio here, and thus not large amounts of
we can live with the small memcpy overhead just fine.

On the subject of the current mmap code, it is not only not useful it
is also buggy, asking for:

         snd_pcm_access_mask_set(mask, SND_PCM_ACCESS_MMAP_INTERLEAVED);
         snd_pcm_access_mask_set(mask, SND_PCM_ACCESS_MMAP_NONINTERLEAVED);
         snd_pcm_access_mask_set(mask, SND_PCM_ACCESS_MMAP_COMPLEX);
         err = snd_pcm_hw_params_set_access_mask(handle, params, mask);

Is wrong when using snd_pcm_mmap_readi(), snd_pcm_writei(), when using those
the access mode must be SND_PCM_ACCESS_MMAP_INTERLEAVED, and not one of
the other 2.

Regards,

Hans
