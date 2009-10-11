Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37504 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZJKTTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 15:19:14 -0400
Received: by bwz6 with SMTP id 6so2709256bwz.37
        for <linux-media@vger.kernel.org>; Sun, 11 Oct 2009 12:18:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20091011T180513-771@post.gmane.org>
References: <loom.20091011T180513-771@post.gmane.org>
Date: Sun, 11 Oct 2009 15:18:00 -0400
Message-ID: <829197380910111218q5739eb5ex9a87f19899a13e98@mail.gmail.com>
Subject: Re: Dazzle TV Hybrid USB and em28xx
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Giuseppe Borzi <gborzi@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Giuseppe,

On Sun, Oct 11, 2009 at 12:38 PM, Giuseppe Borzi <gborzi@gmail.com> wrote:
> Hello to everyone,
> I bought a Dazzle TV Hybrid USB stick some years ago (2006 maybe?) and until
> now I've used out of kernel drivers from M. Rechberger. Here's a webpage about
> the stick
>
> http://www.lelong.com.my/Auc/List/2009-10DeStd44780009_AUCTION_-#
> Dazzle-TV-Hybrid-USB-stick-Watch-TV-without-Internet-BID-Now.htm
> (this line has been breaked at the sharp # sign)
>
> The usbid is eb1a:2881.
> The Linux distribution I'm using, Archlinux, has updated the kernel to 2.6.31.3
> and I've failed to patch the out of kernel drivers again, so I've tried the in
> kernel em28xx modules.

Make sure you have the latest v4l-dvb code installed.  The changes for
that board went in relatively recently (make sure you do *not* specify
a card= modprobe parameter).

http://linuxtv.org/repo

> But analog TV has no audio (I've tried sox/arecord-aplay),

Make sure you have the correct standard selected.  This sort of thing
often occurs when you are in an area with PAL support but you have the
device configured for NTSC.

> teletext doesn't work (mtt segfaults) and DVB doesn't work too.

Teletext is not supported currently - I did the NTSC VBI support and
am planning on doing the PAL support in the next couple of weeks.

> With me-tv I
> get an error message like "Failed to tune to channel" and sometimes a
> "timeout".

A fix for this was done this week (but hasn't been checked in yet).
Check the linux-media archive for the PCTV 320e thread.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
