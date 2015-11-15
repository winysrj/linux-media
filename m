Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33885 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbbKOU7V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 15:59:21 -0500
Received: by ykfs79 with SMTP id s79so210956078ykf.1
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 12:59:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK2bqVL1kyz=gjqKjs_W6oge-_h8qjE=7OwPhaX=OH47U2+z+g@mail.gmail.com>
References: <CAK2bqVL1kyz=gjqKjs_W6oge-_h8qjE=7OwPhaX=OH47U2+z+g@mail.gmail.com>
Date: Sun, 15 Nov 2015 15:59:20 -0500
Message-ID: <CAGoCfiz9k3V0Z4ejVL4is4+t5WFMWo6EY7jjkiSEFrYj8zDqiA@mail.gmail.com>
Subject: Re: Trying to enable RC6 IR for PCTV T2 290e
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 15, 2015 at 3:49 PM, Chris Rankin <rankincj@googlemail.com> wrote:
> Hi,
>
> My Hauppauge RC5 remote control finally broke, and the PCTV T2 290e's
> native RC5 remote control isn't suitable for VDR, and so I bought a
> cheap RC6 remote as a replacement. The unit I chose was the Ortek
> VRC-1100 Vista MCE Remote Control, USB ID 05a4:9881. I've been able to
> switch the PCTV device into RC6 mode using "ir-keytable -p rc-6",
> which does seem to execute the correct case of
> em2874_ir_change_protocol(). However, when I press any buttons on my
> new remote, I still don't see em2874_polling_getkey() being called,
> which makes me wonder if the RC6 support is truly enabled.

It's been a few years since I looked at that code, and when I
orginally wrote it I don't think I bothered with the RC6 support.
That said, it's not interrupt driven and the em2874_polling_getkey()
should fire every 100ms regardless of whether the hardware receives an
IR event (the polling code queries a status register and if it sees a
new event it reads the RC code received and announces it to the input
subsystem).

I would probably look through the code and see why the polling routine
isn't setup to run.  There is probably logic in there that causes the
polling to never get enabled if a keymap isn't associated with the
board profile in em28xx-cards.c

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
