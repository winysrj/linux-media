Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:64876 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934848AbaLLPwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 10:52:34 -0500
Received: by mail-qg0-f54.google.com with SMTP id l89so5685928qgf.27
        for <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 07:52:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548B09A5.80506@xs4all.nl>
References: <548AC061.3050700@xs4all.nl>
	<20141212104942.0ea3c1d7@recife.lan>
	<548AE5B2.1070306@xs4all.nl>
	<20141212111424.0595125b@recife.lan>
	<548B092F.2090803@osg.samsung.com>
	<548B09A5.80506@xs4all.nl>
Date: Fri, 12 Dec 2014 10:52:33 -0500
Message-ID: <CAGoCfiw1pdJGGfG5Gs-3Jf2e48buzwEA1O3+j-E+2Pjj657eEQ@mail.gmail.com>
Subject: Re: [REVIEW] au0828-video.c
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> No, tvtime no longer hangs if no frames arrive, so there is no need for
> this timeout handling. I'd strip it out, which can be done in a separate
> patch.

Did you actually try it? Do you have some patches to tvtime which
aren't upstream?

I wrote the comment in question (and added the associated code).  The
issue is that tvtime does *everything* in a single thread (except the
recent ALSA audio work), that includes servicing the video/vbi devices
as well as the user interface.  That thread blocks on a DQBUF ioctl
until data arrives, and thus if frames are not being delivered it will
hang the entire tvtime user interface.

Now you can certainly argue that is a bad design decision, but it's
been that way for 15+ years, so we can't break it now.  Hence why I
generate dummy frames on a timeout if the decoder isn't delivering
video.  Unfortunately the au8522 doesn't have a free running mode
(i.e. blue screen if no video), which is why most of the other devices
work fine (decoders by Conexant, NXP, Trident, etc all have such
functionality).

Don't get me wrong - I *hate* that I had to put that timer crap in the
driver, but it was necessary to be compatible with one of the most
popular applications out there.

In short, that code cannot be removed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
