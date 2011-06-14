Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1FNPvs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 11:51:48 -0400
Message-ID: <4DF78390.7060304@redhat.com>
Date: Tue, 14 Jun 2011 12:51:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com>	<BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com>	<4DF76D88.5000506@redhat.com>	<4DF77229.2020607@redhat.com>	<4DF77405.2070104@redhat.com> <BANLkTimXw37fZMsoOqN3ZcWtg7HY1T-w8Q@mail.gmail.com>
In-Reply-To: <BANLkTimXw37fZMsoOqN3ZcWtg7HY1T-w8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-06-2011 11:48, Devin Heitmueller escreveu:
> On Tue, Jun 14, 2011 at 10:45 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Pulseaudio sucks. See what happens when I pass "-alsa-pb default" argument to pulseaudio:
>>
>> 1) ssh section. User is the same as the console owner:
>>
>> ALSA lib pulse.c:229:(pulse_connect) PulseAudio: Unable to connect: Connection refused
>> Cannot open ALSA Playback device default: Connection refused
>>
>> 2) console, with mmap enabled:
>>
>> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
>> Access type not available for playback: Invalid argument
>> Unable to set parameters for playback stream: Invalid argument
>> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz with mmap enabled
>> write error: File descriptor in bad state
>> ...
>> write error: File descriptor in bad state
>>
>> 3) console, with mmap disabled:
>>
>> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
>> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz
>> write error: Input/output error
>> ...
>> write error: Input/output error
>>
>> Pulseaudio needs first to be fixed in order to work like an alsa device, before
>> having applications supporting it as default.

Hans,

Feel free to add pulseaudio support for it, if you want. I don't have time (or
interest) on fixing support for it. Even after fixed, I think that it is safer
to keep the default behavior to directly use alsa, but it is a good idea to
allow users to override.

> People have been screaming about Pulseaudio for *years*, and those
> concerns/complaints have largely fallen on deaf ears. 

Hmm.. I forgot to add a disclaimer on my previous post that my comments express my
own opinion, doesn't reflect the opinion of my employer, and so on ;)

Seriously speaking, I'm not saying that pulseaudio is bad. I just said it didn't
bring anything that _I_ was needing, and that, on the other hand, it broke several
things, requiring some tricks to workaround about it. Well, it works most of the
time, and, on my development machines, I generally don't start X, as I prefer to
work via ssh.

> Lennart works
> for Red Hat too - maybe you can convince him to take these issues
> seriously.

I don't have much contact with Lennart. Red Hat is a big company. I'll talk with
him if I have an opportunity, but I don't think I'll be able to convince him. My
usecase is to use my development machines as if they were servers, working on
them remotely via ssh and tty consoles. This is not the typical usage for pulseaudio. 
Clearly, it were designed thinking on a normal desktop user, as pulseaudio is started 
via X session.

Thanks,
Mauro.
