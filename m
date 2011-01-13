Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab1AMNEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 08:04:52 -0500
Message-ID: <4D2EF86B.80508@redhat.com>
Date: Thu, 13 Jan 2011 11:04:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
	"'Sylwester Nawrocki'" <s.nawrocki@samsung.com>, pawel@osciak.com,
	linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com> <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com> <4D2E0DD8.4010305@redhat.com> <000001cbb2fe$5d8f2290$18ad67b0$%p@samsung.com> <000701cbb31b$3e692c40$bb3b84c0$%p@samsung.com>
In-Reply-To: <000701cbb31b$3e692c40$bb3b84c0$%p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-01-2011 10:13, Andrzej Pietrasiewicz escreveu:
> Hello again, Mauro,
> 
> On Thursday, January 13, 2011 9:46 AM Andrzej Pietrasiewicz  wrote:
> 
>>
>> Hello Mauro,
>>
>> On Wednesday, January 12, 2011 9:24 PM Mauro Carvalho Chehab wrote:
>>>
>>> Em 12-01-2011 08:25, Marek Szyprowski escreveu:
>>>> Hello Mauro,
>>>>
>>>> I've rebased our fimc and saa patches onto
>>> http://linuxtv.org/git/mchehab/experimental.git
>>>> vb2_test branch.
>>>>
>>>> The last 2 patches are for SAA7134 driver and are only to show that
>>> videobuf2-dma-sg works
>>>> correctly.
>>>
>>> On my first test with saa7134, it hanged. It seems that the code
>>> reached a dead lock.
>>>
>>> On my test environment, I'm using a remote machine, without monitor.
>>> My test is using
>>> qv4l2 via a remote X server. Using a remote X server is an
>> interesting
>>> test, as it will likely loose some frames, increasing the probability
>>> of races and dead locks.
>>>
>>
>> We did a similar test using a remote machine and qv4l2 with X
>> forwarding.
>> Both userptr and mmap worked. Read does not work because it is not
>> implemented, but there was no freeze anyway, just green screen in
>> qv4l2.
>> However, we set "Capture Image Formats" to "YUV - 4:2:2 packed, YUV",
>> "TV Standard" to "PAL". I enclose a (lengthy) log for reference - it is
>> a log of a short session when modules where loaded, qv4l2 started,
>> userptr mode run for a while and then mmap mode run for a while.
>>
>> We did it on a 32-bit system. We are going to repeat the test on a 64-
>> bit system, it just takes some time to set it up. Perhaps this is the
>> difference.
> 
> We did the test on a 64-bit system, both locally and with X forwarding to a
> remote machine. It works in both cases.
> Our TV card is "Avermedia AverTV Super 007" pure analog. Yours is a hybrid
> analog/ISDB card. Does your card work with videobuf 1? 

Yes, it works (well, sort of - there's a problem a the tuner driver that I didn't
fix yet, so, I'm receiving just static on it, but yet, it is a stream, and this
works fine with videobuf1).

> Perhaps you could do
> such a test: please use code from the commit f73e66a8e91e4ebb "v4l: saa7134:
> remove radio, vbi, mpeg, input, alsa, tvaudio, saa6752hs support" and see if
> you TV card works with videobuf (not videobuf2)?

Ok, I'll do that, or maybe I'll just replace by an analog-only board.

Cheers,
Mauro
