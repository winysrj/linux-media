Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LR50T-0007K5-EU
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 14:26:33 +0100
Received: by qyk9 with SMTP id 9so6023067qyk.17
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 05:25:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497C359C.5090308@okg-computer.de>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
Date: Sun, 25 Jan 2009 15:25:59 +0200
Message-ID: <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
From: Alex Betis <alex.betis@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1334169063=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1334169063==
Content-Type: multipart/alternative; boundary=0015175ccf0615ff1804614e9014

--0015175ccf0615ff1804614e9014
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 25, 2009 at 11:49 AM, Jens Krehbiel-Gr=E4ther <
linux-dvb@okg-computer.de> wrote:

> Artem Makhutov schrieb:
> > Hello,
> >
> > I am wondering on how to use scan-s2.
> >
> > When running scan-s2 like this I am only getting 13 services:
> >
> > scan-s2 -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
> >
> > when running
> >
> > scan-s2 -a 2 -n -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
> >
> > then I am getting 152 services.
> >
> > When running the old dvbscan application I am getting 1461 services:
> >
> > dvbscan -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
> >
> >
> > Have I missed a parameter in scan-s2 or what else could be the problem?
> >
> > Thanks, Artem
>
>
> Hi Artem!
>
> I had the same "problem".When add no options I am only getting a few
> services.
> When I add the "-n" option I get some more services but all services I
> only get, when I am adding "-n -5".
>
> the "-5" means:
> multiply all filter timeouts by factor 5 for non-DVB-compliant section
> repitition rates
>
> The scan takes a long time then, but I get 1476 services (Astra 19.2).
> My device is a Pinnacle PCTV 452e (USB).
> Perhaps this switch is working with your device, too?
>

I also run it with "-5".
I personaly don't like to use network advertisements (-n switch) since I
don't trust them.
I use a full frequency filled INI file.

If you have a stb0899 device, don't forget to add "-k 3".


>
> Jens
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--0015175ccf0615ff1804614e9014
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote">On Sun, Jan 25, 2009 at 11:49 A=
M, Jens Krehbiel-Gr=E4ther <span dir=3D"ltr">&lt;<a href=3D"mailto:linux-dv=
b@okg-computer.de">linux-dvb@okg-computer.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Artem Makhutov schrieb:<br>&gt; =
Hello,<br>&gt;<br>&gt; I am wondering on how to use scan-s2.<br>&gt;<br>&gt=
; When running scan-s2 like this I am only getting 13 services:<br>
&gt;<br>&gt; scan-s2 -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E &gt; chan=
nels.conf<br>&gt;<br>&gt; when running<br>&gt;<br>&gt; scan-s2 -a 2 -n -o z=
ap /usr/share/dvb/dvb-s/Astra-19.2E &gt; channels.conf<br>&gt;<br>&gt; then=
 I am getting 152 services.<br>
&gt;<br>&gt; When running the old dvbscan application I am getting 1461 ser=
vices:<br>&gt;<br>&gt; dvbscan -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E=
 &gt; channels.conf<br>&gt;<br>&gt;<br>&gt; Have I missed a parameter in sc=
an-s2 or what else could be the problem?<br>
&gt;<br>&gt; Thanks, Artem<br><br><br>Hi Artem!<br><br>I had the same &quot=
;problem&quot;.When add no options I am only getting a few<br>services.<br>=
When I add the &quot;-n&quot; option I get some more services but all servi=
ces I<br>
only get, when I am adding &quot;-n -5&quot;.<br><br>the &quot;-5&quot; mea=
ns:<br>multiply all filter timeouts by factor 5 for non-DVB-compliant secti=
on<br>repitition rates<br><br>The scan takes a long time then, but I get 14=
76 services (Astra 19.2).<br>
My device is a Pinnacle PCTV 452e (USB).<br>Perhaps this switch is working =
with your device, too?<br></blockquote>
<div>&nbsp;</div>
<div>I also run it with &quot;-5&quot;.<br>I personaly don&#39;t like to us=
e network advertisements (-n switch) since I don&#39;t trust them.<br>I use=
 a full frequency filled INI file.<br>&nbsp;<br>If you have a stb0899 devic=
e, don&#39;t forget to add &quot;-k 3&quot;.</div>

<div>&nbsp;</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br>Jens<br=
><br>_______________________________________________<br>linux-dvb users mai=
ling list<br>
For V4L/DVB development, please use instead <a href=3D"mailto:linux-media@v=
ger.kernel.org">linux-media@vger.kernel.org</a><br><a href=3D"mailto:linux-=
dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv=
.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linux=
tv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

--0015175ccf0615ff1804614e9014--


--===============1334169063==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1334169063==--
