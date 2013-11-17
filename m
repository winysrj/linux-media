Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50786 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KQShF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 13:37:05 -0500
Received: by mail-qa0-f42.google.com with SMTP id ii20so1723729qab.8
        for <linux-media@vger.kernel.org>; Sun, 17 Nov 2013 10:37:03 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 17 Nov 2013 19:37:03 +0100
Message-ID: <CADR1r6i7GAHK=4Cb4W3dSxzRtTLJVAmOViPLiS_2O=iN-8Nwgw@mail.gmail.com>
Subject: ddbridge module fails to load
From: Martin Herrman <martin.herrman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Since about a year I'm a happy user of the experimental driver for my
cine c2 v6.

I have just tried to use the latest code. It compiles without issues
(kernel 3.11 with gentoo and ck patches), but doesn't load:

ddbridge: Unknown symbol dvb_usercopy (err 0)

I reviewed the updates:

http://linuxtv.org/hg/~endriss/media_build_experimental

and noticed that there have been updates to the drivers I use lately.
Which is good news!

Unfortunately, the updates cause the above issue. I tried this revision:

http://linuxtv.org/hg/~endriss/media_build_experimental/rev/8c5bb9101f84

and now ddbridge loads perfectly and I can watch tv again.

Just wanted to let you know, in case you need any of my help to fix
this, please feel free to ask.  Note however that I'm certainly not a
developer, nor a experienced packager.

Regards,

Martin
