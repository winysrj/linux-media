Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp9.mail.ru ([94.100.176.54]:48738 "EHLO smtp9.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab1GXRuQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 13:50:16 -0400
Message-ID: <4E2C5A35.9030404@list.ru>
Date: Sun, 24 Jul 2011 21:45:25 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org>
In-Reply-To: <4E2AE40F.7030108@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

23.07.2011 19:09, Mauro Carvalho Chehab wrote:
> >  In this case, it will not be autounmuted after tuning.
> Hard to tell about your solution without seeing a patch.
OK, it turns out the automute code is already there,
but it doesn't work. The driver for some reasons
starts the scan on initialization, finds the carrier:
---
saa7134[0]/audio: found PAL main sound carrier @ 6.000 MHz [3969/324]
---
and, because of that, disables the automute. If the
real mute is not enabled at that point, you get the
white noise right away.

Since I have no idea why it finds some carrier, I can't
fix that in any way. Or, maybe, not to call the scan
on driver init? What will that break?

Anyway, as long as the automute code is broken,
we should either start fixing it, or fix PA, or fix mplayer...
Dunno. I wonder how come so many bugs left unfixed
for so long, resulting in a white noise to people...
