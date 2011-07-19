Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55652 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1GSNAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:00:52 -0400
Message-ID: <4E257FF5.4040401@infradead.org>
Date: Tue, 19 Jul 2011 10:00:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Lennart Poettering <lpoetter@redhat.com>
CC: Stas Sergeev <stsp@list.ru>, linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>,
	lennart@poettering.net
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com>
In-Reply-To: <4E24BEB8.4060501@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-07-2011 20:16, Lennart Poettering escreveu:
> Heya,
>
> On 17.07.2011 13:51, Mauro Carvalho Chehab wrote:
>
>> If pulseaudio is starting sound capture at startup, then it is either
>> a pulseaudio miss-configuration or a bug there. I fail to understand
>> why pulseaudio would start capturing sound from a V4L audio at startup.
>>
>> I think that this is not the default for pulseaudio, though, as
>> you're the only one complaining about that, and I never saw such
>> behavior in the time I was using pulseaudio here.
>>
>> I don't know enough about pulseaudio to help on this issue,
>> nor I'm using it currently, so I can't test anything pulsaudio-related.
>>
>> Lennart,
>>
>> Could you please help us with this issue?
>
> ALSA doesn't really have a enumeration API which would allow us to get device properties without opening and configuring a device. In fact, we can't even figure out whether a device may be opened in duplex or simplex without opening it.
>
> And that's why we have to probe audio devices, even if it sucks.

Lennart,

The thing is that starting capture on a video device has some side effects,
as it will start capturing from a radio or TV station without specifying
the desired frequency.

Several video boards have the option of plugging a loop cable between
the device output pin and the motherboard line in pin. So, if you start
capturing, you'll also enabling the output of such pin, as the kernel
driver has no way to know if the user decided to use a wire cable, instead
of the ALSA PCM stream.

So, if users with such cables are lucky, it will play something, but,
on most cases, it will just tune into a non-existing station, and it will
produce a white noise.

The right thing to do is to get rid of capturing on a video device, if you're
not sure that the device is properly tuned.

It is easy to detect that an audio device is provided by a v4l device. All
you need to do is to look at the parent device via sysfs.

Cheers,
Mauro

