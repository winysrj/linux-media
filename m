Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45059 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2ELKVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 06:21:52 -0400
Received: by vbbff1 with SMTP id ff1so3519279vbb.19
        for <linux-media@vger.kernel.org>; Sat, 12 May 2012 03:21:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120512000858.3d9e41a8@pirotess>
References: <1336716892-5446-1-git-send-email-ismael.luceno@gmail.com>
	<1336716892-5446-2-git-send-email-ismael.luceno@gmail.com>
	<CAGoCfiydH48uY86w3oHbRDoJddX5qS1Va7vo4-vXwAn9JeSaaQ@mail.gmail.com>
	<20120512000858.3d9e41a8@pirotess>
Date: Sat, 12 May 2012 06:21:51 -0400
Message-ID: <CAGoCfizjD0wMpd+p4zxATfe+NKJqTqRTE4UEAZTTNdq9yCkxXg@mail.gmail.com>
Subject: Re: [PATCH 2/2] au0828: Move under dvb
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ismael Luceno <ismael.luceno@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 11, 2012 at 11:08 PM, Ismael Luceno <ismael.luceno@gmail.com> wrote:
> On Fri, 11 May 2012 08:04:59 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> ...
>> What is the motivation for moving these files?
>
> Well, the device was on the wrong Kconfig section, and while thinking
> about changing that, I just thought to move it under DVB.
>
>> The au0828 is a hybrid bridge, and every other hybrid bridge is
>> under video?
>
> Sorry, the devices I got don't support analog, so I didn't thought
> about it that much...
>
> I guess it's arbitrary... isn't it? wouldn't it be better to have an
> hybrid section? (just thinking out loud)

Yeah, in this case it's largely historical (a product from before the
V4L and DVB subsystems were merged).  At this point I don't see any
real advantage to arbitrarily moving the stuff around.  And in fact in
some areas it's even more ambiguous because some drivers are hybrid
drivers but support both hybrid chips as well as analog-only (the
em28xx driver is one such example).

Anyway, Mauro is welcome to offer his opinion if it differs, but as
far as I'm concerned this patch shouldn't get applied.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
