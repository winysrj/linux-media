Return-path: <mchehab@gaivota>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39259 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab1EMI3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 04:29:44 -0400
Received: by qwk3 with SMTP id 3so1170984qwk.19
        for <linux-media@vger.kernel.org>; Fri, 13 May 2011 01:29:44 -0700 (PDT)
Message-ID: <4DCCEBF4.9060902@gmail.com>
Date: Fri, 13 May 2011 10:29:40 +0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: a baffian <mjnhbg1@gmail.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: Problems of Pinnacle PCTV Hybrid pro stick in linux
References: <BANLkTi=ag15jZyxV216gLLi-MSVfX8N14w@mail.gmail.com> <BANLkTikAJpUDjR6K1gzfULcaBq97JYKcpg@mail.gmail.com>
In-Reply-To: <BANLkTikAJpUDjR6K1gzfULcaBq97JYKcpg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 12-05-2011 11:12, a baffian escreveu:
> Hello all
> Is there anyone could find the source of problems described below?
> http://daftar.minidns.net/pctv/problem.html

Most of the comments and logs there provide not much help. As I told
you before, you're mixing clearly userspace issues or limitations with
kernel-related ones. For example, there's nothing we can do at driver
level to make kaffeine to perform better when decoding an MPEG-2 stream
at full screen mode. This is probably either a performance issue with
your GPU card or it is just that you're using a software decoder for it,
on a slow CPU. Some applications allow, with a few GPU types, to run the
MPEG-2 decoder inside the GPU.

Yet, there's one relevant information there:

3- And even with kaffeine, the only way that i could watch some TV, was in this manner: Before this DVB-stick i inserted another DVB-USB stick in another linux computer and scan the channels with kaffeine and after finding the channels, quit the kaffeine and copy its database files ( $HOME/.kde/share/apps/kaffeine/* ) into the testing computer for pinnacle DVB-USB hybrid stick. After that copying, i could run kaffeine on the pinnacle DVB and without scanning, thus i had a table of channels and in its main window and when i clicked on a channel, that channel was shown.

You mentioned that you did another dvb stick worked, but on another computer.
Why such dvb stick didn't work at the computer you tested your Pinnacle
device?

Also, does the working stick is capable of getting the dvb channels using the
scan tool provided at http://linuxtv.org/hg/dvb-apps? If so, please provide us
the dmesg produced with the working card and the scan results (with -v, in order
to put dvb scan into verbose mode), and the same info with the broken card.

Thanks,
Mauro

> 
> On Mon, May 9, 2011 at 3:08 PM, a baffian <mjnhbg1@gmail.com> wrote:
>> Hello all,
>>
>> Can anyone help to solve the problems of linux driver of "Pinnacle
>> PCTV Hybrid pro stick" ?
>> It is an em28xx based hybride (digital and analog TV) USB adapter.
>>
>> i wrote the complete story of my experiences with it, and its problems
>> in http://daftar.minidns.net/pctv/problem.html
>>
>> Good Luck
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

