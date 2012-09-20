Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51178 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab2ITTiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 15:38:00 -0400
Message-ID: <505B7082.80805@iki.fi>
Date: Thu, 20 Sep 2012 22:37:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1348167437-4371-1-git-send-email-oliver+list@schinagl.nl> <505B6B4E.8010006@iki.fi> <505B6E74.9020605@schinagl.nl>
In-Reply-To: <505B6E74.9020605@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2012 10:28 PM, Oliver Schinagl wrote:
> On 20-09-12 21:15, Antti Palosaari wrote:
>> On 09/20/2012 09:57 PM, oliver@schinagl.nl wrote:
>>> From: Oliver Schinagl <oliver@schinagl.nl>
>>>
>>> This is initial support for the Asus MyCinema U3100Mini Plus. The driver
>>> in its current form gets detected and loads properly.
>>>
>>> Scanning using dvbscan works without problems, Locking onto a channel
>>> using tzap also works fine. Only playback using tzap -r + mplayer was
>>> tested and was fully functional.
>>>
>>> It uses the af9035 USB Bridge chip, with an af9033 demodulator. The
>>> tuner
>>> used is the FCI FC2580.
>>>
>>> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
>>
>> Acked-by: Antti Palosaari <crope@iki.fi>
>> Reviewed-by: Antti Palosaari <crope@iki.fi>
>>
>> It is OK. Mauro, please merge to the master.
> I do hope that it won't be a problem as I based it on your
> remotes/origin/for_v3.7-13
>>
>> @Oliver, you didn't fixed FC2580 useless braces as I requested.
>> Anyway, I will sent another patch to fix it later. Action not required.
> Ah, I did comment on that change in my reply on your comments; a
> re-paste from that:
>
> Checkpatch did not trigger on this. Which makes sense. Kernel
> CodingStyle is in very strong favor of K&R and from what I know from
> K&R, K&R strongly discourage not using braces as it is very likely to
> introduce bugs. Wikipedia has a small mention of this, then again
> wikipedia is wikipedia.

I am quite sure it says braces are not allowed for if () when it is 
single line.

> I will take it out of you really want it out, but with checkpatch not
> even complaining, I would think this as an improvement. :D

Seems like you are correct, it does not detect it from the patch for 
reason or the other. Maybe you could sent patch to fix checkpatch.pl :)

But it seems to find it when asked to check file correctness.

Anyway, my eyes seems to be again more careful than checkpatch ;-)

[crope@localhost linux]$ git show --format=email | ./scripts/checkpatch.pl -
total: 0 errors, 0 warnings, 141 lines checked

Your patch has no obvious style problems and is ready for submission.
[crope@localhost linux]$ ./scripts/checkpatch.pl --file 
drivers/media/tuners/fc2580.c
WARNING: braces {} are not necessary for single statement blocks
#501: FILE: media/tuners/fc2580.c:501:
+	if ((chip_id != 0x56) && (chip_id != 0x5a)) {
+		goto err;
+	}

total: 0 errors, 1 warnings, 525 lines checked

drivers/media/tuners/fc2580.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
[crope@localhost linux]$

Antti

-- 
http://palosaari.fi/
