Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alihmh@gmail.com>) id 1KUHNB-0002Gx-Qc
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 10:43:00 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1371020rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 16 Aug 2008 01:42:53 -0700 (PDT)
Message-ID: <66caf1560808160142g7446425co164b36cce747c600@mail.gmail.com>
Date: Sat, 16 Aug 2008 12:12:53 +0330
From: "Ali H.M. Hoseini" <alihmh@gmail.com>
To: "Brice DUBOST" <braice@braice.net>
In-Reply-To: <48A690B7.9090602@braice.net>
MIME-Version: 1.0
References: <66caf1560808160130w714d1b1r4339ccd4577447aa@mail.gmail.com>
	<48A690B7.9090602@braice.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] how to prevent scan utility from scaning other
	transponders?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1330983962=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1330983962==
Content-Type: multipart/alternative;
	boundary="----=_Part_5506_21955733.1218876173398"

------=_Part_5506_21955733.1218876173398
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, Aug 16, 2008 at 12:02 PM, Brice DUBOST <braice@braice.net> wrote:

> Ali H.M. Hoseini a =E9crit :
> > Hi all,
> >
> > When I use scan utility to scan a transponder, in some freq. scan
> > continues to scan other transponders (I think find them in NIT tables),
> > and that mean I should wait 2-3 minutes for scan to complete it's work,
> > and list all the transponders it found.
> >
> > how should I prevent scan utility from scaning other transponders? And
> > force it to scan just the transponder I want?
> >
> >
> > Thanks.
> >
> > Ali.
> >
>
> Hello
>
> Lock on the transponder
>
> and use scan -c
>
> Regards


Hi ,

Thanks Brice,  But I'm trying to find a way to do this just with scan.
Because if I want to tune to freq. with szap, first I should create an
channels.conf file. This is the hen and egg problem, because I should first
scan that freq. to create channels.conf.

Does anybody knows a solution for this?

Regard.

------=_Part_5506_21955733.1218876173398
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr"><br><br><div class=3D"gmail_quote">On Sat, Aug 16, 2008 at=
 12:02 PM, Brice DUBOST <span dir=3D"ltr">&lt;<a href=3D"mailto:braice@brai=
ce.net">braice@braice.net</a>&gt;</span> wrote:<br><blockquote class=3D"gma=
il_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0=
pt 0pt 0.8ex; padding-left: 1ex;">
Ali H.M. Hoseini a =E9crit :<br>
<div><div></div><div class=3D"Wj3C7c">&gt; Hi all,<br>
&gt;<br>
&gt; When I use scan utility to scan a transponder, in some freq. scan<br>
&gt; continues to scan other transponders (I think find them in NIT tables)=
,<br>
&gt; and that mean I should wait 2-3 minutes for scan to complete it&#39;s =
work,<br>
&gt; and list all the transponders it found.<br>
&gt;<br>
&gt; how should I prevent scan utility from scaning other transponders? And=
<br>
&gt; force it to scan just the transponder I want?<br>
&gt;<br>
&gt;<br>
&gt; Thanks.<br>
&gt;<br>
&gt; Ali.<br>
&gt;<br>
<br>
</div></div>Hello<br>
<br>
Lock on the transponder<br>
<br>
and use scan -c<br>
<br>
Regards</blockquote><div><br>Hi ,<br><br>Thanks Brice,&nbsp; But I&#39;m tr=
ying to find a way to do this just with scan. Because if I want to tune to =
freq. with szap, first I should create an channels.conf file. This is the h=
en and egg problem, because I should first scan that freq. to create channe=
ls.conf.<br>
<br>Does anybody knows a solution for this?<br><br>Regard. <br></div></div>=
<br></div>

------=_Part_5506_21955733.1218876173398--


--===============1330983962==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1330983962==--
