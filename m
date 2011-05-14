Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65133 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab1ENRqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 13:46:19 -0400
Received: by bwz15 with SMTP id 15so2824466bwz.19
        for <linux-media@vger.kernel.org>; Sat, 14 May 2011 10:46:17 -0700 (PDT)
Message-ID: <4DCEBFE6.5050400@gmail.com>
Date: Sat, 14 May 2011 19:46:14 +0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: a baffian <mjnhbg1@gmail.com>
CC: linux-media@vger.kernel.org, devin.heitmueller@gmail.com
Subject: Re: Problems of Pinnacle PCTV Hybrid pro stick in linux
References: <BANLkTi=ag15jZyxV216gLLi-MSVfX8N14w@mail.gmail.com> <BANLkTikAJpUDjR6K1gzfULcaBq97JYKcpg@mail.gmail.com> <4DCCEBF4.9060902@gmail.com> <BANLkTind6OQBT2F9Gje9XVM31zBmTSpfZQ@mail.gmail.com>
In-Reply-To: <BANLkTind6OQBT2F9Gje9XVM31zBmTSpfZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 14-05-2011 13:19, a baffian escreveu:
> Hello Mauro and thanks for your sentences
> But:
> 
> 1- For such experienced programmer as you, it is obvious from

First of all, if you need some help, please change your tone, as it
seems a little offensive. We all are volunteers, and, while we spend
some of our spare time to help people, we expect that the people
to be nice and answer with technical information that will allow us
to help,.

> http://daftar.minidns.net/pctv/problem.html#problem2 , that when no
> any software could scan the channels, thus at least one important
> problem is in the kernel side, isn't it?

You told you tested it with two cards, having different results.
Without the debug logs from both cards, there's no way to identify
what's happening.

> If the problems are only in the userspace, at least one of many good
> softwares such as mentioned here:
> http://daftar.minidns.net/pctv/problem.html#problem1 could find the
> channels during scanning, aren't they?

No. The scan procedure happens partially on userspace and partially on
kernelspace. It is userspace task to decode the MPEG-TS and seek for
for the Program Identifiers.

> 2- you mentioned "most of the comments and logs there provide not much
> help", i can provide any other help and comment and logs and tests of
> new changes in driver sources that you want, as i did about 12 days
> ago for "Devin Heitmueller" during a chat session in #linux-tv of
> irc.freenode.net.

Ok. Then please provide the logs for the both cards, showing what happens
during the scan. We need "scan -v" log and the kernel logs (the command to
get it is: dmesg). Please enable frontend, em28xx and af9015 debug logs,
for us to know what the kernel is doing.

> 3- you mentioned some about my performance complaints, but if you read
> this part of my writings:
> http://daftar.minidns.net/pctv/problem.html#c1 you can find the power
> of my testing hardware is reasonably very very higher than needed by
> tv showing applications, and the Nvidia-G9500-GT graphic card is more
> famous than we can relate the problems to its miss functioning, isn't
> it?

It doesn't matter what Nvidia card you're using. The more expensive
process is the MPEG decoding. If that happens on userspace, it is your
CPU that will be used. HD streams require too much CPU. With the right
software and the right video board driver, this task could be send to
the Graphics card (GPU), by using an API (like vdpau), but not all 
software supports, and it requires a GPU-accelerated codec for the
video standard (typically, mpeg2). I'm not sure if Kaffeine currently 
offers GPU-accelerated mpeg2 codec, and if the nouveau or the Nvidia 
proprietary driver is compatible with Kaffeine's GPU's codecs.

> 4- i inserted the scan result of another DVB-stick that i had, here:
> http://daftar.minidns.net/pctv/channels.conf for you , but i had not
> that DVB-stick now for testing again. it had the afatech-9015 chip set
> and could find my all 25 digital channel in any linux box by any here:
> http://daftar.minidns.net/pctv/problem.html#problem1 mentioned
> software.

It is interesting to see the logs for the af9015 device, and see
what is it doing different than the Pinnacle one.

> The only problem with that afatech based DVB was 2 : it
> could not play the sounds of digital channels except one of digital-TV
> channels i explained about it here:
> http://daftar.minidns.net/pctv/problem.html#p-h and here:
> http://daftar.minidns.net/pctv/problem.html#p-d and here:
> http://daftar.minidns.net/pctv/problem.html#p-e and here:
> http://daftar.minidns.net/pctv/problem.html#p-g ,

>From your descriptions, it seems that the program identifiers sent by
the TV stations are wrong, or the userspace application is getting it wrong.
Basically, each MPEG-TS stream has several PID's. each of them can have
an audio or a video stream (there are also other types, but those two are
the rellevant ones). The video and audio stream should be associated, otherwise,
you won't be able to hear audio.

There is another alternative: eventually, your country is using an audio
codec that it is currently unsupported (or it requires you to install one
additional libarary and re-compile your application).

> any second problem:
> it was not the analog TV capable.
> 
> 5- and again the above mentioned paragraph (4) prove that most of
> problems is in the kernel space not userspace, because that afatech
> based DVB-stick could find all 25 digital channels during scan and
> play the by all of mentioned software, and only one of problems is the
> same as Pinnacle's one: the problem of sounds of that 13 digital tv
> channel.

Probably, but hard to know without having both logs to compare.

> At end i again tell that, i am in the #linux-tv chat room as dast53
> for speaking to solving those problems.

I'm traveling abroad this entire week, and next week I'll be handling 
the pending work. Also, as the merge window will probably be opened next
week, I'll be busy submitting the patches we have upstream. So,
unfortunately, it is unlikely that I'll have time soon to help debugging
a driver via irc.

Thanks,
Mauro.
