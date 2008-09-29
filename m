Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n23.bullet.mail.ukl.yahoo.com ([87.248.110.140])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KkOAG-0001Al-If
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 21:12:13 +0200
Date: Mon, 29 Sep 2008 15:10:50 -0400
From: Emmanuel ALLAUD <eallaud@yahoo.fr>
To: Jelle De Loecker <skerit@kipdola.com>
References: <1221327465l.12125l.2l@manu-laptop> <48CC4867.1050705@gmail.com>
	<1221354611l.12125l.3l@manu-laptop> <48E0D490.5030202@kipdola.com>
In-Reply-To: <48E0D490.5030202@kipdola.com> (from skerit@kipdola.com on Mon
	Sep 29 09:13:52 2008)
Message-Id: <1222715450l.7695l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Re :  Re : Re : TT S2-3200 driver
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

Le 29.09.2008 09:13:52, Jelle De Loecker a =E9crit=A0:
> =

> manu schreef:
> > Le 13.09.2008 19:10:31, Manu Abraham a =E9crit :
> >   =

> >> manu wrote:
> >>     =

> >>> I forgot the logs...
> >>>       =

> >> Taking a look at it. Please do note that, i will have to go =

> through
> =

> >> it
> >> very patiently.
> >>
> >> Thanks for the logs.
> >>
> >>     =

> >
> > You're more than welcome. I tried to put some printk's but the only =

> > thing I got is that even when the carrier is correctly detected, =

> the
> =

> > driver does not detect the data (could that be related to the
> different =

> > FEC?).
> > Anyway let me know if you need more testing.
> > Bye
> > Manu
> =

> I'm unable to scan the channels on the Astra 23,5 satellite
> Frequency 11856000
> Symbol rate 27500000
> Vertical polarisation
> FEC 5/6
> =

> Is this because of the same bug? I should be getting Discovery =

> Channel
> =

> HD, National Geographic Channel HD, Brava HDTV and Voom HD =

> International, but I'm only getting a time out.

Yes it looks like the same bug.
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
