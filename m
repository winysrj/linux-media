Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KpzmX-0005cd-Ua
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 08:22:56 +0200
Received: by qw-out-2122.google.com with SMTP id 9so771883qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 23:22:49 -0700 (PDT)
Message-ID: <c74595dc0810142322i488aba24n7ae45cc2f469290@mail.gmail.com>
Date: Wed, 15 Oct 2008 08:22:49 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Linux DVB Mailing List" <linux-dvb@linuxtv.org>
In-Reply-To: <1224027470l.20196l.1l@manu-laptop>
MIME-Version: 1.0
References: <c74595dc0810012238p6eb5ea9fg30d8cc296a803a32@mail.gmail.com>
	<1223212383l.6064l.0l@manu-laptop>
	<c74595dc0810050654j1e4519cbn2c4a996cb5c3d03c@mail.gmail.com>
	<1223254834l.7216l.0l@manu-laptop>
	<c74595dc0810060333x80a0472n5e9779fb16446b35@mail.gmail.com>
	<1224014045l.11287l.1l@manu-laptop> <48F526B1.8040807@gmail.com>
	<1224027470l.20196l.1l@manu-laptop>
Subject: Re: [linux-dvb] Re : Re : Re : Re : Re : Twinhan 1041 (SP 400) lock
	and scan problems - the solution [not quite :(]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0599008667=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0599008667==
Content-Type: multipart/alternative;
	boundary="----=_Part_19709_7841571.1224051769092"

------=_Part_19709_7841571.1224051769092
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have some channels with 2/3 that loose FEC lock.


On Wed, Oct 15, 2008 at 1:37 AM, Emmanuel ALLAUD <eallaud@yahoo.fr> wrote:

> Le 14.10.2008 19:09:37, Manu Abraham a =E9crit :
>  > Hi,
> >
> > Emmanuel ALLAUD wrote:
> > > Le 06.10.2008 06:33:56, Alex Betis a =E9crit :
> > >> Emmanuel,
> > >>
> > >> As I wrote:
> > >>> Just to clarify it, the changes mostly affect DVB-S channels
> > >>> scanning,
> > >>> it
> > >>> doesn't help with DVB-S2 locking problem since the code is
> > totally
> > >>> different
> > >>> for S and S2 signal search.
> > >> The 11495 channel you reported as bad is DVB-S2, so my changes
> > >> doesn't
> > >> help
> > >> for that channel.
> > >>
> > >> I hope Manu will find a solution since I don't have any
> > documentation
> > >> for
> > >> that chip and solving the DVB-S2 problem needs knowledge in chip
> > >> internals.
> > >
> > > OK so here are the 2 logs using simpledvbtune, one using dvb-s2 and
> > the
> > > other dvb-s (and I check the tables from the other transponders of
> > this
> > > sat, this transponder is declared as DVB-S).
> > > In any case you will see that something is picked up in both cases
> > but
> > > nothing comes out fine finally.
> > > I CCed Manu to see if he can shed some light!
> > > This is done with a clean multiproto tree IIRC, verbose=3D5 for both
> > > stbxxxx modules.
> >
> >
> > I will take a look at this. BTW, any idea what FEC you are using for
> > the
> >   transponder you are trying to tune to ?
>
> It is marked in the tables as 5/6 (all the other transiponders are 3/4
> and they work so this should be the problem).
> Thanks,
> Bye
>  Manu
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_19709_7841571.1224051769092
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">I have some channels with 2/3 that loose FEC lock.<br><br>=
<br>
<div class=3D"gmail_quote">On Wed, Oct 15, 2008 at 1:37 AM, Emmanuel ALLAUD=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:eallaud@yahoo.fr">eallaud@yahoo.fr=
</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Le 14.10.2008 19:09:37, Manu Abr=
aham a =E9crit&nbsp;:<br>
<div>
<div></div>
<div class=3D"Wj3C7c">&gt; Hi,<br>&gt;<br>&gt; Emmanuel ALLAUD wrote:<br>&g=
t; &gt; Le 06.10.2008 06:33:56, Alex Betis a =E9crit :<br>&gt; &gt;&gt; Emm=
anuel,<br>&gt; &gt;&gt;<br>&gt; &gt;&gt; As I wrote:<br>&gt; &gt;&gt;&gt; J=
ust to clarify it, the changes mostly affect DVB-S channels<br>
&gt; &gt;&gt;&gt; scanning,<br>&gt; &gt;&gt;&gt; it<br>&gt; &gt;&gt;&gt; do=
esn&#39;t help with DVB-S2 locking problem since the code is<br>&gt; totall=
y<br>&gt; &gt;&gt;&gt; different<br>&gt; &gt;&gt;&gt; for S and S2 signal s=
earch.<br>
&gt; &gt;&gt; The 11495 channel you reported as bad is DVB-S2, so my change=
s<br>&gt; &gt;&gt; doesn&#39;t<br>&gt; &gt;&gt; help<br>&gt; &gt;&gt; for t=
hat channel.<br>&gt; &gt;&gt;<br>&gt; &gt;&gt; I hope Manu will find a solu=
tion since I don&#39;t have any<br>
&gt; documentation<br>&gt; &gt;&gt; for<br>&gt; &gt;&gt; that chip and solv=
ing the DVB-S2 problem needs knowledge in chip<br>&gt; &gt;&gt; internals.<=
br>&gt; &gt;<br>&gt; &gt; OK so here are the 2 logs using simpledvbtune, on=
e using dvb-s2 and<br>
&gt; the<br>&gt; &gt; other dvb-s (and I check the tables from the other tr=
ansponders of<br>&gt; this<br>&gt; &gt; sat, this transponder is declared a=
s DVB-S).<br>&gt; &gt; In any case you will see that something is picked up=
 in both cases<br>
&gt; but<br>&gt; &gt; nothing comes out fine finally.<br>&gt; &gt; I CCed M=
anu to see if he can shed some light!<br>&gt; &gt; This is done with a clea=
n multiproto tree IIRC, verbose=3D5 for both<br>&gt; &gt; stbxxxx modules.<=
br>
&gt;<br>&gt;<br>&gt; I will take a look at this. BTW, any idea what FEC you=
 are using for<br>&gt; the<br>&gt; &nbsp; transponder you are trying to tun=
e to ?<br><br></div></div>It is marked in the tables as 5/6 (all the other =
transiponders are 3/4<br>
and they work so this should be the problem).<br>Thanks,<br>Bye<br>
<div>
<div></div>
<div class=3D"Wj3C7c">Manu<br><br><br>_____________________________________=
__________<br>linux-dvb mailing list<br><a href=3D"mailto:linux-dvb@linuxtv=
.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.org/cgi-bi=
n/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-=
bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_19709_7841571.1224051769092--


--===============0599008667==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0599008667==--
