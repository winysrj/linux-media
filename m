Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n41.bullet.mail.ukl.yahoo.com ([87.248.110.174])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K3F7s-00072Q-KB
	for linux-dvb@linuxtv.org; Mon, 02 Jun 2008 20:51:25 +0200
Date: Mon, 02 Jun 2008 14:25:05 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <E8394AD4-FA39-47D8-BFE6-BD7431E56CAC@krastelcom.ru> (from
	vpr@krastelcom.ru on Mon Jun  2 08:03:04 2008)
Message-Id: <1212431105l.5776l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  Low signal on H transponder on TT S-1500
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

Le 02.06.2008 08:03:04, Vladimir Prudnikov a =E9crit=A0:
> To continue with the issue of problems with high SR on TT S-XXXX =

> cards
>  =

> I can confirm that problems exist with the S-1500 card on H  =

> transponder of Orion Express 45MS AM2 sat as well.
> =

> Couldn't find any registers to play with as on the S-1401 (buf[5])  =

> that could fix it.
> If someone can point me to, please do!
> =


Well I already gave my story but here it goes again:
I had a lot of problem to scan and szap to most transponders. But I =

solved these by adding 4MHz to the freq, and things are a bliss now. =

And I checked lyngsat it lists the transponders with different freq =

from the one you get by parsing the stream. And guess what those freq =

are almost the same as the original freq+4MHz. I am a bit lost.
But in any case there is a problem with the 3200 not being able to lock =

reliably on certain transponders, but to this day I dont know how to =

test on this. I already sent logs and such, but with no luck until now, =

I hope that this will be resolved shortly.
HTH
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
