Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n44.bullet.mail.ukl.yahoo.com ([87.248.110.177])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KmTQd-0006fG-Ct
	for linux-dvb@linuxtv.org; Sun, 05 Oct 2008 15:13:44 +0200
Date: Sun, 05 Oct 2008 09:13:03 -0400
From: Emmanuel ALLAUD <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
In-Reply-To: <c74595dc0810012238p6eb5ea9fg30d8cc296a803a32@mail.gmail.com>
	(from alex.betis@gmail.com on Thu Oct  2 01:38:03 2008)
Message-Id: <1223212383l.6064l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : Twinhan 1041 (SP 400) lock and scan problems
 - the solution [not quite :(]
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

Le 02.10.2008 01:38:03, Alex Betis a =E9crit=A0:
> Manu,
> =

> Please specify what sattelite and what frequency cause problems.
> Specify also a "good" transponder that locks.
> Can you send me the stb0899 module logs (with debug severity)?

I loaded stb* with debug=3D5 IIRC.
The sats are in western Atlantic (I live in the Caribbean Islands): =

good transponders: freqs=3D11093,11555,11675, bad one:11495.

As I said Carrier is detected but the data search algo fails, and, as =

the only difference is th FEC, I guess that should be the problem. =

Moreover as you probably have already noticed, the init values are =

really different between mantis and TT-3200. Manu told me that it is =

because they use different freq (99MHz for TT and 108MHz for Mantis), =

but the handling of the registers are so different there might be other =

differences also. Anyway it seems that both cards have some problematic =

locking for some transponders so the fix might work for both.
I could do some further testing (even spreading printks in the code is =

doable for me).
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
