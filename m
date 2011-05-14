Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38874 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab1ENLTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 07:19:48 -0400
Received: by ywj3 with SMTP id 3so1126487ywj.19
        for <linux-media@vger.kernel.org>; Sat, 14 May 2011 04:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DCCEBF4.9060902@gmail.com>
References: <BANLkTi=ag15jZyxV216gLLi-MSVfX8N14w@mail.gmail.com>
	<BANLkTikAJpUDjR6K1gzfULcaBq97JYKcpg@mail.gmail.com>
	<4DCCEBF4.9060902@gmail.com>
Date: Sat, 14 May 2011 15:49:45 +0430
Message-ID: <BANLkTind6OQBT2F9Gje9XVM31zBmTSpfZQ@mail.gmail.com>
Subject: Re: Problems of Pinnacle PCTV Hybrid pro stick in linux
From: a baffian <mjnhbg1@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: linux-media@vger.kernel.org, devin.heitmueller@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello Mauro and thanks for your sentences
But:

1- For such experienced programmer as you, it is obvious from
http://daftar.minidns.net/pctv/problem.html#problem2 , that when no
any software could scan the channels, thus at least one important
problem is in the kernel side, isn't it?
If the problems are only in the userspace, at least one of many good
softwares such as mentioned here:
http://daftar.minidns.net/pctv/problem.html#problem1 could find the
channels during scanning, aren't they?

2- you mentioned "most of the comments and logs there provide not much
help", i can provide any other help and comment and logs and tests of
new changes in driver sources that you want, as i did about 12 days
ago for "Devin Heitmueller" during a chat session in #linux-tv of
irc.freenode.net.

3- you mentioned some about my performance complaints, but if you read
this part of my writings:
http://daftar.minidns.net/pctv/problem.html#c1 you can find the power
of my testing hardware is reasonably very very higher than needed by
tv showing applications, and the Nvidia-G9500-GT graphic card is more
famous than we can relate the problems to its miss functioning, isn't
it?

4- i inserted the scan result of another DVB-stick that i had, here:
http://daftar.minidns.net/pctv/channels.conf for you , but i had not
that DVB-stick now for testing again. it had the afatech-9015 chip set
and could find my all 25 digital channel in any linux box by any here:
http://daftar.minidns.net/pctv/problem.html#problem1 mentioned
software. The only problem with that afatech based DVB was 2 : it
could not play the sounds of digital channels except one of digital-TV
channels i explained about it here:
http://daftar.minidns.net/pctv/problem.html#p-h and here:
http://daftar.minidns.net/pctv/problem.html#p-d and here:
http://daftar.minidns.net/pctv/problem.html#p-e and here:
http://daftar.minidns.net/pctv/problem.html#p-g , any second problem:
it was not the analog TV capable.

5- and again the above mentioned paragraph (4) prove that most of
problems is in the kernel space not userspace, because that afatech
based DVB-stick could find all 25 digital channels during scan and
play the by all of mentioned software, and only one of problems is the
same as Pinnacle's one: the problem of sounds of that 13 digital tv
channel.

At end i again tell that, i am in the #linux-tv chat room as dast53
for speaking to solving those problems.

Thanks all

On Fri, May 13, 2011 at 12:59 PM, Mauro Carvalho Chehab
<maurochehab@gmail.com> wrote:
> Em 12-05-2011 11:12, a baffian escreveu:
>> Hello all
>> Is there anyone could find the source of problems described below?
>> http://daftar.minidns.net/pctv/problem.html
>
> Most of the comments and logs there provide not much help. As I told
> you before, you're mixing clearly userspace issues or limitations with
> kernel-related ones. For example, there's nothing we can do at driver
> level to make kaffeine to perform better when decoding an MPEG-2 stream
> at full screen mode. This is probably either a performance issue with
> your GPU card or it is just that you're using a software decoder for it,
> on a slow CPU. Some applications allow, with a few GPU types, to run the
> MPEG-2 decoder inside the GPU.
>
> Yet, there's one relevant information there:
>
> 3- And even with kaffeine, the only way that i could watch some TV, was in this manner: Before this DVB-stick i inserted another DVB-USB stick in another linux computer and scan the channels with kaffeine and after finding the channels, quit the kaffeine and copy its database files ( $HOME/.kde/share/apps/kaffeine/* ) into the testing computer for pinnacle DVB-USB hybrid stick. After that copying, i could run kaffeine on the pinnacle DVB and without scanning, thus i had a table of channels and in its main window and when i clicked on a channel, that channel was shown.
>
> You mentioned that you did another dvb stick worked, but on another computer.
> Why such dvb stick didn't work at the computer you tested your Pinnacle
> device?
>
> Also, does the working stick is capable of getting the dvb channels using the
> scan tool provided at http://linuxtv.org/hg/dvb-apps? If so, please provide us
> the dmesg produced with the working card and the scan results (with -v, in order
> to put dvb scan into verbose mode), and the same info with the broken card.
>
> Thanks,
> Mauro
>
>>
>> On Mon, May 9, 2011 at 3:08 PM, a baffian <mjnhbg1@gmail.com> wrote:
>>> Hello all,
>>>
>>> Can anyone help to solve the problems of linux driver of "Pinnacle
>>> PCTV Hybrid pro stick" ?
>>> It is an em28xx based hybride (digital and analog TV) USB adapter.
>>>
>>> i wrote the complete story of my experiences with it, and its problems
>>> in http://daftar.minidns.net/pctv/problem.html
>>>
>>> Good Luck
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
