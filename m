Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.mail.ru ([94.100.176.89]:58161 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab1GSPua (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 11:50:30 -0400
Message-ID: <4E25A7C2.3050609@list.ru>
Date: Tue, 19 Jul 2011 19:50:26 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org>
In-Reply-To: <4E25A26A.2000204@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

19.07.2011 19:27, Mauro Carvalho Chehab wrote:
>> Unless I am missing the point, you need some mixer control
>> that will just unmute the "currently-configured things".
>> If you can unmute all the right things when an app just
>> starts capturing, then you can as well unmute the same
>> things by that _single_ mixer control.
>> And if the app changes the output to SVideo, as in your
>> example, you can first mute everything, and then unmute
>> the new lines, but only if the old lines were unmuted.
>> IMHO, that logic will not break the existing apps.
> That is the current logic, except that we don't create an additional
> virtual mixer control like the one you've proposed via ALSA API.
Unless I am mistaken, this control is usually called a
"Master Playback Switch" in the alsa world.
So, am I right that the only problem is that it is not
exported to the user by some drivers right now?
And, if it is made exported, what will still prevent us
from dropping the auto-unmute stuff?

> Yet, as you may be aware of that, the V4L2 API offers a few audio
> controls
> (volume, mute, balance, bass, treble), that applies to the current 
> stream, on the drivers that provide them. So, a video application may opt to
> not control the alsa mixers directly, but, instead, use the V4L2 controls.
In this case, I think, the alsa mixer control should just
mirror the one of the v4l2 for the most cases. Maybe
for some boards they can actually do the different things -
doesn't matter right now though.
