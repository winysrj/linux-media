Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KmnPc-0002Xl-R4
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 12:34:01 +0200
Received: by qw-out-2122.google.com with SMTP id 9so593760qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 06 Oct 2008 03:33:56 -0700 (PDT)
Message-ID: <c74595dc0810060333x80a0472n5e9779fb16446b35@mail.gmail.com>
Date: Mon, 6 Oct 2008 12:33:56 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Emmanuel ALLAUD" <eallaud@yahoo.fr>
In-Reply-To: <1223254834l.7216l.0l@manu-laptop>
MIME-Version: 1.0
References: <c74595dc0810012238p6eb5ea9fg30d8cc296a803a32@mail.gmail.com>
	<1223212383l.6064l.0l@manu-laptop>
	<c74595dc0810050654j1e4519cbn2c4a996cb5c3d03c@mail.gmail.com>
	<1223254834l.7216l.0l@manu-laptop>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Re : Re : Re : Twinhan 1041 (SP 400) lock and scan
	problems - the solution [not quite :(]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1887839064=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1887839064==
Content-Type: multipart/alternative;
	boundary="----=_Part_20693_30269998.1223289236688"

------=_Part_20693_30269998.1223289236688
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Emmanuel,

As I wrote:
> Just to clarify it, the changes mostly affect DVB-S channels
> scanning,
> it
> doesn't help with DVB-S2 locking problem since the code is totally
> different
> for S and S2 signal search.

The 11495 channel you reported as bad is DVB-S2, so my changes doesn't help
for that channel.

I hope Manu will find a solution since I don't have any documentation for
that chip and solving the DVB-S2 problem needs knowledge in chip internals.



On Mon, Oct 6, 2008 at 3:00 AM, Emmanuel ALLAUD <eallaud@yahoo.fr> wrote:

> Le 05.10.2008 09:54:39, Alex Betis a =E9crit :
> > So where are the logs?
>
> I will post the tomorrow probably (I have some network problems).
>
> > Can you give me the link to the sattelite you're using on lyngsat
> > site?
> > There are many Atlantic (Birds) sats so I don't know which one you're
> > referring to.
>
> Oh yes sorry: it is intelsat 903; but all the freqs in lyngsat are a
> bit off compared to what you get IN the tables from the feed.
>
> > I'm sure Manu knows much more about that driver than I am, but I
> > think
> > the
> > code takes the clock into consideration when calculating parameters
> > for
> > search algorithm.
>
> Yes that's what he told me. Anyway I think I saw that both cards (1041
> and TT-3200) have locking problems, so a fix for one could well make
> the others happy ;-)
>  Bye
> Manu
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_20693_30269998.1223289236688
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><div>Emmanuel,</div>
<div>&nbsp;</div>
<div>As I wrote:</div>
<div>&gt; Just to clarify it, the changes mostly affect DVB-S channels<br>&=
gt; scanning,<br>&gt; it<br>&gt; doesn&#39;t help with DVB-S2 locking probl=
em since the code is totally<br>&gt; different<br>&gt; for S and S2 signal =
search.</div>

<div>&nbsp;</div>
<div>The 11495 channel you reported as bad is DVB-S2, so my changes doesn&#=
39;t help for that channel.</div>
<div>&nbsp;</div>
<div>I hope Manu will find a solution since I don&#39;t have any documentat=
ion for that chip and solving the DVB-S2 problem needs knowledge in chip in=
ternals.</div>
<div><br><br>&nbsp;</div>
<div class=3D"gmail_quote">On Mon, Oct 6, 2008 at 3:00 AM, Emmanuel ALLAUD =
<span dir=3D"ltr">&lt;<a href=3D"mailto:eallaud@yahoo.fr">eallaud@yahoo.fr<=
/a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Le 05.10.2008 09:54:39, Alex Bet=
is a =E9crit&nbsp;:<br>
<div class=3D"Ih2E3d">&gt; So where are the logs?<br><br></div>I will post =
the tomorrow probably (I have some network problems).<br>
<div class=3D"Ih2E3d"><br>&gt; Can you give me the link to the sattelite yo=
u&#39;re using on lyngsat<br>&gt; site?<br>&gt; There are many Atlantic (Bi=
rds) sats so I don&#39;t know which one you&#39;re<br>&gt; referring to.<br=
>
<br></div>Oh yes sorry: it is intelsat 903; but all the freqs in lyngsat ar=
e a<br>bit off compared to what you get IN the tables from the feed.<br>
<div class=3D"Ih2E3d"><br>&gt; I&#39;m sure Manu knows much more about that=
 driver than I am, but I<br>&gt; think<br>&gt; the<br>&gt; code takes the c=
lock into consideration when calculating parameters<br>&gt; for<br>&gt; sea=
rch algorithm.<br>
<br></div>Yes that&#39;s what he told me. Anyway I think I saw that both ca=
rds (1041<br>and TT-3200) have locking problems, so a fix for one could wel=
l make<br>the others happy ;-)<br>
<div>
<div></div>
<div class=3D"Wj3C7c">Bye<br>Manu<br><br><br>______________________________=
_________________<br>linux-dvb mailing list<br><a href=3D"mailto:linux-dvb@=
linuxtv.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.org=
/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.o=
rg/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br></div>

------=_Part_20693_30269998.1223289236688--


--===============1887839064==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1887839064==--
