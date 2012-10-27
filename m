Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51144 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2J0L0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 07:26:54 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1504550bkc.19
        for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 04:26:52 -0700 (PDT)
Message-ID: <508BC4F9.303@googlemail.com>
Date: Sat, 27 Oct 2012 13:26:49 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Wojciech Myrda <vojcek@tlen.pl>, linux-media@vger.kernel.org
Subject: Re: [segfault] running ir-keytable with v4l-utils 0.8.9
References: <507B1879.9020100@tlen.pl>
In-Reply-To: <507B1879.9020100@tlen.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 10/14/12 9:54 PM, Wojciech Myrda wrote:
> However I experienced a segfault trying to run this command:
> ir-keytable --protocol=rc-6 --device /dev/input/by-id/usb-15c2_0038-event-if00

> Trace I got in gdb:
> Program terminated with signal 11, Segmentation fault.
> #0  0x00007fd1c6bdd410 in __strcpy_chk () from /lib64/libc.so.6
> (gdb) bt full
> #0  0x00007fd1c6bdd410 in __strcpy_chk () from /lib64/libc.so.6
> No symbol table info available.
> #1  0x00000000004037bc in strcpy (__src=<optimized out>,
> __dest=0x7fff0a823010 "")
>     at /usr/include/bits/string3.h:105
> No locals.
> #2  v1_set_hw_protocols (rc_dev=<optimized out>) at keytable.c:758
> #3  0x00000000004019af in set_proto (rc_dev=0x7fff0a824030) at keytable.c:1153

I looked at the crash and it seems that the rc_dev structure is not
initialized when a device name is set on the command line. Could you
please take a look?

Thanks,
Gregor
