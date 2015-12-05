Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37276 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbLEGTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 01:19:20 -0500
Received: by wmww144 with SMTP id w144so90065995wmw.0
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2015 22:19:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHwmhgHsPZTLgChqO05NYv7h-rD_Sex2d+jqsK=PpYJxcHi78g@mail.gmail.com>
References: <CAHwmhgFyjLOT6Na6oLXQT+FiUjyjrPX_CmKvQVDP-k9kawnMHw@mail.gmail.com>
	<CALF0-+UtHzo6-vYvUWtvS0hU7jyuPU+Ku4JC85T4gn4AHLgS0w@mail.gmail.com>
	<CAHwmhgGhdH8_+_5abeJZg=sL2nrr3psqzwHz3xrL_u1aV6mNCg@mail.gmail.com>
	<CAAEAJfDzpafBTqcTqjvEJWVxOQu7j=zK6m47VhnSVgM4kWhG5Q@mail.gmail.com>
	<CAHwmhgHsPZTLgChqO05NYv7h-rD_Sex2d+jqsK=PpYJxcHi78g@mail.gmail.com>
Date: Sat, 5 Dec 2015 03:19:19 -0300
Message-ID: <CAAEAJfCBBNC_Oj-pzVQWQV-hMFY99s+C6WdY+F+fDjjRBLk+qA@mail.gmail.com>
Subject: Re: Sabrent (stk1160) / Easycap driver problem
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Philippe Desrochers <desrochers.philippe@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 December 2015 at 01:29, Philippe Desrochers
<desrochers.philippe@gmail.com> wrote:
> The difference seems to be around the "saa7113" chip. Maybe the Sabrent is
> using another video decoder chip ?

Yes, I believe that would explain the kernel log you sent.

> I will open one and check the chips on the PCB.
>

OK, that would help.

> Do you know if the stk1160 driver was working with this device (Sabrent
> USB-AVCPT) in the past ?
>

I've only seen generic "Easycap" labeled stk1160 devices
with either sa7115 or gm7113 decoder. Both of these are supported.c

See drivers/media/i2c/saa7115.c:saa711x_detect_chip for details on how
the decoder chip
is identified.

> Also, it seems the Sabrent USB-AVCPT is using the AC'97 Audio chip.
> Could it be the problem ?
>

Shouldn't affect.

> Do you know if there a firmware in the Syntek 1160 chip ?
>

There is not.
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
