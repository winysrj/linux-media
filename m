Return-path: <mchehab@gaivota>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56721 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0J3KkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Oct 2010 06:40:22 -0400
Received: by vws13 with SMTP id 13so1067915vws.19
        for <linux-media@vger.kernel.org>; Sat, 30 Oct 2010 03:40:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik8__Q9au8u3fxsRr3cNdpjXZqmra9ohKTpSR+k@mail.gmail.com>
References: <AANLkTik8__Q9au8u3fxsRr3cNdpjXZqmra9ohKTpSR+k@mail.gmail.com>
Date: Sat, 30 Oct 2010 13:40:20 +0300
Message-ID: <AANLkTimFimU5FiAmmTqsaJOhqUQAjSGkbPe1XJTtCGhe@mail.gmail.com>
Subject: Re: Webcam driver not working: drivers/media/video/gspca/ov519.c
 device 05a9:4519
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-media@vger.kernel.org
Cc: moinejf@free.fr, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 3:12 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Hi all, sorry for the noise, but in current mainline (2.6.36-git12)
> there are some updates in ov519.c
> I'm running this kernel now and my camera is still not working (tested
> in windows and it works).
>
> lsusb:
> Bus 008 Device 002: ID 05a9:4519 OmniVision Technologies, Inc. Webcam Classic

found this: http://www.rastageeks.org/ov51x-jpeg/index.php/Ov51xJpegHackedSource
and this: http://packages.ubuntu.com/maverick/ov51x-jpeg-source

but I get an error when I try to compile:
ov51x-jpeg-core.c:87: fatal error: linux/autoconf.h: No such file or directory
compilation terminated.

(please CC)
