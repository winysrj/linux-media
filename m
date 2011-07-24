Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.mail.ru ([94.100.176.89]:48066 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab1GXTF1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 15:05:27 -0400
Message-ID: <4E2C6BD2.3060905@list.ru>
Date: Sun, 24 Jul 2011 23:00:34 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Lennart Poettering <lpoetter@redhat.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org> <4E2C5A35.9030404@list.ru> <4E2C6638.2040707@infradead.org>
In-Reply-To: <4E2C6638.2040707@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

24.07.2011 22:36, Mauro Carvalho Chehab wrote:
> So, only people that has saa7134 with alsa stream that opted
> to wire the saa7134 device to the sound card, and with a strong
> interference at the default tunning frequency (400 MHz) would
> notice a problem.
No, the "strong interference" thing have nothing to
do with it, I think. My card detects signal sometimes,
not always. Otherwise it says this:
---
saa7134[0]/audio: audio carrier scan failed, using 5.500 MHz [default]
---
yet the moise is still there.
If you look into a tvaudio_thread() function, you'll
notice that it disables automute _unconditionally_!
saa7134_tvaudio_do_scan() also disables automute
unconditionally.
That's why I think there are bugs. Can we start
from fixing at least this, and see what happens then?

>> Since I have no idea why it finds some carrier, I can't
>> fix that in any way. Or, maybe, not to call the scan
>> on driver init? What will that break?
> Analog tuners need to be tuned at the device init on a high frequency
> according with their datasheets, otherwise the PLL may fail.
OK.
Maybe, not disabling the automute when the scan
was started at init, rather than when it was requested
by an app?

> You're the first one that reported it, and the code is there for _years_.
> So, this is not a commonly noticed problem at all.
I am only the first one who reported it _to that list_.
I think most other reports were against pulseaudio.
