Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n32.bullet.mail.ukl.yahoo.com ([87.248.110.149])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1Kl7Zw-0001xJ-GF
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 21:41:45 +0200
Date: Wed, 01 Oct 2008 15:41:06 -0400
From: Emmanuel ALLAUD <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <c74595dc0810010721h2dceb13ega11f8525be8cfe5a@mail.gmail.com>
In-Reply-To: <c74595dc0810010721h2dceb13ega11f8525be8cfe5a@mail.gmail.com>
	(from alex.betis@gmail.com on Wed Oct  1 10:21:00 2008)
Message-Id: <1222890066l.12772l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Twinhan 1041 (SP 400) lock and scan problems - the
 solution [not quite :(]
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

Le 01.10.2008 10:21:00, Alex Betis a =E9crit=A0:
> Patch files are attached.
> Several people reported better lock on DVB-S channels.
> =

> Just to clarify it, the changes mostly affect DVB-S channels =

> scanning,
> it
> doesn't help with DVB-S2 locking problem since the code is totally
> different
> for S and S2 signal search.

Test report: it looks like good transponders (FEC 3/4, vertical =

polarisation, SR 30M) that used to lock will lock a bit faster, so I'd =

say that good things are now even more reliable and fast.
BUT the bad transponder (same charact but different FEC, 5/6) still =

does not lock, at least not in 30s. So there still is something fishy. =

And the problem is in data search as I can see several CARRIEROK during =

the search but each time the data search (I'd guess FEC lock) fails and =

after some time the freq is too far away and status becomes NOCARRIER.
I'd be glad to test further.
Bye
Manu =



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
