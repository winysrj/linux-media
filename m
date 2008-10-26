Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KtxYu-0004Yh-C5
	for linux-dvb@linuxtv.org; Sun, 26 Oct 2008 05:49:14 +0100
Received: by ey-out-2122.google.com with SMTP id 25so689614eya.17
	for <linux-dvb@linuxtv.org>; Sat, 25 Oct 2008 21:49:08 -0700 (PDT)
Date: Sun, 26 Oct 2008 05:49:00 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: =?ISO-8859-15?Q?Julian_G=FCrtler?= <julian.guertler@uni-ulm.de>
In-Reply-To: <4903070D.7050402@uni-ulm.de>
Message-ID: <alpine.DEB.2.00.0810252132190.20415@ybpnyubfg.ybpnyqbznva>
References: <4903070D.7050402@uni-ulm.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Update de-Illerkirchberg
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, 25 Oct 2008, Julian G=FCrtler wrote:

> now I've found out, that the broadcast station is in Ulm.

Ulm and Neu-Ulm are in Baden-Wuertt./Bayern -- and in general,
each Bundesland uses three frequencies for ARD+co., ZDFmobil,
and each Dritte Programme mux from each sender.

In addition to the local Ulm-Ermingen multiplexes, you are
apparently receiving some nearby Bayern from a favourable
high altitude.


B*gger, your list has disappeared from my reply, so I need to
postpone this message and correlate your frequencies with the
known-to-me broadcasts...

But in addition, the use of `AUTO' for practically everything
is not a good idea, and you should at least parse the NIT info
to get correct and up-to-date details -- although these are
readily found online and rather standard between senders.


Cut'n'pasta:

T 482000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
ZDF multiplex Ulm, (Donaueschingen, Raichberg, Ravensburg) K22
In my notes for Donaueschingen I wrote 50kW hor, 16QAM 2/3 8k 1/4

T 530000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
ZDF multiplex Gruenten, (Hohenpeissenberg) (Bayern) K28

T 594000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
ARD Multiplex Augsburg (Bayern) K36

T 626000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
SWR Multiplex Ulm, (Raichberg, Ravensburg) K40

T 650000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
ARD Multiplex Ulm, (Raichberg, Ravensburg) K43

T 658000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
ZDF Multiplex Augsburg (Bayern) K44

T 666000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
ARD Multiplex Gruenten (Bayern) K45

T 674000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
Bayerischer Rundfunk Sender Gruenten K46

T 690000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
K48, not sure.  What channels are you seeing here?


Apparently the Augsburg mux is not received on K25 (BR)


I have no idea if you are using a short simple antenna for
reception, or if you are connected to a high-gain rooftop
aerial which may have been installed during analogue times
and aimed towards sender Gruenten for BR.


barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
