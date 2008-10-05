Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-1.orange.nl ([193.252.22.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1KmQtL-0000ZV-Eo
	for linux-dvb@linuxtv.org; Sun, 05 Oct 2008 12:31:13 +0200
Message-ID: <48E89747.40406@verbraak.org>
Date: Sun, 05 Oct 2008 12:30:31 +0200
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>, linux-dvb@linuxtv.org
References: <48E7CDC1.9010905@powercraft.nl>
In-Reply-To: <48E7CDC1.9010905@powercraft.nl>
Subject: Re: [linux-dvb] Scrambled/encrypted dvb-t channels under linux with
 a	CI CAM?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Jelle de Jong schreef:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hello everybody,
>
> I am searching for some solutions to be able to watch
> scrambled/encrypted dvb-t channels on Linux systems.
>
> I don't know what my options are..., but I found this wiki page:
> http://www.linuxtv.org/wiki/index.php/DVB_Conditional_Access_Modules
>
> The situation is that I have separate usb enabled dvb-t devices that do
> all work for non scrambled channels.
>
> I would like to be able to add an usb device that makes it possible to
> also watch the scrambled channels, I don't know if this is possible.
> What is the exact function of a CAM? Does it decrypt date realtime or
> does it give out some special key that an other application can use?
>
> I do have a usb smartcard reader that I use for gnupg encryption
> systems. Are there possibility to use this device with an cable-provider
> smartcards?
>
> Any information is appreciated,
>
> Thank in advance,
>
> Jelle
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>
> iJwEAQECAAYFAkjnzb8ACgkQ1WclBW9j5HkjAQP/V/zowVaiJZkD4/YdVovfFkQa
> d5DXie2a36mNCQRT9d5Eh551cIUYspZsHx3iJf0MGbT4dqiAE1AGgOhfUXTpOp6w
> /QfnzVkprhkWCM+llTu78Pgp78vLtKx1PYFKn4gUjVq8GKOMImKpAsxAOOAh9PjL
> MYdIi6dyL8iqZ7Qq1jQ=
> =b5wU
> -----END PGP SIGNATURE-----
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Jelle,

do a search for "sasc-ng" in google. You should be able to use your usb 
smartcard reader.

Regards,

Michel.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
