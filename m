Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as-10.de ([212.112.241.2] helo=mail.as-10.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1L3vpY-0003Ol-Hq
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 17:59:38 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id 1921C33A726
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 17:59:33 +0100 (CET)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cFbolaWiyeMF for <linux-dvb@linuxtv.org>;
	Sat, 22 Nov 2008 17:59:32 +0100 (CET)
Received: from halim.local (p54AE3EF9.dip.t-dialin.net [84.174.62.249])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id D98A233A6E2
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 17:59:32 +0100 (CET)
Date: Sat, 22 Nov 2008 17:59:02 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20081122165902.GA17484@halim.local>
References: <20081122145820.183450@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081122145820.183450@gmx.net>
Subject: Re: [linux-dvb] errormessages skystar2 rev 2.8b with latest	v4l-dvb
	branch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I am not using a skystar rev 2.8!!
My question was why these messages are shown with this card wich worked fine
in the past (without) any errormessages during module loading.
THanks for your response.
Halim


On Sa, Nov 22, 2008 at 03:58:20 +0100, sinter.mann@gmx.de wrote:
> Hello Halim,
> =

> Forget about the Mercurial tree........
> =

> 1. Get a vanilla kernel 2.6.27 plus patch 2.6.28-rc6 from =

> http://www.eu.kernel.org/
> =

> 2. Prepare a kernel linux-2.6.28-rc6.
> =

> 3. Download the appended patchset: http://www.htpc-
> forum.de/forum/index.php?showtopic=3D4944&st=3D0&#entry31527
> =

> 4. Unpack the patchset to /usr/src/linux.
> =

> 5. Move all files in /usr/src/linux/skystarxyz to /usr/src/linux.
> =

> 6. For a 32-bit architecture execute: ./sky28 32, for a 64-bit one ./sky2=
8 64.
> =

> 7. Then move on with "make xconfig", make your config, then continue with=
 "make =

> modules && make bzlilo, make modules_install.....
> =

> Enjoy!
> =

> Cheers
> =

> Uwe
> =

> -- =

> Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen=
: http://www.gmx.net/de/go/multimessenger
> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
Halim Sahin
E-Mail:				=

halim.sahin (at) t-online.de

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
