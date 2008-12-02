Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1L7eLW-0007Ak-If
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 00:08:00 +0100
Message-ID: <003a01c954d2$2305ae50$217da8c0@tdrpc>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
References: <938eabef0811270552t16fb1f7drc95988373f8c61fc@mail.gmail.com><938eabef0811270559pb48bdf6lc2d22818c71a559c@mail.gmail.com><19a3b7a80812020750o17c2b00ibd9d5663353564d8@mail.gmail.com><alpine.DEB.2.00.0812022158510.9198@ybpnyubfg.ybpnyqbznva>
	<alpine.DEB.2.00.0812022241370.9198@ybpnyubfg.ybpnyqbznva>
Date: Wed, 3 Dec 2008 00:03:06 +0100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New scan file for cz-Praha
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

Here is the actual map: http://www.digizone.cz/texty/mapy-pokryti/

So for Prague:

mux 1 Ceska televize
http://www.digizone.cz/texty/multiplex-1-mapy-pokryti-ceska-televize/
channel 53, 8 MHz, 8k, guard 1/4, fec 2/3, qam 64, hier none

mux 2 Ceske radiokomunikace http://www.digizone.cz/texty/pokryti-sit-a/
channel 41, 8 MHz, 8k, guard 1/4, fec 2/3, qam 64, hier none

mux 3 Czech Digital Group http://www.digizone.cz/texty/pokryti-sit-b/
channel 46, ??? (probably the same, it's the same in Brno, where I live
nearby)

mux 4 Telefonica O2 http://www.digizone.cz/texty/pokryti-sit-c/
channel 64, 8 MHz, 8k, guard 1/8, fec 2/3, qam 64, hier none
(only here the guard interval is different as in Brno)

According to the
http://www.digizone.cz/texty/multiplex-1-mapy-pokryti-ceska-televize/  the
channel 570 Mhz (channel 33) is just a weak copy of mux 1 from Usti n.L.

I hope I will calculate correctly, please check.
mux 1: channel 53 -> 730 MHz
mux 2: channel 41 -> 634 MHz
mux 3: channel 46 -> 674 MHz
mux 4: channel 64 -> 818 MHz

You can use the cz-Brno file I posted here a month ago which should be now
commited in the tree. Just replace the frequencies in that file.

Regards,
Tomas


----- Original Message ----- =

From: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
To: "Martin Jaburek" <longmatys@gmail.com>
Cc: <linux-dvb@linuxtv.org>
Sent: Tuesday, December 02, 2008 11:14 PM
Subject: Re: [linux-dvb] New scan file for cz-Praha


Oooh, replying to myself.  What an egoist.  UNFIT TO DRIVE
ON THEE INTERNET.  Shameful.  May as well write a novel
of nothing but talking to himself.  GET A ROOM!

On Tue, 2 Dec 2008, BOUWSMA Barry slobbered and dribbled:

> Or, a quick search (with no background) shows this frequency
> is in use at Usti n.Labem (north-ish; would have to search my
> maps to quote actual antenna distance and view terrain and

Relying on g00gle cache with results for `dvb-t praha', it
seems that ``dxradio.cz - p=F8ehled DVB-T vys=EDla=E8=F9 v =C8esku''
lists frequencies in use at present, and ``Digit=E1ln=EDTelevize.cz >
Pozemn=ED digit=E1ln=ED vys=EDl=E1n=ED v =C8esk=E9 republice'' lists planned
frequencies -- possibly modulation parameters are linked from
the latter, I haven't yet checked, but Real Soon Now I should
map out a cz-all file comparable to my Baden-Wuerttemberg file
to get a better overview...



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
