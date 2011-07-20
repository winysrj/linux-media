Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.mail.ru ([94.100.176.89]:40399 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1GTKqD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 06:46:03 -0400
Message-ID: <4E26B1E7.2080107@list.ru>
Date: Wed, 20 Jul 2011 14:45:59 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Lennart Poettering <lpoetter@redhat.com>,
	linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org>
In-Reply-To: <4E26AEC0.5000405@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

20.07.2011 14:32, Mauro Carvalho Chehab wrote:
> I won't keep discussing something that won't be merged, as it will
> cause regressions.
Please explain what regressions it will make!
I am asking that question over and over again, and
every time you either ignore it, or refer to an apps
that use v4l2 ioctls, which are unaffected.
I wonder why you don't want to explain what regressions
do you have in mind...

> If the application is starting streaming, audio should be expected on
> devices
> where the audio output is internally wired with the capture input.
> This seems to be the case of your device. There's nothing that can be
> done to fix a bad hardware design or the lack of enough information
> from the device manufacturer.
Well, until you explain the exact breakage of my proposal,
I won't trust this. :)

> I suspect, however, that not changing the GPIO's is a very bad idea, and
> it will actually break audio for devices with external GPIO-based input
> switches, but, as this version was already done, it might be useful for some
> tests. A version 3 will follow shortly.
I'll test at a week-end whatever we'll have to that date.
