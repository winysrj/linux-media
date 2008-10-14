Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n9a.bullet.ukl.yahoo.com ([217.146.183.157])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KptTA-0005oc-Hp
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 01:38:32 +0200
Date: Tue, 14 Oct 2008 19:37:50 -0400
From: Emmanuel ALLAUD <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <c74595dc0810012238p6eb5ea9fg30d8cc296a803a32@mail.gmail.com>
	<1223212383l.6064l.0l@manu-laptop>
	<c74595dc0810050654j1e4519cbn2c4a996cb5c3d03c@mail.gmail.com>
	<1223254834l.7216l.0l@manu-laptop>
	<c74595dc0810060333x80a0472n5e9779fb16446b35@mail.gmail.com>
	<1224014045l.11287l.1l@manu-laptop> <48F526B1.8040807@gmail.com>
In-Reply-To: <48F526B1.8040807@gmail.com> (from abraham.manu@gmail.com on
	Tue Oct 14 19:09:37 2008)
Message-Id: <1224027470l.20196l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : Re : Re : Re : Twinhan 1041 (SP 400) lock and
 scan problems - the solution [not quite :(]
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

Le 14.10.2008 19:09:37, Manu Abraham a =E9crit=A0:
> Hi,
> =

> Emmanuel ALLAUD wrote:
> > Le 06.10.2008 06:33:56, Alex Betis a =E9crit :
> >> Emmanuel,
> >>
> >> As I wrote:
> >>> Just to clarify it, the changes mostly affect DVB-S channels
> >>> scanning,
> >>> it
> >>> doesn't help with DVB-S2 locking problem since the code is =

> totally
> >>> different
> >>> for S and S2 signal search.
> >> The 11495 channel you reported as bad is DVB-S2, so my changes =

> >> doesn't
> >> help
> >> for that channel.
> >>
> >> I hope Manu will find a solution since I don't have any
> documentation
> >> for
> >> that chip and solving the DVB-S2 problem needs knowledge in chip
> >> internals.
> > =

> > OK so here are the 2 logs using simpledvbtune, one using dvb-s2 and
> the =

> > other dvb-s (and I check the tables from the other transponders of
> this =

> > sat, this transponder is declared as DVB-S).
> > In any case you will see that something is picked up in both cases
> but =

> > nothing comes out fine finally.
> > I CCed Manu to see if he can shed some light!
> > This is done with a clean multiproto tree IIRC, verbose=3D5 for both =

> > stbxxxx modules.
> =

> =

> I will take a look at this. BTW, any idea what FEC you are using for
> the
>   transponder you are trying to tune to ?

It is marked in the tables as 5/6 (all the other transiponders are 3/4 =

and they work so this should be the problem).
Thanks,
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
