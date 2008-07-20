Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <meysam.hariri@gmail.com>) id 1KKY1F-0007W4-JI
	for linux-dvb@linuxtv.org; Sun, 20 Jul 2008 14:28:07 +0200
Received: by wa-out-1112.google.com with SMTP id n7so517048wag.13
	for <linux-dvb@linuxtv.org>; Sun, 20 Jul 2008 05:28:00 -0700 (PDT)
Message-ID: <1a18e9e80807200527g71186bf2w2ad038d3c10ee876@mail.gmail.com>
Date: Sun, 20 Jul 2008 16:57:59 +0430
From: "Meysam Hariri" <meysam.hariri@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <loom.20080718T125917-359@post.gmane.org>
MIME-Version: 1.0
References: <200807170023.57637.ajurik@quick.cz>
	<loom.20080718T125917-359@post.gmane.org>
Subject: Re: [linux-dvb] TT S2-3200 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0005595852=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0005595852==
Content-Type: multipart/alternative;
	boundary="----=_Part_60793_8814187.1216556879327"

------=_Part_60793_8814187.1216556879327
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I applied the recent patch and i still can't get lock on eutelsat w6
transponder: frequency 11449Mhz, DVB-S2, modulation 8PSK, FEC 9/10 with
symbolrate of 30000. i had no luck getting even a temporary lock. i have
lock on this frequency using a dvb-s2 enabled ipricot satellite ip router.

Regards,


On Fri, Jul 18, 2008, Daniel Hellstr=F6m <dvenion@hotmail.com> wrote:

> Ales Jurik <ajurik <at> quick.cz> writes:
>
> >
> > Hi,
> >
> > please try attached patch. With this patch I'm able to get lock on
> channels
> > before it was impossible. But not at all problematic channels and the
> > reception is not without errors. Also it seems to me that channel
> switching is
> > quicklier.
>
> I have tested the transponder with Eurosport now. It has DVB-S2, 8PSK, Fe=
c
> 3/4
> and 30000 in symbolrate. I get instant lock but no picture. Just black
> screen.
> All the other transponders locks fast and I get picture.
>
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_60793_8814187.1216556879327
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Hello,<br><br>I applied the recent patch and i still can&#=
39;t get lock on eutelsat w6 transponder: frequency 11449Mhz, DVB-S2, modul=
ation 8PSK, FEC 9/10 with symbolrate of 30000. i had no luck getting even a=
 temporary lock. i have lock on this frequency using a dvb-s2 enabled ipric=
ot satellite ip router.<br>
<br>Regards,<br><br><br><div class=3D"gmail_quote">On Fri, Jul 18, 2008, Da=
niel Hellstr=F6m &lt;<a href=3D"mailto:dvenion@hotmail.com">dvenion@hotmail=
.com</a>&gt; wrote:<br><blockquote class=3D"gmail_quote" style=3D"border-le=
ft: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: =
1ex;">
<div class=3D"Ih2E3d">Ales Jurik &lt;ajurik &lt;at&gt; <a href=3D"http://qu=
ick.cz" target=3D"_blank">quick.cz</a>&gt; writes:<br>
<br>
&gt;<br>
</div><div class=3D"Ih2E3d">&gt; Hi,<br>
&gt;<br>
&gt; please try attached patch. With this patch I&#39;m able to get lock on=
 channels<br>
&gt; before it was impossible. But not at all problematic channels and the<=
br>
&gt; reception is not without errors. Also it seems to me that channel swit=
ching is<br>
&gt; quicklier.<br>
<br>
</div>I have tested the transponder with Eurosport now. It has DVB-S2, 8PSK=
, Fec 3/4<br>
and 30000 in symbolrate. I get instant lock but no picture. Just black scre=
en.<br>
All the other transponders locks fast and I get picture.<br>
<div><div></div><div class=3D"Wj3C7c"><br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</div></div></blockquote></div><br></div>

------=_Part_60793_8814187.1216556879327--


--===============0005595852==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0005595852==--
