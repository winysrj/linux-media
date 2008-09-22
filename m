Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <javier.galvez.guerrero@gmail.com>)
	id 1Khk7c-0003PF-Ja
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 14:02:34 +0200
Received: by rn-out-0910.google.com with SMTP id m36so431352rnd.2
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 05:02:28 -0700 (PDT)
Message-ID: <145d4e1a0809220502v56020205o54fd186b227bdee7@mail.gmail.com>
Date: Mon, 22 Sep 2008 14:02:28 +0200
From: "=?ISO-8859-1?Q?Javier_G=E1lvez_Guerrero?="
	<javier.galvez.guerrero@gmail.com>
To: urishk@yahoo.com
In-Reply-To: <670024.49326.qm@web38804.mail.mud.yahoo.com>
MIME-Version: 1.0
References: <145d4e1a0809220101j4063c300s7ec63ab13362bdf9@mail.gmail.com>
	<670024.49326.qm@web38804.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-H support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0003870817=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0003870817==
Content-Type: multipart/alternative;
	boundary="----=_Part_57532_23426575.1222084948560"

------=_Part_57532_23426575.1222084948560
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Uri,

Thanks for your answer.

2008/9/22 Uri Shkolnik <urishk@yahoo.com>

> Hi,
>
> yep, you can do it with any Siano chipset based device.


Do you know any specific device with Siano chipset that works properly or
any device will do?


> How are you going to deal with ESG and HO?
>

I want to develop a handover framework for IEEE 802.11 // 3G // DVB-H
networks, dealing with different parameters depending on what drivers API
allowed me, but basically the signal strength would be the main one.

Regarding the ESG I don't know how to deal with it as I'm a complete novice
with LinuxTV/dvb-utils. First I wanted to know if it was possible to get
DVB-H streams with it and what hardware would be proper. I supposed that
demuxing and selecting the contents would be nearly the same that in DVB-T,
as the main difference is the time slicing in DVB-H streams.

Anyway, do you have any idea or piece of advice? Is what I want to do
possible or not?

>
>
>
> Best Regards,
>
> Uri Shkolnik
>
>
>
> --- On Mon, 9/22/08, Javier G=E1lvez Guerrero <
> javier.galvez.guerrero@gmail.com> wrote:
>
> > From: Javier G=E1lvez Guerrero <javier.galvez.guerrero@gmail.com>
> > Subject: [linux-dvb] DVB-H support
> > To: linux-dvb@linuxtv.org
> > Date: Monday, September 22, 2008, 11:01 AM
> > Hi everyone,
> >
> > Has anyone succeed in receiving a DVB-H stream with
> > dvb-utils? If so, which
> > hardware have you used?
> >
> > Any help is much appreciated.
> >
> > Regards,
> > Javi
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
>
>

------=_Part_57532_23426575.1222084948560
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Hi Uri,<br><br>Thanks for your answer.<br><br><div class=
=3D"gmail_quote">2008/9/22 Uri Shkolnik <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:urishk@yahoo.com">urishk@yahoo.com</a>&gt;</span><br><blockquote class=
=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin=
: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
yep, you can do it with any Siano chipset based device.</blockquote><div><b=
r>Do you know any specific device with Siano chipset that works properly or=
 any device will do?<br><br></div><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;">
<br>
How are you going to deal with ESG and HO?<br>
</blockquote><div><br>I want to develop a handover framework for IEEE 802.1=
1 // 3G // DVB-H networks, dealing with different parameters depending on w=
hat drivers API allowed me, but basically the signal strength would be the =
main one. <br>
<br>Regarding the ESG I don&#39;t know how to deal with it as I&#39;m a com=
plete novice with LinuxTV/dvb-utils. First I wanted to know if it was possi=
ble to get DVB-H streams with it and what hardware would be proper. I suppo=
sed that demuxing and selecting the contents would be nearly the same that =
in DVB-T, as the main difference is the time slicing in DVB-H streams.<br>
<br>Anyway, do you have any idea or piece of advice? Is what I want to do p=
ossible or not?<br></div><blockquote class=3D"gmail_quote" style=3D"border-=
left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left=
: 1ex;">
<br>
<br>
<br>
Best Regards,<br>
<br>
Uri Shkolnik<br>
<br>
<br>
<br>
--- On Mon, 9/22/08, Javier G=E1lvez Guerrero &lt;<a href=3D"mailto:javier.=
galvez.guerrero@gmail.com">javier.galvez.guerrero@gmail.com</a>&gt; wrote:<=
br>
<br>
&gt; From: Javier G=E1lvez Guerrero &lt;<a href=3D"mailto:javier.galvez.gue=
rrero@gmail.com">javier.galvez.guerrero@gmail.com</a>&gt;<br>
&gt; Subject: [linux-dvb] DVB-H support<br>
&gt; To: <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>=
<br>
&gt; Date: Monday, September 22, 2008, 11:01 AM<br>
<div><div></div><div class=3D"Wj3C7c">&gt; Hi everyone,<br>
&gt;<br>
&gt; Has anyone succeed in receiving a DVB-H stream with<br>
&gt; dvb-utils? If so, which<br>
&gt; hardware have you used?<br>
&gt;<br>
&gt; Any help is much appreciated.<br>
&gt;<br>
&gt; Regards,<br>
&gt; Javi<br>
</div></div>&gt; _______________________________________________<br>
&gt; linux-dvb mailing list<br>
&gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
</a><br>
<br>
<br>
<br>
</blockquote></div><br></div>

------=_Part_57532_23426575.1222084948560--


--===============0003870817==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0003870817==--
