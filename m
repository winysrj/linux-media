Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mincho@interia.pl>) id 1Kj7x7-0005ex-GN
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 09:41:26 +0200
Received: from poczta.interia.pl (mi04.poczta.interia.pl [10.217.12.4])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id 4FD4931BFD5
	for <linux-dvb@linuxtv.org>; Fri, 26 Sep 2008 09:41:21 +0200 (CEST)
Received: from repro.in.papagayo.com.pl (host-05.papagayo.com.pl
	[213.134.141.76])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTP id A1BB4142BDC
	for <linux-dvb@linuxtv.org>; Fri, 26 Sep 2008 09:41:18 +0200 (CEST)
Message-ID: <48DC921D.6010801@interia.pl>
Date: Fri, 26 Sep 2008 09:41:17 +0200
From: Wieslaw Kierbedz <mincho@interia.pl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48DBAA96.6070500@interia.pl>
In-Reply-To: <48DBAA96.6070500@interia.pl>
Subject: Re: [linux-dvb] tda1004x+saa7162+ PCTV 7010ix
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

Wieslaw Kierbedz wrote:

> Is tda1004x just usable?
> I compiled and loaded it but it ignored my card.
> Then, how to force tda1004x to load firmware, check devices and create =

> device file?
I suppose I found.
There is only demodulator definition for saa716x_averhc82_zl10353.
To enable others I have to write saa716x_7010ix_tda1004x_config (for
example) code?
Has that some sens to adjust functions from other drivers?
saa7134-dvb td1316?

-- =

WK

----------------------------------------------------------------------
Znajd=BC mieszkanie w Twoim regionie!
kliknij >>> http://link.interia.pl/f1f19


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
