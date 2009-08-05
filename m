Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <cwattengard@gmail.com>) id 1MYZmx-0007l0-VC
	for linux-dvb@linuxtv.org; Wed, 05 Aug 2009 08:15:52 +0200
Received: by ewy28 with SMTP id 28so79158ewy.17
	for <linux-dvb@linuxtv.org>; Tue, 04 Aug 2009 23:15:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0908050244070.29385@ybpnyubfg.ybpnyqbznva>
References: <42619c130908040607h13afb69exe74145cd4ec4fc1e@mail.gmail.com>
	<alpine.DEB.2.01.0908050244070.29385@ybpnyubfg.ybpnyqbznva>
Date: Wed, 5 Aug 2009 08:15:18 +0200
Message-ID: <42619c130908042315i11e84df1m462802482c4cbf79@mail.gmail.com>
From: =?ISO-8859-1?Q?Christian_Watteng=E5rd?= <cwattengard@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Recieving DVB-C with DVB-T units
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

2009/8/5 BOUWSMA Barry <freebeer.bouwsma@gmail.com>:
> On Tue, 4 Aug 2009, Christian Watteng=E5rd wrote:
>
>> But after doing some research on Wikipedia and such, I can't figure
>> out why a DVB-T unit can't be easily modified to recieve DVB-C?
>> They use the same frequencies, the DVB-T specs support QAM (atleast low =
QAM).
>> My specific cable network uses 64QAM which the specs apparently
>> supports... So where is the underlying problem?
>
> Basically -- and I could well be wrong, DVB-T uses COFDM carrier
> modulation, which DVB-C does not -- the DVB-T signal is composed
> of several thousand carriers, while the DVB-C signal is a single
> carrier modulated directly. =A0Thus, differently-able hardware is
> needed facing the antenna.

Ok. Too bad. Then why are DVB-T units, that needs more technology,
half the price of DVB-C units... Annoys me... :)

> Oh, shouldn't your gmail address be `cwattengaard' instead? =A0;-)
> I ask having conditioned myself to type `Aarhus' and `Aalen' and
> `Aargau', speaking them all the same, confusing the heck out of
> the swiss...

I made a desicion a long time ago that when using my last-name for
emails and such, I would just use a single 'a' instead of the
"correct" internationalization which is 'aa'. Makes it easier to give
people my email address when I dont have to say "wattengaaaaaaaard"
just to emphasize the double 'a'.

The '=E5' / 'aa' sound is pronounced like the first sound in the english
word "all".

-C-

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
