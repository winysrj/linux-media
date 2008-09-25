Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mincho@interia.pl>) id 1KisX5-00038W-E6
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 17:13:33 +0200
Received: from poczta.interia.pl (mi02.poczta.interia.pl [10.217.12.2])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id 4BBEB4025F3
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 17:13:27 +0200 (CEST)
Received: from repro.in.papagayo.com.pl (host-05.papagayo.com.pl
	[213.134.141.76])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTP id A17362BC1D0
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 17:13:26 +0200 (CEST)
Message-ID: <48DBAA96.6070500@interia.pl>
Date: Thu, 25 Sep 2008 17:13:26 +0200
From: Wieslaw Kierbedz <mincho@interia.pl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] tda1004x+saa7162+ PCTV 7010ix
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi.
I found, that Twinhan 6090 and my Pinnacle PCTV 7010ix have same components.

First I added definitions to Manu's driver.
saa716x_hybrid loaded successfully, udev created devices.

Now the questions.
How to check does it works without frontend?
Is tda1004x just usable?
I compiled and loaded it but it ignored my card.
Then, how to force tda1004x to load firmware, check devices and create =

device file?

I know, both drivers saa716x and tda1004x are very experimental.
But simply wait is a little to hard for me.

P.S. Extremaly lame. Don't shoot please.
-- =

WK

----------------------------------------------------------------------
Znajd=BC mieszkanie w Twoim regionie!
kliknij >>> http://link.interia.pl/f1f19


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
