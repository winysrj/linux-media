Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab1FNOp3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 10:45:29 -0400
Message-ID: <4DF77405.2070104@redhat.com>
Date: Tue, 14 Jun 2011 11:45:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com>
In-Reply-To: <4DF77229.2020607@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-06-2011 11:37, Hans de Goede escreveu:
> Hi,
> 
> On 06/14/2011 04:17 PM, Mauro Carvalho Chehab wrote:
>> Em 14-06-2011 10:52, Devin Heitmueller escreveu:
> 
> <snip>
> 
>> Yes.
>>
>> The default for capture is the one detected via sysfs.
>>
>> The default for playback is not really hw:0,0. It defaults to the first hw: that it is not
>> associated with a video device.
>>
> 
> I have a really weird idea, why not make the default output device be "default", so that
> xawtv will use whatever the distro (or user if overriden by the user) has configured as
> default alsa output device?
> 
> This will do the right thing for pulseaudio and not pulseaudio users alike.

Pulseaudio sucks. See what happens when I pass "-alsa-pb default" argument to pulseaudio:

1) ssh section. User is the same as the console owner:

ALSA lib pulse.c:229:(pulse_connect) PulseAudio: Unable to connect: Connection refused
Cannot open ALSA Playback device default: Connection refused

2) console, with mmap enabled:

Alsa devices: cap: hw:1,0 (/dev/video0), out: default
Access type not available for playback: Invalid argument
Unable to set parameters for playback stream: Invalid argument
Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz with mmap enabled
write error: File descriptor in bad state
...
write error: File descriptor in bad state

3) console, with mmap disabled:

Alsa devices: cap: hw:1,0 (/dev/video0), out: default
Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz
write error: Input/output error
...
write error: Input/output error

Pulseaudio needs first to be fixed in order to work like an alsa device, before
having applications supporting it as default.

Mauro.
