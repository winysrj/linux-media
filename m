Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54042 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3G1OFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jul 2013 10:05:07 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so3415975wgg.4
        for <linux-media@vger.kernel.org>; Sun, 28 Jul 2013 07:05:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375019889.33203.YahooMailNeo@web120306.mail.ne1.yahoo.com>
References: <1375017565.30131.YahooMailNeo@web120305.mail.ne1.yahoo.com>
	<CAGoCfizG1MgsNPfka-zjcO71z3LS0tKbka3iL4EY6PqsUBatiA@mail.gmail.com>
	<1375019889.33203.YahooMailNeo@web120306.mail.ne1.yahoo.com>
Date: Sun, 28 Jul 2013 10:05:05 -0400
Message-ID: <CAGoCfiy0dq2yF3WjT1AdYghOZnWcBO=9mWrTqyjKAcBY=17t1A@mail.gmail.com>
Subject: Re: Very verbose message about em28174 chip.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 28, 2013 at 9:58 AM, Chris Rankin <rankincj@yahoo.com> wrote:
> ----- Original Message -----
>
> From: Devin Heitmueller <dheitmueller@kernellabs.com>
>
>>The amount of output is not inconsistent with most other linuxtv drivers though.
>
> It's the EEPROM dump that really caught my eye: 16+ lines of pure "WTF?".

Yeah, nowadays the eeprom output is one of the less useful pieces of
output (in fact, I intentionally didn't do support for dumping it out
on the em2874, but somebody did it anyway).  That said, I certainly
wouldn't nack any patch submitted which changed the debug level for
the eeprom output so it's not visible by default.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
