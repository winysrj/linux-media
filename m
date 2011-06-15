Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1FOOgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 10:36:33 -0400
Message-ID: <4DF8C36D.1000502@redhat.com>
Date: Wed, 15 Jun 2011 11:36:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com>
In-Reply-To: <4DF8C0D2.5070900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-06-2011 11:25, Mauro Carvalho Chehab escreveu:
> Em 15-06-2011 10:43, Hans de Goede escreveu:
>> Hi,
>>
>> On 06/14/2011 04:45 PM, Mauro Carvalho Chehab wrote:
>>> Em 14-06-2011 11:37, Hans de Goede escreveu:
>>>> Hi,
>>>>
>>>> On 06/14/2011 04:17 PM, Mauro Carvalho Chehab wrote:
>>>>> Em 14-06-2011 10:52, Devin Heitmueller escreveu:
>>>>
>>>> <snip>
>>>>
>>>>> Yes.
>>>>>
>>>>> The default for capture is the one detected via sysfs.
>>>>>
>>>>> The default for playback is not really hw:0,0. It defaults to the first hw: that it is not
>>>>> associated with a video device.
>>>>>
>>>>
>>>> I have a really weird idea, why not make the default output device be "default", so that
>>>> xawtv will use whatever the distro (or user if overriden by the user) has configured as
>>>> default alsa output device?
>>>>
>>>> This will do the right thing for pulseaudio and not pulseaudio users alike.
>>>
>>> Pulseaudio sucks.
>>
>> <sigh> Can we stop the pulseaudio bashing please, it is not really constructive. Pulseaudio
>> is happily used by many people and is the default on all major distros.
> 
> It is used because distros packaged it, not because people are happy. Most of the time, it
> doesn't hurt much, but the lack of pulseaudio is one of the good things of RHEL5. Audio is
> more stable there.
> 
>> So we will need
>> to support whether you like it or not.
> 
> Agreed.
> 
>> Also usually when people complain about pulseaudio, they are actually being bitten by
>> bugs elsewhere, but blame pulseaudio, because that seems to be the popular thing
>> to do. And in this case as usual the problem is with the alsa code in xawtv, not in
>> pulseaudio. The alsa code in xawtv is buggy in several places, and makes assumptions
>> it should not (like capture and playback device having a shared period size).
>>
>> See what happens when I pass "-alsa-pb default" argument to pulseaudio:
>>>
>>> 1) ssh section. User is the same as the console owner:
>>>
>>> ALSA lib pulse.c:229:(pulse_connect) PulseAudio: Unable to connect: Connection refused
>>> Cannot open ALSA Playback device default: Connection refused
>>>
>>
>> Right, because ConsoleKit ensures that devices like floppydrives, cdroms, audio cards,
>> webcams, etc. are only available to users sitting behind the console,
> 
> This is a wrong assumption. There's no good reason why other users can't access those
> devices. 
> 
>> usually this works by setting acls on the /dev/foo nodes,
> 
> (Fedora 15)
> $ ls -la /dev/video0 /dev/snd/pcmC1D0c 
> crw-rw----+ 1 root audio 116, 6 Jun 15 11:14 /dev/snd/pcmC1D0c
> crw-rw---- 1 root video 81, 0 Jun 15 11:12 /dev/video0

One small correction here:

Before loging into the console, the permissions are:

$  ls -la /dev/video0 /dev/snd/pcmC1D0c 
crw-rw---- 1 root audio 116, 6 Jun 15 11:14 /dev/snd/pcmC1D0c
crw-rw---- 1 root video  81, 0 Jun 15 11:12 /dev/video0

After that, acl's were added:

$  ls -la /dev/video0 /dev/snd/pcmC1D0c 
crw-rw----+ 1 root audio 116, 6 Jun 15 11:14 /dev/snd/pcmC1D0c
crw-rw----+ 1 root video  81, 0 Jun 15 11:12 /dev/video0

$ getfacl /dev/video0 /dev/snd/pcmC1D0c
getfacl: Removing leading '/' from absolute path names
# file: dev/video0
# owner: root
# group: video
user::rw-
user:mchehab:rw-
group::rw-
mask::rw-
other::---

# file: dev/snd/pcmC1D0c
# owner: root
# group: audio
user::rw-
user:mchehab:rw-
group::rw-
mask::rw-
other::---

I've logged as mchehab, so, ConsoleKit added a new permission. That's OK,
since it didn't remove the permissions for the group.

in this specific case, what's wrong with pulseaudio is that it is not
honouring the ACL permissions for the group.

Cheers,
Mauro.
