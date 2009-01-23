Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LQS4q-00083t-5e
	for linux-dvb@linuxtv.org; Fri, 23 Jan 2009 20:52:28 +0100
Received: by gxk14 with SMTP id 14so4969056gxk.17
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 11:51:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090123224924.62a48791@bk.ru>
References: <20090123205854.45e40dd0@bk.ru> <200901231959.49629.hftom@free.fr>
	<20090123224924.62a48791@bk.ru>
Date: Fri, 23 Jan 2009 21:51:53 +0200
Message-ID: <c74595dc0901231151iafa6b15kd3c0949e0ed86668@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx24116 & roll-off factor = auto
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1991036394=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1991036394==
Content-Type: multipart/alternative; boundary=001636e90a80772afa04612bb84c

--001636e90a80772afa04612bb84c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Fri, Jan 23, 2009 at 9:49 PM, Goga777 <goga777@bk.ru> wrote:

> > > does support cx24116  the roll-off factor = auto ?
> >
> > no
>
> who should be care about of corrected roll-off factor which have to send to
> cx24116 - the drivers or user software ? does
> roll-off factor = 0,35 good for 99% dvb-s2 channels ?

Driver interface allows specifying AUTO value for most of the parameters.
User application has no idea what card is used and what driver is running.
Since there are other drivers/chipsets that can handle AUTO setting, I don't
see any reason why application should not use it.

For example, DVB-S uses only rolloff = 0.35, so if the driver knows that the
chip can't accept auto value, it should use 0.35 value by default in that
case.

Beside all that, there is a bigger problem that pops up with cx24116 chips
using S2API.
When specifying AUTO value for any of the parameters the driver fails the
tuning, but the application knows nothing about it, so it thinks that
current received stream is from the new channel, while its not true.



>
> Goga
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--001636e90a80772afa04612bb84c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Fri, Jan 23, 2009 at 9:49 PM=
, Goga777 <span dir=3D"ltr">&lt;<a href=3D"mailto:goga777@bk.ru">goga777@bk=
.ru</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"bor=
der-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-=
left: 1ex;">
&gt; &gt; does support cx24116 &nbsp;the roll-off factor =3D auto ?<br>
&gt;<br>
&gt; no<br>
<br>
who should be care about of corrected roll-off factor which have to send to=
 cx24116 - the drivers or user software ? does<br>
roll-off factor =3D 0,35 good for 99% dvb-s2 channels ?</blockquote><div>Dr=
iver interface allows specifying AUTO value for most of the parameters.<br>=
User application has no idea what card is used and what driver is running.<=
br>
Since there are other drivers/chipsets that can handle AUTO setting, I don&=
#39;t see any reason why application should not use it.<br><br>For example,=
 DVB-S uses only rolloff =3D 0.35, so if the driver knows that the chip can=
&#39;t accept auto value, it should use 0.35 value by default in that case.=
<br>
<br>Beside all that, there is a bigger problem that pops up with cx24116 ch=
ips using S2API.<br>When specifying AUTO value for any of the parameters th=
e driver fails the tuning, but the application knows nothing about it, so i=
t thinks that current received stream is from the new channel, while its no=
t true.<br>
<br><br></div><blockquote class=3D"gmail_quote" style=3D"border-left: 1px s=
olid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br=
>
<br>
Goga<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb users mailing list<br>
For V4L/DVB development, please use instead <a href=3D"mailto:linux-media@v=
ger.kernel.org">linux-media@vger.kernel.org</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</blockquote></div><br></div>

--001636e90a80772afa04612bb84c--


--===============1991036394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1991036394==--
