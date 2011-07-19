Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1GSP2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 11:28:08 -0400
Message-ID: <4E25A26A.2000204@infradead.org>
Date: Tue, 19 Jul 2011 12:27:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru>
In-Reply-To: <4E259B0C.90107@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-07-2011 11:56, Stas Sergeev escreveu:
> 19.07.2011 18:10, Mauro Carvalho Chehab wrote:
>> As this is an USB device, in general, people don't connect the line out
>> pin. So, typically, in order to unmute this particular device for TV, one
>> should unmute both AC97 MONO and AC97 VIDEO, and mute AC97 LINE IN.
>>
>> If the application latter changes to SVideo, the AC97 VIDEO should be
>> muted, and AC97 LINE IN should be unmuted.
> Unless I am missing the point, you need some mixer control
> that will just unmute the "currently-configured things".
> If you can unmute all the right things when an app just
> starts capturing, then you can as well unmute the same
> things by that _single_ mixer control.
> And if the app changes the output to SVideo, as in your
> example, you can first mute everything, and then unmute
> the new lines, but only if the old lines were unmuted.
> IMHO, that logic will not break the existing apps.

That is the current logic, except that we don't create an additional
virtual mixer control like the one you've proposed via ALSA API.

The business logic coded into the Kernel is that, when audio stream is 
started or a different input is selected, the driver checks the
current applicable mute/volumes and sets the pertinent ones to unmute,
muting the others.

Yet, they allow users to manually adjust the volume controls, as someone
may want for example to use the mixer to mix the original TV audio with
a microphone, for example, connected at the LINE IN input that some boards
offer.

Also, some newer devices are coming with the capability of mixing video
inputs (s5p driver recently added a video mixer). It makes sense for
applications that use it, to also allow controlling the audio mixer.

That's basically why we want to expose such controls to userspace: to allow
users to control the audio mixer when they need, for whatever reason.

If I understood PA concepts, its philosophy seems to hide those controls
that aren't meant to be used by the default usecase. As such, it should
not be exposing any mixer/mute at all from a V4L device.

The proper fix seems to make PA to use libmedia_dev[1] to detect what audio
input devices are associated with a V4L board and removing them for the
list of controlled devices by default, eventually allowing the users to add
them again via some configuration parameter.

[1] http://git.linuxtv.org/v4l-utils.git?a=blob;f=utils/libmedia_dev/README

>> Moving such logic to happen at userspace would be very complex, and will
>> break existing applications.
> If this is the case, then how does the simplest
> xawtv's mute/unmute thing works with all these
> boards right now? (not that I have checked it does,
> but I hope so. :)

Xawtv mute/unmute probably needs fix. It uses 3 different API's for that:
V4L2, ALSA and OSS. Most of the logic there is for OSS, witch can be removed
nowadays.

Feel free to submit patches for it.

Yet, as you may be aware of that, the V4L2 API offers a few audio controls 
(volume, mute, balance, bass, treble), that applies to the current 
stream, on the drivers that provide them. So, a video application may opt to
not control the alsa mixers directly, but, instead, use the V4L2 controls.

Thanks,
Mauro

