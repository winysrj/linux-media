Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1FOOZ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 10:25:26 -0400
Message-ID: <4DF8C0D2.5070900@redhat.com>
Date: Wed, 15 Jun 2011 11:25:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com>
In-Reply-To: <4DF8B716.1020406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-06-2011 10:43, Hans de Goede escreveu:
> Hi,
> 
> On 06/14/2011 04:45 PM, Mauro Carvalho Chehab wrote:
>> Em 14-06-2011 11:37, Hans de Goede escreveu:
>>> Hi,
>>>
>>> On 06/14/2011 04:17 PM, Mauro Carvalho Chehab wrote:
>>>> Em 14-06-2011 10:52, Devin Heitmueller escreveu:
>>>
>>> <snip>
>>>
>>>> Yes.
>>>>
>>>> The default for capture is the one detected via sysfs.
>>>>
>>>> The default for playback is not really hw:0,0. It defaults to the first hw: that it is not
>>>> associated with a video device.
>>>>
>>>
>>> I have a really weird idea, why not make the default output device be "default", so that
>>> xawtv will use whatever the distro (or user if overriden by the user) has configured as
>>> default alsa output device?
>>>
>>> This will do the right thing for pulseaudio and not pulseaudio users alike.
>>
>> Pulseaudio sucks.
> 
> <sigh> Can we stop the pulseaudio bashing please, it is not really constructive. Pulseaudio
> is happily used by many people and is the default on all major distros.

It is used because distros packaged it, not because people are happy. Most of the time, it
doesn't hurt much, but the lack of pulseaudio is one of the good things of RHEL5. Audio is
more stable there.

> So we will need
> to support whether you like it or not.

Agreed.

> Also usually when people complain about pulseaudio, they are actually being bitten by
> bugs elsewhere, but blame pulseaudio, because that seems to be the popular thing
> to do. And in this case as usual the problem is with the alsa code in xawtv, not in
> pulseaudio. The alsa code in xawtv is buggy in several places, and makes assumptions
> it should not (like capture and playback device having a shared period size).
> 
> See what happens when I pass "-alsa-pb default" argument to pulseaudio:
>>
>> 1) ssh section. User is the same as the console owner:
>>
>> ALSA lib pulse.c:229:(pulse_connect) PulseAudio: Unable to connect: Connection refused
>> Cannot open ALSA Playback device default: Connection refused
>>
> 
> Right, because ConsoleKit ensures that devices like floppydrives, cdroms, audio cards,
> webcams, etc. are only available to users sitting behind the console,

This is a wrong assumption. There's no good reason why other users can't access those
devices. 

> usually this works by setting acls on the /dev/foo nodes,

(Fedora 15)
$ ls -la /dev/video0 /dev/snd/pcmC1D0c 
crw-rw----+ 1 root audio 116, 6 Jun 15 11:14 /dev/snd/pcmC1D0c
crw-rw---- 1 root video 81, 0 Jun 15 11:12 /dev/video0

That seems OK to me. Adding an user at the video and audio group should be enough to allow
somebody else to use it. In my case:

audio:x:63:vdr,mchehab,v4l,mythtv
video:x:39:vdr,mchehab,v4l,mythtv

> so if you're logged in to the console, you can
> also access those same devices over ssh, as an unintended side effect. 

Or if you are at the audio and video groups.

> The pulseaudio
> daemon actually asks ConsoleKit if the pid on the other end of the unix domain socket
> belongs to a session marked as being behind the locale console. Which an ssh session is
> not. So this is fully expected.

This is wrong, as pulseaudio (or ConsoleKit) is not checking if the user has permission
for using the device at the Unix group.

>> 2) console, with mmap enabled:
>>
>> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
>> Access type not available for playback: Invalid argument
>> Unable to set parameters for playback stream: Invalid argument
>> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz with mmap enabled
>> write error: File descriptor in bad state
>> ...
>> write error: File descriptor in bad state
> 
> As already said pulseaudio does not support mmap mode, the reason we are getting
> weird errors here is due to a bug in xawtv's alsa params setting code error handling,
> which leads to the I don't do mmap mode error not getting caught.
> 
>>
>> 3) console, with mmap disabled:
>>
>> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
>> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz
>> write error: Input/output error
>> ...
>> write error: Input/output error
>>
> 
> This is a combination of the assumption there is a shared period size between
> the input device and the output device + the broken error handling.

The code is doing a negotiation, in order to find a period that are acceptable
by both. Ok, there are other ways of doing it, but sharing the same period 
probably means less overhead.

> Actually you're lucky, in my case the non proper error handling leads to a
> segfault.
> 
> I've just pushed an initial set of fixes to the xawtv repo. I'm working on
> another set. First thing of that set will be removing the mmap support you
> added since it is worthless, quoting from the alsa API documentation:
> 
> "If you like to use the compatibility functions in mmap mode, there are
> read / write routines equaling to standard read / write transfers. Using
> these functions discards the benefits of direct access to memory region.
> See the snd_pcm_mmap_readi(), snd_pcm_writei(), snd_pcm_readn() and
> snd_pcm_writen() functions."

The driver is using snd_pcm_mmap_readi() and snd_pcm_writei() at the mmap mode.
The code there came from aplay source code and works properly. Please don't
remove it.

> Note the "Using these functions discards the benefits of direct access to
> memory" bit. Properly implementing mmap support is quite hard actually,
> and given that we're talking audio here, and thus not large amounts of
> we can live with the small memcpy overhead just fine.

If you do some tests with mplayer and a few audio devices, you'll find that
the audio performance may degrade the video streaming up to some point where
you can't see the video stream. It is wise to offer a few options to the
user, in order to allow workaround on that.

> On the subject of the current mmap code, it is not only not useful it
> is also buggy, asking for:
> 
>         snd_pcm_access_mask_set(mask, SND_PCM_ACCESS_MMAP_INTERLEAVED);
>         snd_pcm_access_mask_set(mask, SND_PCM_ACCESS_MMAP_NONINTERLEAVED);
>         snd_pcm_access_mask_set(mask, SND_PCM_ACCESS_MMAP_COMPLEX);
>         err = snd_pcm_hw_params_set_access_mask(handle, params, mask);
> 
> Is wrong when using snd_pcm_mmap_readi(), snd_pcm_writei(), when using those
> the access mode must be SND_PCM_ACCESS_MMAP_INTERLEAVED, and not one of
> the other 2.

This is just what aplay is doing. So, or alsa-utils-1.0.24.1-3.fc15.i686
is broken, or the documentation is outdated.

Cheers,
Mauro
