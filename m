Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Harald.Becherer@gmx.de>) id 1Kklvx-00089y-H0
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 22:35:03 +0200
Message-Id: <994AD73E-BB0E-4FA5-8481-6EBB65BEF1DC@gmx.de>
From: Harald Becherer <Harald.Becherer@gmx.de>
To: DVB-Mailing <linux-dvb@linuxtv.org>
In-Reply-To: <c74595dc0809300248i12241125ia77a788f3094bc75@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 5F136)
Date: Tue, 30 Sep 2008 22:34:36 +0200
References: <c74595dc0809290713i7ca11bdfw3424c8347e9a6d9e@mail.gmail.com>
	<909452.76198.qm@web23201.mail.ird.yahoo.com>
	<c74595dc0809300248i12241125ia77a788f3094bc75@mail.gmail.com>
Subject: Re: [linux-dvb] Re : Re : TT S2-3200 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1909247438=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1909247438==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-1--313458523


--Apple-Mail-1--313458523
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: quoted-printable

Would a TT S2-3650 CI also do the job?
I would like to contribute with testing...

Harald



Am 30.09.2008 um 11:48 schrieb "Alex Betis" <alex.betis@gmail.com>:

> I'll send the patches to the list as soon as I'll finish some more =20
> debugging and clean the code from all the garbage I've added there.
>
> Meanwhile I'd also like to wait for few people responses who test =20
> those patches. So far one person with Twinhan 1041 card confirmed =20
> that the changes "improved a lot" the locking. Waiting for few more =20=

> people with TT S2-3200 to confirm it.
>
> On Tue, Sep 30, 2008 at 12:35 PM, Newsy Paper =
<newspaperman_germany@yahoo.com=20
> > wrote:
> Hi Alex!
>
> This souds like good news!
> Hope you could help us with a patch from you.
>
> kind regards
>
>
> Newsy
>
>
> --- Alex Betis <alex.betis@gmail.com> schrieb am Mo, 29.9.2008:
>
> > Von: Alex Betis <alex.betis@gmail.com>
> > Betreff: Re: [linux-dvb] Re : Re : TT S2-3200 driver
> > An: "Jelle De Loecker" <skerit@kipdola.com>
> > CC: "linux-dvb" <linux-dvb@linuxtv.org>
> > Datum: Montag, 29. September 2008, 16:13
> > Does that card use stb0899 drivers as Twinhan 1041?
> >
> > I've done some changes to the algorithm that provide
> > constant lock.
> >
> > 2008/9/29 Jelle De Loecker <skerit@kipdola.com>
> >
> > >
> > > manu schreef:
> > >
> > > Le 13.09.2008 19:10:31, Manu Abraham a =C3=A9crit :
> > >
> > >
> > >  manu wrote:
> > >
> > >
> > >  I forgot the logs...
> > >
> > >
> > >  Taking a look at it. Please do note that, i will have
> > to go through
> > > it
> > > very patiently.
> > >
> > > Thanks for the logs.
> > >
> > >
> > >
> > >  You're more than welcome. I tried to put some
> > printk's but the only
> > > thing I got is that even when the carrier is correctly
> > detected, the
> > > driver does not detect the data (could that be related
> > to the different
> > > FEC?).
> > > Anyway let me know if you need more testing.
> > > Bye
> > > Manu
> > >
> > >
> > > I'm unable to scan the channels on the Astra 23,5
> > satellite
> > > Frequency 11856000
> > > Symbol rate 27500000
> > > Vertical polarisation
> > > FEC 5/6
> > >
> > > Is this because of the same bug? I should be getting
> > Discovery Channel HD,
> > > National Geographic Channel HD, Brava HDTV and Voom HD
> > International, but
> > > I'm only getting a time out.
> > >
> > >
> > > *Met vriendelijke groeten,*
> > >
> > > *Jelle De Loecker*
> > > Kipdola Studios - Tomberg
> > >
> > >
> > >
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > >
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

