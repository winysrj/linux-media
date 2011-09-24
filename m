Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.mail.ru ([94.100.176.130]:33630 "EHLO smtp2.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1IXNVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 09:21:19 -0400
Message-ID: <4E7DD92A.8030300@list.ru>
Date: Sat, 24 Sep 2011 17:20:42 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Lennart Poettering <lpoetter@redhat.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org> <4E2C5A35.9030404@list.ru> <4E2C6638.2040707@infrade ad.org> <4E760BCA.6080900@list.ru> <4E7DB798.4060201@infradead.org> <4E7DBB1C.1090407@list.ru> <4E7DC93C.9080101@infradead.org> <4E7DCEC1.6010405@list.ru> <4E7DD1A5.5080204@infradead.org>
In-Reply-To: <4E7DD1A5.5080204@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

24.09.2011 16:48, Mauro Carvalho Chehab wrote:
> A first scan at driver's init can be removed, IMO.
OK, that's the great news.
Will write a new patch then.

 > There's nothing the driver can do if the hardware
 > missdetects a carrier. Dirty tricks to try solving it
 > are not good, as they'll do the wrong thing on some situations.
Well, if we assume the first scan can be removed,
then we also assume the previous "dirty trick" is
harmless, as it affects only the first scan. But I'll
better remove both the trick and the first scan then,
as the fewer the hacks, the better the code.

 > If someone is using the board on an environment
 > without udev and pulseaudio, this trick will break the first tuning.
I feel this somehow contradicts with your suggestion
to remove the first scan, so could you clarify?

 > Well, if you think that this would solve, then just write a patch
 > exporting the mute control via ALSA. I have no problems with that.
That would solve all the problems, but only if:
1. The mplayer is then moved to the use of that new
control to not depend on the autounmute hack.
I can write the patch for that too.
2. Make sure all the other apps are fixed the same way
(I hope there are none though)
3. The autounmute hack is then removed. (no
regressions if steps 1 and 2 are carefully done)

If you are fine with that plan, then I'll try to find
the time and do the things that way. Otherwise,
I'll remove the first scan, and that will do the trick
in a simpler, though less cleaner way.
