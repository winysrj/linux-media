Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37551 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1BLVd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 16:33:29 -0500
Received: by eye27 with SMTP id 27so1839408eye.19
        for <linux-media@vger.kernel.org>; Sat, 12 Feb 2011 13:33:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <713442.91420.qm@web30304.mail.mud.yahoo.com>
References: <713442.91420.qm@web30304.mail.mud.yahoo.com>
Date: Sat, 12 Feb 2011 16:33:27 -0500
Message-ID: <AANLkTinv7sWE+T1ORrr8MD6XRGQj8hG1sZw9UfjSGM-o@mail.gmail.com>
Subject: Re: PCTV USB2 PAL / adds loud hum to correct audio
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: AW <arne_woerner@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Feb 12, 2011 at 3:22 PM, AW <arne_woerner@yahoo.com> wrote:
> Hi!
>
> When I try to use my new USB TV tuner on Fedora 14 (log messages: in the end)
> with this:
> mplayer -tv
> driver=v4l2:input=0:width=768:height=576:device=/dev/video2:norm=5:chanlist=europe-west:freq=224.25 tv://
>
> I hear nothing, but I c good pictures...
>
>
> When I use this command simultaneously:
> arecord -D front:CARD=PAL,DEV=0 -f S16_LE -c 2 -r 8000 /aux/tmp/bla.wav
> I get correct audio with strong noise:
> http://www.wgboome.de./bla.wav
> (it is from input=1 for copyright reasons... so there is silence plus noise)

The "-r" argument should almost certainly be 48000, not 8000.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
