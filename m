Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:36738 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZFUAwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 20:52:35 -0400
Received: by an-out-0708.google.com with SMTP id d40so4588640and.1
        for <linux-media@vger.kernel.org>; Sat, 20 Jun 2009 17:52:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906191841.58210.hverkuil@xs4all.nl>
References: <829197380906190752v981e81sb94c8c294b68dbd2@mail.gmail.com>
	 <200906191804.55564.hverkuil@xs4all.nl>
	 <829197380906190911r7a1298ddtf442d938867abc08@mail.gmail.com>
	 <200906191841.58210.hverkuil@xs4all.nl>
Date: Sat, 20 Jun 2009 20:52:36 -0400
Message-ID: <829197380906201752s2ec219e2y8a0f44bf0f0e3f3d@mail.gmail.com>
Subject: Re: v4l-dvb compile broken with stock Ubuntu Karmic build
	(firedtv-ieee1394.c errors)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2009 at 12:41 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> On Friday 19 June 2009 18:11:11 Devin Heitmueller wrote:
>> On Fri, Jun 19, 2009 at 12:04 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
>> > Hmm, I discovered that firedtv-1394.c isn't compiled in the daily build
>> > even though ieee1394 is enabled in the kernel. I can manually enable
>> > it, though: make menuconfig, disable and enable the firedtv driver, and
>> > then it magically works. But even then it still compiles fine against
>> > the vanilla 2.6.30 kernel.
>>
>> Well, I'm obviously kicking myself for not having captured the output
>> last night when I was at home.
>>
>> So, you're saying that firedvt-1394.c is being compiled?
>>
>> Let me rephrase the question:  Take a look at firedtv-1394.c, line 22,
>> and tell me where the file "csr1212.h" can be found either in your
>> kernel source tree or your v4l-dvb tree.
>>
>> Devin
>
> It's here:
>
> /usr/src/linux/drivers/ieee1394/csr1212.h
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>

Ok, I see what is going on:  the header files in question are
available if you have the full Linux source installed, but they are
not part of the "kernel-headers" package, at least on Ubuntu.
Combined with the fact that the file now gets built with 2.6.30 causes
the compile failures:

  CC [M]  /home/devin/800e_test/v4l/firedtv-1394.o
/home/devin/800e_test/v4l/firedtv-1394.c:21:17: error: dma.h: No such
file or directory
/home/devin/800e_test/v4l/firedtv-1394.c:22:21: error: csr1212.h: No
such file or directory
/home/devin/800e_test/v4l/firedtv-1394.c:23:23: error: highlevel.h: No
such file or directory
/home/devin/800e_test/v4l/firedtv-1394.c:24:19: error: hosts.h: No
such file or directory
/home/devin/800e_test/v4l/firedtv-1394.c:25:22: error: ieee1394.h: No
such file or directory
/home/devin/800e_test/v4l/firedtv-1394.c:26:17: error: iso.h: No such
file or directory
/home/devin/800e_test/v4l/firedtv-1394.c:27:21: error: nodemgr.h: No
such file or directory

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
