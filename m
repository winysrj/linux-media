Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp18.mail.ru ([94.100.176.155]:35513 "EHLO smtp18.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1GTKzF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 06:55:05 -0400
Message-ID: <4E26B405.7000308@list.ru>
Date: Wed, 20 Jul 2011 14:55:01 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org>
In-Reply-To: <4E26B29B.4010109@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

20.07.2011 14:48, Mauro Carvalho Chehab wrote:
>> Well, until you explain the exact breakage of my proposal,
>> I won't trust this. :)
> I've said already: mplayer for example relies on such behavior to work. Reverting
> it breaks mplayer. This is enough for me to NACK your patch.
What you said, was:
---
Some applications like mplayer don't use V4L2_CID_AUDIO_MUTE to unmute a
video
device. They assume the current behavior that starting video also
unmutes audio.
---
"starting video also unmutes audio" is what my patch
_does not touch_! And that certainly happens not even
in the alsa driver, but somewhere in the v4l2 code.

So, please please please, could you actually precisely
explain how exactly mplayer breaks with my patch?
That's the only thing I need! :))
