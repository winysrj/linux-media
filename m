Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from node02.cambriumhosting.nl ([217.19.16.163])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1KmDSk-000058-In
	for linux-dvb@linuxtv.org; Sat, 04 Oct 2008 22:10:51 +0200
Received: from localhost (localhost [127.0.0.1])
	by node02.cambriumhosting.nl (Postfix) with ESMTP id 4CACDB0000B3
	for <linux-dvb@linuxtv.org>; Sat,  4 Oct 2008 22:10:46 +0200 (CEST)
Received: from node02.cambriumhosting.nl ([127.0.0.1])
	by localhost (node02.cambriumhosting.nl [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id P7V49BEw-Nef for <linux-dvb@linuxtv.org>;
	Sat,  4 Oct 2008 22:10:43 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl
	[84.245.3.195])
	by node02.cambriumhosting.nl (Postfix) with ESMTP id CB8EFB0000B1
	for <linux-dvb@linuxtv.org>; Sat,  4 Oct 2008 22:10:43 +0200 (CEST)
Received: from [192.168.1.180] (unknown [192.168.1.180])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id 6C38423BC56F
	for <linux-dvb@linuxtv.org>; Sat,  4 Oct 2008 22:10:43 +0200 (CEST)
Message-ID: <48E7CDC1.9010905@powercraft.nl>
Date: Sat, 04 Oct 2008 22:10:41 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Scrambled/encrypted dvb-t channels under linux with a
	CI CAM?
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello everybody,

I am searching for some solutions to be able to watch
scrambled/encrypted dvb-t channels on Linux systems.

I don't know what my options are..., but I found this wiki page:
http://www.linuxtv.org/wiki/index.php/DVB_Conditional_Access_Modules

The situation is that I have separate usb enabled dvb-t devices that do
all work for non scrambled channels.

I would like to be able to add an usb device that makes it possible to
also watch the scrambled channels, I don't know if this is possible.
What is the exact function of a CAM? Does it decrypt date realtime or
does it give out some special key that an other application can use?

I do have a usb smartcard reader that I use for gnupg encryption
systems. Are there possibility to use this device with an cable-provider
smartcards?

Any information is appreciated,

Thank in advance,

Jelle


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iJwEAQECAAYFAkjnzb8ACgkQ1WclBW9j5HkjAQP/V/zowVaiJZkD4/YdVovfFkQa
d5DXie2a36mNCQRT9d5Eh551cIUYspZsHx3iJf0MGbT4dqiAE1AGgOhfUXTpOp6w
/QfnzVkprhkWCM+llTu78Pgp78vLtKx1PYFKn4gUjVq8GKOMImKpAsxAOOAh9PjL
MYdIi6dyL8iqZ7Qq1jQ=
=b5wU
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
