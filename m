Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36712 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbKOVZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 16:25:02 -0500
Received: by oiww189 with SMTP id w189so74520239oiw.3
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 13:25:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiz9k3V0Z4ejVL4is4+t5WFMWo6EY7jjkiSEFrYj8zDqiA@mail.gmail.com>
References: <CAK2bqVL1kyz=gjqKjs_W6oge-_h8qjE=7OwPhaX=OH47U2+z+g@mail.gmail.com>
	<CAGoCfiz9k3V0Z4ejVL4is4+t5WFMWo6EY7jjkiSEFrYj8zDqiA@mail.gmail.com>
Date: Sun, 15 Nov 2015 21:25:01 +0000
Message-ID: <CAK2bqVL76sbs4fXia2eU3gk+OLs_QsZMHo=HfctUtFM+4bOG8A@mail.gmail.com>
Subject: Re: Trying to enable RC6 IR for PCTV T2 290e
From: Chris Rankin <rankincj@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've dug a bit deeper and discovered that the reason the
em28xx_info(...) lines that I'd added to em2874_polling_getkey()
weren't appearing is because I'd loaded the wrong version of the
em28xx-rc module! (Doh!)

The polling function *is* being called regularly, but
em28xx_ir_handle_key() isn't noticing any keypresses. (However, it
does notice when I switch back to RC5).

Cheers,
Chris