--Apple-Mail-1--313458523
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body bgcolor=3D"#FFFFFF"><div>Would a TT S2-3650 CI also do the =
job?</div><div>I would like to contribute with =
testing...</div><div><br></div><div>Harald<br><br><br></div><div><br>Am =
30.09.2008 um 11:48 schrieb "Alex Betis" &lt;<a =
href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>>:<br><br></d=
iv><div><span></span></div><blockquote type=3D"cite"><div><div =
dir=3D"ltr">I'll send the patches to the list as soon as I'll finish =
some more debugging and clean the code from all the garbage I've added =
there.<br><br>Meanwhile I'd also like to wait for few people responses =
who test those patches. So far one person with Twinhan 1041 card =
confirmed that the changes "improved a lot" the locking. Waiting for few =
more people with TT S2-3200 to confirm it.<br>
<br><div class=3D"gmail_quote">On Tue, Sep 30, 2008 at 12:35 PM, Newsy =
Paper <span dir=3D"ltr">&lt;<a =
href=3D"mailto:newspaperman_germany@yahoo.com"><a =
href=3D"mailto:newspaperman_germany@yahoo.com">newspaperman_germany@yahoo.=
com</a></a>></span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt =
0.8ex; padding-left: 1ex;">
Hi Alex!<br>
<br>
This souds like good news!<br>
Hope you could help us with a patch from you.<br>
<br>
kind regards<br>
<br>
<br>
Newsy<br>
<br>
<br>
--- Alex Betis &lt;<a href=3D"mailto:alex.betis@gmail.com"><a =
href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail.com</a></a>> =
schrieb am Mo, 29.9.2008:<br>
<br>
> Von: Alex Betis &lt;<a href=3D"mailto:alex.betis@gmail.com"><a =
href=3D"mailto:alex.betis@gmail.com">alex.betis@gmail.com</a></a>><br>
> Betreff: Re: [linux-dvb] Re : Re : TT S2-3200 driver<br>
> An: "Jelle De Loecker" &lt;<a href=3D"mailto:skerit@kipdola.com"><a =
href=3D"mailto:skerit@kipdola.com">skerit@kipdola.com</a></a>><br>
> CC: "linux-dvb" &lt;<a href=3D"mailto:linux-dvb@linuxtv.org"><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a></a>><br>
> Datum: Montag, 29. September 2008, 16:13<br>
<div><div></div><div class=3D"Wj3C7c">> Does that card use stb0899 =
drivers as Twinhan 1041?<br>
><br>
> I've done some changes to the algorithm that provide<br>
> constant lock.<br>
><br>
> 2008/9/29 Jelle De Loecker &lt;<a href=3D"mailto:skerit@kipdola.com"><a =
href=3D"mailto:skerit@kipdola.com">skerit@kipdola.com</a></a>><br>
><br>
> ><br>
> > manu schreef:<br>
> ><br>
> > Le 13.09.2008 19:10:31, Manu Abraham a =C3=A9crit :<br>
> ><br>
> ><br>
> > &nbsp;manu wrote:<br>
> ><br>
> ><br>
> > &nbsp;I forgot the logs...<br>
> ><br>
> ><br>
> > &nbsp;Taking a look at it. Please do note that, i will have<br>
> to go through<br>
> > it<br>
> > very patiently.<br>
> ><br>
> > Thanks for the logs.<br>
> ><br>
> ><br>
> ><br>
> > &nbsp;You're more than welcome. I tried to put some<br>
> printk's but the only<br>
> > thing I got is that even when the carrier is correctly<br>
> detected, the<br>
> > driver does not detect the data (could that be related<br>
> to the different<br>
> > FEC?).<br>
> > Anyway let me know if you need more testing.<br>
> > Bye<br>
> > Manu<br>
> ><br>
> ><br>
> > I'm unable to scan the channels on the Astra 23,5<br>
> satellite<br>
> > Frequency 11856000<br>
> > Symbol rate 27500000<br>
> > Vertical polarisation<br>
> > FEC 5/6<br>
> ><br>
> > Is this because of the same bug? I should be getting<br>
> Discovery Channel HD,<br>
> > National Geographic Channel HD, Brava HDTV and Voom HD<br>
> International, but<br>
> > I'm only getting a time out.<br>
> ><br>
> ><br>
> > *Met vriendelijke groeten,*<br>
> ><br>
> > *Jelle De Loecker*<br>
> > Kipdola Studios - Tomberg<br>
> ><br>
> ><br>
> ><br>
> > _______________________________________________<br>
> > linux-dvb mailing list<br>
> > <a href=3D"mailto:linux-dvb@linuxtv.org"><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a></a><br>
> ><br>
> <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank"><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></a><br>
> ><br>
> _______________________________________________<br>
> linux-dvb mailing list<br>
> <a href=3D"mailto:linux-dvb@linuxtv.org"><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a></a><br>
> <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank"><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></a><br>
<br>
<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org"><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a></a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank"><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></a><br>
</div></div></blockquote></div><br></div>
</div></blockquote><blockquote =
type=3D"cite"><div><span>_______________________________________________</=
span><br><span>linux-dvb mailing list</span><br><span><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a></span><br>=
<span><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></span></div></block=
quote></body></html>=

--Apple-Mail-1--313458523--


--===============1909247438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1909247438==--
