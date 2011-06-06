Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59469 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1FFSdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 14:33:05 -0400
Received: by eyx24 with SMTP id 24so1458031eyx.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 11:33:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22534.4159.11253-14366-1925523856-1307384009@seznam.cz>
References: <22534.4159.11253-14366-1925523856-1307384009@seznam.cz>
Date: Mon, 6 Jun 2011 14:33:02 -0400
Message-ID: <BANLkTi=qznm0gKPxsTSET-Se0iOtLkHRpA@mail.gmail.com>
Subject: Re: Last key repeated after every keypress on remote control (saa7134
 lirc devinput driver)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Radim <radim100@seznam.cz>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 6, 2011 at 2:13 PM, Radim <radim100@seznam.cz> wrote:
> Hello to everybody,
> I was redirected here from lirc mailinglist (reason is at the end).
>
> I'm asking for any help because I wasn't able to solve
> this problem by my self (and google of course).
>
> When I'm testing lirc configuration using irw, last pressed key is repeated
> just befor the new one:
>
> after pressing key 1:
> 0000000080010002 00 KEY_1 devinput
>
> after pressing key 2:
> 0000000080010002 00 KEY_1 devinput
> 0000000080010003 00 KEY_2 devinput
>
> after pressing key 3:
> 0000000080010003 00 KEY_2 devinput
> 0000000080010004 00 KEY_3 devinput
>
> after pressing key 4:
> 0000000080010004 00 KEY_3 devinput
> 0000000080010005 00 KEY_4 devinput
>
> after pressing key 5:
> 0000000080010005 00 KEY_4 devinput
> 0000000080010006 00 KEY_5 devinput
>
>
> My configuration:
> Archlinux (allways up-to-date)
> Asus MyCinema P7131 with remote control PC-39
> lircd 0.9.0, driver devinput, default config file lirc.conf.devinput
> kernel 2.6.38
>
> # ir-keytable
> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
>       Driver saa7134, table rc-asus-pc39
>       Supported protocols: NEC RC-5 RC-6 JVC SONY LIRC
>       Enabled protocols: RC-5
>       Repeat delay = 500 ms, repeat period = 33 ms
>
> Answare from lirc-mainlinglist (Jarod Wilson):
> Looks like a bug in saa7134-input.c, which doesn't originate in lirc land,
> its from the kernel itself. The more apropos location to tackle this issue
> is linux-media@vger.kernel.org.
>
> I can provide any other listings, just ask for them.
>
> Thank you for any help,
> Radim

I actually sent Jarod a board specifically to investigate this issue
(the same issue occurs on the saa7134 based HVR-1150).  I believe it's
on his TODO list.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
