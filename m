Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1GSSGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 14:06:48 -0400
Message-ID: <4E25C7AE.5020503@infradead.org>
Date: Tue, 19 Jul 2011 15:06:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru>
In-Reply-To: <4E25A7C2.3050609@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-07-2011 12:50, Stas Sergeev escreveu:
> 19.07.2011 19:27, Mauro Carvalho Chehab wrote:
>>> Unless I am missing the point, you need some mixer control
>>> that will just unmute the "currently-configured things".
>>> If you can unmute all the right things when an app just
>>> starts capturing, then you can as well unmute the same
>>> things by that _single_ mixer control.
>>> And if the app changes the output to SVideo, as in your
>>> example, you can first mute everything, and then unmute
>>> the new lines, but only if the old lines were unmuted.
>>> IMHO, that logic will not break the existing apps.
>> That is the current logic, except that we don't create an additional
>> virtual mixer control like the one you've proposed via ALSA API.
> Unless I am mistaken, this control is usually called a
> "Master Playback Switch" in the alsa world.

No, you're mistaken: on most boards, you have only one volume control/switch,
for capture. So, it would be a "master capture switch", but I don't think
that there's such alsa "generic" volume control. Even in the case where
you have a volume control for the LINE OUT pin[1], in general, you also need to
unmute the capture, so, it would be a "master capture and LINE OUT switch",
and, for sure alsa currently not provide anything like that.

> So, am I right that the only problem is that it is not
> exported to the user by some drivers right now?

No, you're mistaken again. Such "master capture and LINE OUT switch" type of control
_is_exported_ via the V4L2 API as V4L2_CID_AUDIO_MUTE. 

> And, if it is made exported, what will still prevent us
> from dropping the auto-unmute stuff?

Some applications like mplayer don't use V4L2_CID_AUDIO_MUTE to unmute a video
device. They assume the current behavior that starting video also unmutes audio.
(mplayer is not symmetric with regard to the usage of this control, as it uses
V4L2_CID_AUDIO_MUTE to mute the device after the end of a capture).

So, changing the logic at the drivers will break existing applications.

It should be noticed that the alsa module is only enabled on devices that
provides PCM output via the PCI or USB bus. 

On the other hand, the V4L2_CID_AUDIO_MUTE control is available for all 
devices that are capable of muting/unmuting the audio. That's why V4L
applications rely on it, instead of using alsa mixers.

I dunno what's your specific saa7134 device model, but, from what I 
understood, instead of using the PCM output, you're using the LINE OUT pin. 

It is probably doable to split the mute control for the LINE OUT pin from the
mute control of the PCM capture. Such patch would make sense, as the alsa
capture doesn't need to touch at the line out pin, but the patch should
let V4L2_CID_AUDIO_MUTE control to affect both LINE OUT and PCM capture
mutes, otherwise applications will break.

>> Yet, as you may be aware of that, the V4L2 API offers a few audio
>> controls
>> (volume, mute, balance, bass, treble), that applies to the current 
>> stream, on the drivers that provide them. So, a video application may opt to
>> not control the alsa mixers directly, but, instead, use the V4L2 controls.
> In this case, I think, the alsa mixer control should just
> mirror the one of the v4l2 for the most cases. Maybe
> for some boards they can actually do the different things -
> doesn't matter right now though.

We need a solution that works for both simple and complex devices.

-

[1] IMHO, "LINE OUT" pin doesn't fit very well on playback/capture concept.
The capture volume/switch controls the A/D circuits for capture, while
the playblack controls the D/A circuits. However, the LINE OUT pin gets
audio from the captured data, and doesn't allow to direct any other PCM
data into the D/A. So, it is not a "complete" playback type of control.
So, it won't fit at the "Master Playback Switch" type.

Cheers,
Mauro
