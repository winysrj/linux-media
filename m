Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1IXMMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 08:12:50 -0400
Message-ID: <4E7DC93C.9080101@infradead.org>
Date: Sat, 24 Sep 2011 09:12:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Lennart Poettering <lpoetter@redhat.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org> <4E2C5A35.9030404@list.ru> <4E2C6638.2040707@infrade ad.org> <4E760BCA.6080900@list.ru> <4E7DB798.4060201@infradead.org> <4E7DBB1C.1090407@list.ru>
In-Reply-To: <4E7DBB1C.1090407@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-09-2011 08:12, Stas Sergeev escreveu:
> 24.09.2011 14:57, Mauro Carvalho Chehab wrote:
>> Please, one patch per email. Patchwork (or any kernel maintainer script)
>> won't catch more than one patch per email. See:
> Sorry about that.
> 
>> With respect to this patch:
>> http://patchwork.linuxtv.org/patch/7941/
>>
>> I don't see any sense on it. Video standard selection is done by software,
>> when a standards mask is passed via VIDIOC_S_STD ioctl. Drivers should not
>> mess it with modprobe hacks.
> Yes, but we already have "secam=" option, and
> also the first scan, that is being done on driver
> init, scans too much without that option, and
> sometimes, unfortunately, detects the PAL carrier
> for me.
> By limiting it to secam, I avoid the problem and
> shorten the scan time.
> But this patch is not very important, so do whatever
> you think necessary with it.

The scan audio logic only enables multiple audio standard detection if the userspace 
application tells it to do. The right fix here is to fix the application. The secam
hack is due to a problem related to Secam L and Secam L'.

> 
>> I'll comment later http://patchwork.linuxtv.org/patch/7940/. It seems to be
>> going into the right direction, but I need to take a deeper code inspection
>> and maybe do some tests here.
> Thanks!
> Of course, in my view, the _only_ right direction is
> to export the mute control to the alsa mixer and then
> fix mplayer. But at least I'm glad I've managed to
> find the hack that satisfies your opinion and works
> around the problem at the same time.

The right fix that pulseaudio should not touch at the audio mixers for the
video boards. Not all boards have an audio carrier detection like saa7134.

Regards,
Mauro.

