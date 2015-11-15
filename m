Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:35050 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbKOVs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 16:48:58 -0500
Received: by ykba77 with SMTP id a77so210755677ykb.2
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 13:48:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK2bqVL76sbs4fXia2eU3gk+OLs_QsZMHo=HfctUtFM+4bOG8A@mail.gmail.com>
References: <CAK2bqVL1kyz=gjqKjs_W6oge-_h8qjE=7OwPhaX=OH47U2+z+g@mail.gmail.com>
	<CAGoCfiz9k3V0Z4ejVL4is4+t5WFMWo6EY7jjkiSEFrYj8zDqiA@mail.gmail.com>
	<CAK2bqVL76sbs4fXia2eU3gk+OLs_QsZMHo=HfctUtFM+4bOG8A@mail.gmail.com>
Date: Sun, 15 Nov 2015 16:48:57 -0500
Message-ID: <CAGoCfiwg14U=mmpcQ-E9zOHyS4bguJzfvRf-QgZOEuJn1x8cwg@mail.gmail.com>
Subject: Re: Trying to enable RC6 IR for PCTV T2 290e
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I've dug a bit deeper and discovered that the reason the
> em28xx_info(...) lines that I'd added to em2874_polling_getkey()
> weren't appearing is because I'd loaded the wrong version of the
> em28xx-rc module! (Doh!)

Ok, good.

> The polling function *is* being called regularly, but
> em28xx_ir_handle_key() isn't noticing any keypresses. (However, it
> does notice when I switch back to RC5).

How are you "switching back to RC5"?  Are you actually loading in an
RC6 versus RC5 keymap?  The reason I ask is because the onboard
receiver has to be explicitly configured into one of the two modes,
and IIRC this happens based on code type for the loaded keymap.  Hence
if you have an RC5 keymap loaded, you'll never see the IR receiver
reporting RC6 codes.

And of course it's always possible you've hit a bug/regression.  I
haven't touched that code in years and I know it's been through a
couple of rounds of refactoring.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
