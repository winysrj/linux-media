Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.mail.ru ([94.100.176.89]:57986 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab1GYLUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 07:20:24 -0400
Message-ID: <4E2D5051.8080208@list.ru>
Date: Mon, 25 Jul 2011 15:15:29 +0400
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
> The automute code works fine. Maybe you have a strong interference
> at the default tuning frequency, leading into saa7134 miss-detection.
OK, so my accusation to the automute code is
that it gets disabled unconditionally, no matter
have the scan failed or succeeded. Also, since
that scan is done on driver init, the automute
state stands no chance to survive: it is getting
disabled unconditionally, on the driver init.
Do we agree that this is a bug?
Do we agree that fixing it will also fix the PA problem,
or, at the very least, will advance us a lot in getting
it fixed?
If so, can you take a look into fixing that code?
It seems the automute code is rather fragile right
now, I'd better not touch it if you have some time
to take a look.
