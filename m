Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1-hoer.fullrate.dk ([90.185.1.42] helo=smtp.fullrate.dk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rasmus@akvaservice.dk>) id 1LhWJ0-00063L-Ua
	for linux-dvb@linuxtv.org; Wed, 11 Mar 2009 22:49:40 +0100
From: Rasmus Pedersen <rasmus@akvaservice.dk>
To: linux-dvb@linuxtv.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <002b01c9a211$9ceecfd0$217da8c0@tdrpc>
References: <1236727187.8238.17.camel@SailCat>
	<000d01c9a1d7$b1a28af0$217da8c0@tdrpc><1236728592.8238.20.camel@SailCat>
	<1236733002.7701.3.camel@SailCat>
	<002b01c9a211$9ceecfd0$217da8c0@tdrpc>
Date: Wed, 11 Mar 2009 22:48:47 +0100
Message-Id: <1236808127.6961.4.camel@SailCat>
Mime-Version: 1.0
Subject: Re: [linux-dvb] KNC1
Reply-To: linux-media@vger.kernel.org, rasmus@akvaservice.dk
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0041438978=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0041438978==
Content-Type: multipart/alternative; boundary="=-jC0i6Yo9jwmdb7RB02ai"


--=-jC0i6Yo9jwmdb7RB02ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tomas

Thanks for the info. I successfully recorded various channels and played
them on the PS3, so fare so good.  :)

I only have a bit of trouble recording the h.264 channels. If I view
them with VLC they work fin, but if I record them with VLC and then view
them with VLC they get all pixelated.=20

The PS3 wont play them either, even tho it plays a h.264 stream recorded
with Xine from the same channel.=20

I think I might be missing some setting when recording the h.264 stream,
since it works perfecly when viewing live tv with VLC.

Regards,
Rasmus


ons, 11 03 2009 kl. 07:21 +0100, skrev Tomas Drajsajtl:

> =EF=BB=BF=20
>=20
> Hi Rasmus,
> something like
> =20
> vlc -vvv --color -I dummy --ts-es-id-pid --program=3D1 --dvb-adapter=3D=
0
> dvb: --dvb-frequency=3D258000000 --dvb-srate=3D6900000 --dvb-modulation=
=3D64
> --sout '#standard{access=3Dfile,mux=3Dts,dst=3D"record.mpg"}'
> =20
> does the job. Of course you need to pass your own DVB-C options.
> =20
> Regards,
> Tomas
> =20
>=20
>=20
>         ----- Original Message -----=20
>         From: Rasmus Pedersen=20
>         To: linux-dvb@linuxtv.org=20
>         Sent: Wednesday, March 11, 2009 1:56 AM
>         Subject: Re: [linux-dvb] KNC1
>        =20
>        =20
>        =20
>        =20
>        =20
>         Hi Tomas,
>        =20
>         VLC works perfect, I can view the encrypted channels now. One
>         step closer to getting recorded tv on my PS3.
>        =20
>         Now I just need to figure out how to make VLC save the stream
>         to disk.
>        =20
>         Thanks alot :-)
>        =20
>         ons, 11 03 2009 kl. 00:43 +0100, skrev Rasmus Pedersen:
>        =20
>         >=20
>         >=20
>         >=20
>         > Hi Tomas
>         >=20
>         > Ahh, I had forgotten all about VLC.
>         >=20
>         > What options you use to get it working?
>         >=20
>         > Regards,
>         > Rasmus
>         >=20
>         > ons, 11 03 2009 kl. 00:26 +0100, skrev Tomas Drajsajtl:=20
>         >=20
>         > > Hi Rasmus,
>         > > the VLC media player records programs for me perfectly from=
 the command
>         > > line. If you have problems to give the correct options to i=
t, don't hesitate
>         > > to ask.
>         > >=20
>         > > Regards,
>         > > Tomas
>         > >=20
>         > >=20
>         > > ----- Original Message -----=20
>         > > From: "Rasmus Pedersen" <rasmus@akvaservice.dk>
>         > > To: <linux-dvb@linuxtv.org>
>         > > Sent: Wednesday, March 11, 2009 12:19 AM
>         > > Subject: [linux-dvb] KNC1
>         > >=20
>         > >=20
>         > > > Hi,
>         > > >
>         > > > I've got some problems getting my KNC1 DVB-C working corr=
ectly.
>         > > >
>         > > > The card is found correctly as
>         > > .........
>         > > > My problem is that I want to record tv from the consol (I=
'm working on
>         > > > script that can record television and expose it thru medi=
atomb to be
>         > > > played on my PS3), and Kaffeine does not run without its =
UI.
>         > > .........
>         > > > The problem is also there when using zap and dvbstreamer.=
 I have not yet
>         > > > tried mythtv or vdr, since I was hoping for a simpler sol=
ution using
>         > > > gnutv or similar software to just dump the stream to disk=
 (decrypted
>         > > > ofcourse).
>         > > >
>         > > > I hope somebody might now what the problem could be..
>         > > >
>         > > > Regards,
>         > > > Rasmus Pedersen
>         > > >
>         > > >
>         > >=20
>         >=20
>         > _______________________________________________
>         > linux-dvb users mailing list
>         > For V4L/DVB development, please use instead linux-media@vger.=
kernel.org
>         > linux-dvb@linuxtv.org
>         > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>        =20
>        =20
>        =20
>         ______________________________________________________________
>        =20
>         _______________________________________________
>         linux-dvb users mailing list
>         For V4L/DVB development, please use instead
>         linux-media@vger.kernel.org
>         linux-dvb@linuxtv.org
>         http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

