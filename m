Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp3-g19.free.fr ([212.27.42.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <djamil@djamil.net>) id 1L3qFw-0008O7-7M
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 12:02:30 +0100
Received: from smtp3-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp3-g19.free.fr (Postfix) with ESMTP id E097317B57D
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 12:02:23 +0100 (CET)
Received: from [192.168.1.10] (djamil.net [88.177.154.16])
	by smtp3-g19.free.fr (Postfix) with ESMTP id A65C317B54F
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 12:02:23 +0100 (CET)
From: djamil <djamil@djamil.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1226645235.9539.8.camel@toptop>
References: <1226593203.7542.5.camel@martin>  <491CBB23.9000904@rogers.com>
	<1226645235.9539.8.camel@toptop>
Date: Sat, 22 Nov 2008 12:02:23 +0100
Message-Id: <1227351743.18169.1.camel@toptop>
Mime-Version: 1.0
Subject: Re: [linux-dvb] hvr 1400
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0791270328=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0791270328==
Content-Type: multipart/alternative; boundary="=-NXyPPomIyBS93IXGm1QN"


--=-NXyPPomIyBS93IXGm1QN
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Le vendredi 14 novembre 2008 =E0 07:47 +0100, djamil a =E9crit :

> hello  again
>=20
> gents, i wrote in 96 the first X11 application to drive a radio card
> in florida ...
>=20
> so can anyone tell me about spying proramms under windows to reverse
> engeneer what wintv does ant the drivers
>=20
> so i can get analog working in linux ?
>=20
> best regards
>=20
>=20
> _______________________________________
>=20
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>=20
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



hi=20

I adde this

        [CX23885_BOARD_HAUPPAUGE_HVR1400] =3D {
                .name           =3D "Hauppauge WinTV-HVR1400",
                .porta          =3D CX23885_ANALOG_VIDEO,
                .portb          =3D CX23885_MPEG_ENCODER,
                .portc          =3D CX23885_MPEG_DVB,
                .tuner_type     =3D TUNER_LG_PAL_NEW_TAPC,
                .input          =3D {{
                        .type   =3D CX23885_VMUX_TELEVISION,
                        .vmux   =3D 0,
                        .gpio0  =3D 0xff00,
                }, {
                        .type   =3D CX23885_VMUX_DEBUG,
                        .vmux   =3D 0,
                        .gpio0  =3D 0xff01,
                }, {
                        .type   =3D CX23885_VMUX_COMPOSITE1,
                        .vmux   =3D 1,
                        .gpio0  =3D 0xff02,
                }, {
                        .type   =3D CX23885_VMUX_SVIDEO,
                        .vmux   =3D 2,
                        .gpio0  =3D 0xff02,
                } },

        },

"cx23885-cards.c" 674 lignes --25%--
171,22-44     21%



and its still not working, can anyone help ? i does compile ....

--=-NXyPPomIyBS93IXGm1QN
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.24.1.1">
</HEAD>
<BODY>
Le vendredi 14 novembre 2008 &#224; 07:47 +0100, djamil a &#233;crit&nbsp;:<BR>
<BLOCKQUOTE TYPE=CITE>
    hello&nbsp; again<BR>
    <BR>
    gents, i wrote in 96 the first X11 application to drive a radio card in florida ...<BR>
    <BR>
    so can anyone tell me about spying proramms under windows to reverse engeneer what wintv does ant the drivers<BR>
    <BR>
    so i can get analog working in linux ?<BR>
    <BR>
    best regards<BR>
    <BR>
<PRE>
_______________________________________
</PRE>
    <BLOCKQUOTE TYPE=CITE>
<PRE>
linux-dvb mailing list
<A HREF="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>
<A HREF="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</A>
</PRE>
    </BLOCKQUOTE>
<PRE>
_______________________________________________
linux-dvb mailing list
<A HREF="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>
<A HREF="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</A>
</PRE>
</BLOCKQUOTE>
<BR>
<BR>
hi <BR>
<BR>
I adde this<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [CX23885_BOARD_HAUPPAUGE_HVR1400] = {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = &quot;Hauppauge WinTV-HVR1400&quot;,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .porta&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = CX23885_ANALOG_VIDEO,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .portb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = CX23885_MPEG_ENCODER,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .portc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = CX23885_MPEG_DVB,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .tuner_type&nbsp;&nbsp;&nbsp;&nbsp; = TUNER_LG_PAL_NEW_TAPC,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .input&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = {{<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .type&nbsp;&nbsp; = CX23885_VMUX_TELEVISION,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .vmux&nbsp;&nbsp; = 0,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .gpio0&nbsp; = 0xff00,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }, {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .type&nbsp;&nbsp; = CX23885_VMUX_DEBUG,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .vmux&nbsp;&nbsp; = 0,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .gpio0&nbsp; = 0xff01,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }, {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .type&nbsp;&nbsp; = CX23885_VMUX_COMPOSITE1,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .vmux&nbsp;&nbsp; = 1,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .gpio0&nbsp; = 0xff02,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }, {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .type&nbsp;&nbsp; = CX23885_VMUX_SVIDEO,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .vmux&nbsp;&nbsp; = 2,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .gpio0&nbsp; = 0xff02,<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } },<BR>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; },<BR>
<BR>
&quot;cx23885-cards.c&quot; 674 lignes --25%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 171,22-44&nbsp;&nbsp;&nbsp;&nbsp; 21%<BR>
<BR>
<BR>
<BR>
and its still not working, can anyone help ? i does compile ....
</BODY>
</HTML>

--=-NXyPPomIyBS93IXGm1QN--



--===============0791270328==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0791270328==--
