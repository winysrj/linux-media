Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n35.bullet.mail.ukl.yahoo.com ([87.248.110.168])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KmeTG-0006e0-0G
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 03:01:12 +0200
Date: Sun, 05 Oct 2008 21:00:34 -0400
From: Emmanuel ALLAUD <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <c74595dc0810012238p6eb5ea9fg30d8cc296a803a32@mail.gmail.com>
	<1223212383l.6064l.0l@manu-laptop>
	<c74595dc0810050654j1e4519cbn2c4a996cb5c3d03c@mail.gmail.com>
In-Reply-To: <c74595dc0810050654j1e4519cbn2c4a996cb5c3d03c@mail.gmail.com>
	(from alex.betis@gmail.com on Sun Oct  5 09:54:39 2008)
Message-Id: <1223254834l.7216l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : Re : Twinhan 1041 (SP 400) lock and scan
 problems - the solution [not quite :(]
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

Le 05.10.2008 09:54:39, Alex Betis a =E9crit=A0:
> So where are the logs?

I will post the tomorrow probably (I have some network problems).

> Can you give me the link to the sattelite you're using on lyngsat
> site?
> There are many Atlantic (Birds) sats so I don't know which one you're
> referring to.

Oh yes sorry: it is intelsat 903; but all the freqs in lyngsat are a =

bit off compared to what you get IN the tables from the feed.

> I'm sure Manu knows much more about that driver than I am, but I =

> think
> the
> code takes the clock into consideration when calculating parameters
> for
> search algorithm.

Yes that's what he told me. Anyway I think I saw that both cards (1041 =

and TT-3200) have locking problems, so a fix for one could well make =

the others happy ;-)
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