--=-jC0i6Yo9jwmdb7RB02ai
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.24.1.1">
</HEAD>
<BODY BGCOLOR="#ffffff">
Hi Tomas<BR>
<BR>
Thanks for the info. I successfully recorded various channels and played them on the PS3, so fare so good.&nbsp; :)<BR>
<BR>
I only have a bit of trouble recording the h.264 channels. If I view them with VLC they work fin, but if I record them with VLC and then view them with VLC they get all pixelated. <BR>
<BR>
The PS3 wont play them either, even tho it plays a h.264 stream recorded with Xine from the same channel. <BR>
<BR>
I think I might be missing some setting when recording the h.264 stream, since it works perfecly when viewing live tv with VLC.<BR>
<BR>
Regards,<BR>
Rasmus<BR>
<TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<TR>
<TD>
<BR>
</TD>
</TR>
</TABLE>
<BR>
ons, 11 03 2009 kl. 07:21 +0100, skrev Tomas Drajsajtl:<BR>
<BLOCKQUOTE TYPE=CITE>
    &#65279; 
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <FONT SIZE="2">Hi Rasmus,</FONT>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <FONT SIZE="2">something like</FONT>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    &nbsp;
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <FONT SIZE="2">vlc -vvv --color -I dummy --ts-es-id-pid --program=1 --dvb-adapter=0 dvb: --dvb-frequency=258000000 --dvb-srate=6900000 --dvb-modulation=64 --sout '#standard{access=file,mux=ts,dst=&quot;record.mpg&quot;}'</FONT>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    &nbsp;
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <FONT SIZE="2">does the job. Of course you need to pass your own DVB-C options.</FONT>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    &nbsp;
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <FONT SIZE="2">Regards,</FONT>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <FONT SIZE="2">Tomas</FONT>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <FONT SIZE="2">&nbsp;</FONT>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BR>
    <BR>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BLOCKQUOTE>
        ----- Original Message ----- 
    </BLOCKQUOTE>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BLOCKQUOTE>
        <B>From:</B> <A HREF="mailto:rasmus@akvaservice.dk">Rasmus Pedersen</A> 
    </BLOCKQUOTE>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BLOCKQUOTE>
        <B>To:</B> <A HREF="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> 
    </BLOCKQUOTE>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BLOCKQUOTE>
        <B>Sent:</B> Wednesday, March 11, 2009 1:56 AM
    </BLOCKQUOTE>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BLOCKQUOTE>
        <B>Subject:</B> Re: [linux-dvb] KNC1
    </BLOCKQUOTE>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BLOCKQUOTE>
        <BR>
        <BR>
    </BLOCKQUOTE>
</BLOCKQUOTE>
<BLOCKQUOTE TYPE=CITE>
    <BLOCKQUOTE>
        <TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<TR>
<TD>
<BR>
<BR>
</TD>
</TR>
</TABLE>
        Hi Tomas,<BR>
        <BR>
        VLC works perfect, I can view the encrypted channels now. One step closer to getting recorded tv on my PS3.<BR>
        <BR>
        Now I just need to figure out how to make VLC save the stream to disk.<BR>
        <BR>
        Thanks alot :-)<BR>
        <BR>
        ons, 11 03 2009 kl. 00:43 +0100, skrev Rasmus Pedersen:<BR>
        <BLOCKQUOTE TYPE=CITE>
            <TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<TR>
<TD>
<BR>
<BR>
<BR>
</TD>
</TR>
</TABLE>
            Hi Tomas<BR>
            <BR>
            Ahh, I had forgotten all about VLC.<BR>
            <BR>
            What options you use to get it working?<BR>
            <BR>
            Regards,<BR>
            Rasmus<BR>
            <BR>
            ons, 11 03 2009 kl. 00:26 +0100, skrev Tomas Drajsajtl: 
            <BLOCKQUOTE TYPE=CITE>
<PRE>
Hi Rasmus,
the VLC media player records programs for me perfectly from the command
line. If you have problems to give the correct options to it, don't hesitate
to ask.

Regards,
Tomas


----- Original Message ----- 
From: &quot;Rasmus Pedersen&quot; &lt;<A HREF="mailto:rasmus@akvaservice.dk">rasmus@akvaservice.dk</A>&gt;
To: &lt;<A HREF="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>&gt;
Sent: Wednesday, March 11, 2009 12:19 AM
Subject: [linux-dvb] KNC1


&gt; Hi,
&gt;
&gt; I've got some problems getting my KNC1 DVB-C working correctly.
&gt;
&gt; The card is found correctly as
.........
&gt; My problem is that I want to record tv from the consol (I'm working on
&gt; script that can record television and expose it thru mediatomb to be
&gt; played on my PS3), and Kaffeine does not run without its UI.
.........
&gt; The problem is also there when using zap and dvbstreamer. I have not yet
&gt; tried mythtv or vdr, since I was hoping for a simpler solution using
&gt; gnutv or similar software to just dump the stream to disk (decrypted
&gt; ofcourse).
&gt;
&gt; I hope somebody might now what the problem could be..
&gt;
&gt; Regards,
&gt; Rasmus Pedersen
&gt;
&gt;

</PRE>
            </BLOCKQUOTE>
<PRE>
_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead <A HREF="mailto:linux-media@vger.kernel.org">linux-media@vger.kernel.org</A>
<A HREF="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>
<A HREF="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</A>
</PRE>
        </BLOCKQUOTE>
        <BR>
        
<HR>
<BR>
        <BR>
        _______________________________________________<BR>
        linux-dvb users mailing list<BR>
        For V4L/DVB development, please use instead linux-media@vger.kernel.org<BR>
        linux-dvb@linuxtv.org<BR>
        http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
    </BLOCKQUOTE>
</BLOCKQUOTE>
</BODY>
</HTML>

--=-jC0i6Yo9jwmdb7RB02ai--



--===============0041438978==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0041438978==--
