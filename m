Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L0Dpl-0008Sz-P5
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 12:24:31 +0100
Received: by ey-out-2122.google.com with SMTP id 25so142961eya.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 03:24:26 -0800 (PST)
Date: Wed, 12 Nov 2008 12:24:09 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Alex Betis <alex.betis@gmail.com>
In-Reply-To: <c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0811121212280.22461@ybpnyubfg.ybpnyqbznva>
References: <20081112023112.94740@gmx.net>
	<c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
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

Howdy, this is probably a stupid question, as I neither
have DVB-S2 hardware nor have attempted to use anything
but a rather hacked scan from dvb-apps, but...

On Wed, 12 Nov 2008, Alex Betis wrote:

> DVB-S2 by specifying S1 or S2 in freq file, also if you implicitly specify
> QPSK in frequency file the utility will not scan DVB-S2, same logic also for
> 8PSK that will scan only DVB-S2 and will not try to scan DVB-S.
(implicitly -> explicitly?)

I can see the logic for 8PSK=>DVB-S2, but as far as I
can see, QPSK does not imply purely DVB-S...
NIT result:  12324000 V 29500000   pos  28.2E    FEC 3/4  DVB-S2 QPSK
one of eight such transponders, based on parsing the NIT
tables.  Also, a note from my inital 19E2 scan file to
remind me why it failed:
S 11914500      h       27500   ##      DVB-S2 QPSK (0x05)
May be no longer up-to-date.

Of course, if I'm misunderstanding, or failing to grasp
something obvious if I actually laid my hands on the
code, please feel free to slap me hard and tell me to
shove off.

thanks
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
