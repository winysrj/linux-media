Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1FNORr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 10:17:47 -0400
Message-ID: <4DF76D88.5000506@redhat.com>
Date: Tue, 14 Jun 2011 11:17:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com>
In-Reply-To: <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-06-2011 10:52, Devin Heitmueller escreveu:
> On Tue, Jun 14, 2011 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hmm, we really don't need more cmdline options IMHO, it is quite easy to
>> detect
>> if an alsa device supports mmap mode, and if not fall back to r/w mode, I
>> know
>> several programs which do that (some if which I've written the patches to do
>> this for myself).
> 
> Agreed.
> 
>>> It should be noticed that the driver tries first to access the alsa driver
>>> directly,
>>> by using hw:0,0 output device. If it fails, it falls back to plughw:0,0.
>>> I'm not sure
>>> what's the name of the pulseaudio output, but I suspect that both are just
>>> bypassing
>>> pulseaudio, with is good ;)
>>
>> Right this means you're just bypassing pulse audio, which for a tvcard +
>> tv-viewing
> 
> Actually, the ALSA client libraries route through PulseAudio (as long
> as Pulse is running).  Basically PulseAudio is providing emulation for
> the ALSA interface even if you specify "hw:1,0" as the device.

I'm not so sure about that. This probably depends on how the alsa library
is configured, and this is distribution-specific. I'm almost sure that
pulseaudio won't touch on hw: on Fedora.

>> app is a reasonable thing to do. Defaulting to hw:0,0 makes no sense to me
>> though, we
>> should default to either the audio devices belonging to the video device (as
>> determined
>> through sysfs), or to alsa's default input (which will likely be
>> pulseaudio).
> 
> Mauro was talking about the output device, not the input device.

Yes.

The default for capture is the one detected via sysfs.

The default for playback is not really hw:0,0. It defaults to the first hw: that it is not 
associated with a video device. 

I don't like the idea of defaulting to pulseaudio: on my own experiences, the addition
of pulseaudio didn't bring me any benefit, but it causes several troubles that I needed to
workaround, like disabling the access to the master volume control on a Sony Vaio notebook
while setting it to 0 (I had to manually add some scripting at rc.local to fix), 
limiting the max volume to half of the maximum (very bad effect on some notebooks), 
preventing rmmod of V4L devices, and not working when the development user is different
than the console owner, even when it is at the audio group. I can't think on even a single 
benefit of using it on my usecase.

Besides that, video playback generates too much IO, and, on slower machines, it demands
a lot of CPU time. Not having an extra software layer is a good thing to do for the
default.

If someone wants to use pulseaudio, all they need to do is to pass an extra parameter.
That's said, I was not able yet to discover what are the alsa names for pulseaudio
devices. Any ideas on how to get it?

Mauro
