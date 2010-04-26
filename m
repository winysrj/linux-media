Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:51254 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849Ab0DZP0r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 11:26:47 -0400
Message-ID: <4BD5B061.9010001@arcor.de>
Date: Mon, 26 Apr 2010 17:25:21 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tm6000: Properly set alternate when preparing to stream
References: <4BD5A212.10104@redhat.com>
In-Reply-To: <4BD5A212.10104@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 26.04.2010 16:24, schrieb Mauro Carvalho Chehab:
> Although the code is getting the better alternates, it is not really using
> it. Get the interface/alternate numbers and use it where needed.
>
> This patch implements also one small fix at the last_line set, as 
> proposed by Bee Hock Goh <behock@gmail.com>.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>   
Hi Mauro,

dvb doesn't build.

  CC [M]  /usr/src/src/tm6010/v4l-dvb/v4l/tm6000-dvb.o
/usr/src/src/tm6010/v4l-dvb/v4l/tm6000-dvb.c: In function
'tm6000_start_stream':
/usr/src/src/tm6010/v4l-dvb/v4l/tm6000-dvb.c:119:9: error: invalid type
argument of '->' (have 'struct tm6000_endpoint')
make[5]: *** [/usr/src/src/tm6010/v4l-dvb/v4l/tm6000-dvb.o] Fehler 1
make[4]: *** [_module_/usr/src/src/tm6010/v4l-dvb/v4l] Fehler 2
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.34-rc4-16-obj/x86_64/desktop'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/usr/src/src/tm6010/v4l-dvb/v4l'
make: *** [all] Fehler 2


-- 
Stefan Ringel <stefan.ringel@arcor.de>

