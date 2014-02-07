Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:45307 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaBGU7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 15:59:41 -0500
Received: by mail-yk0-f172.google.com with SMTP id 200so544584ykr.3
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 12:59:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F53F60.6090003@earthlink.net>
References: <52F524A8.9000008@earthlink.net>
	<CALzAhNWfUWYtQaRH-BcWhY6YE1pV3P=69R2NyXHUeAwZMrfrcg@mail.gmail.com>
	<52F53F60.6090003@earthlink.net>
Date: Fri, 7 Feb 2014 15:51:33 -0500
Message-ID: <CALzAhNVhPQrtwYgmuipVPBg-Ogi61cndu59BdcbAO3QtC5GLrw@mail.gmail.com>
Subject: Re: Driver for KWorld UB435Q Version 3 (ATSC) USB id: 1b80:e34c
From: Steven Toth <stoth@kernellabs.com>
To: The Bit Pit <thebitpit@earthlink.net>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Thanks steve,

You are very welcome.

>
> Found it.  Its the same files I found at a different place.  I don't
> understand the way to do things.
> Last time I simply edited the kernel tree and supplied patches to get my
> changes in.  The source for  tda18272 is not in the kernel tree I 'git'
> following the instructions at linuxtv.org.  It is in Manu's tree, but
> the directory structure is slightly different.

That's ok. Anything that gets submitted for upstream merge (by manu
for example) would be moved into the correct directories by the
developer. It's not unusual to see personal development trees with odd
file placements.

>
> I don't understand the current development process.  Are the
> instructions at linuxtv.org out of date?

No, last I checked they were correct.

>
> In which tree should I edit the following and supply patches against:
> usb/em28xx/em28xx-cards.c
> usb/em28xx/em28xx-dvb.c
> usb/em28xx/em28xx.h

http://git.linuxtv.org/media_tree.git

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
