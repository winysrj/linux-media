Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1LhHqC-0003fM-L0
	for linux-dvb@linuxtv.org; Wed, 11 Mar 2009 07:22:58 +0100
Message-ID: <002b01c9a211$9ceecfd0$217da8c0@tdrpc>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: <rasmus@akvaservice.dk>,
	<linux-dvb@linuxtv.org>
References: <1236727187.8238.17.camel@SailCat><000d01c9a1d7$b1a28af0$217da8c0@tdrpc><1236728592.8238.20.camel@SailCat>
	<1236733002.7701.3.camel@SailCat>
Date: Wed, 11 Mar 2009 07:21:28 +0100
MIME-Version: 1.0
Subject: Re: [linux-dvb] KNC1
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1952271110=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1952271110==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0028_01C9A219.FE9DB400"

This is a multi-part message in MIME format.

------=_NextPart_000_0028_01C9A219.FE9DB400
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi Rasmus,
something like

vlc -vvv --color -I dummy --ts-es-id-pid --program=3D1 --dvb-adapter=3D0 =
dvb: --dvb-frequency=3D258000000 --dvb-srate=3D6900000 =
--dvb-modulation=3D64 --sout =
'#standard{access=3Dfile,mux=3Dts,dst=3D"record.mpg"}'

does the job. Of course you need to pass your own DVB-C options.

Regards,
Tomas



  ----- Original Message -----=20
  From: Rasmus Pedersen=20
  To: linux-dvb@linuxtv.org=20
  Sent: Wednesday, March 11, 2009 1:56 AM
  Subject: Re: [linux-dvb] KNC1



      =20
  Hi Tomas,

  VLC works perfect, I can view the encrypted channels now. One step =
closer to getting recorded tv on my PS3.

  Now I just need to figure out how to make VLC save the stream to disk.

  Thanks alot :-)

  ons, 11 03 2009 kl. 00:43 +0100, skrev Rasmus Pedersen:



        =20
    Hi Tomas

    Ahh, I had forgotten all about VLC.

    What options you use to get it working?

    Regards,
    Rasmus

    ons, 11 03 2009 kl. 00:26 +0100, skrev Tomas Drajsajtl:=20
Hi Rasmus,
the VLC media player records programs for me perfectly from the command
line. If you have problems to give the correct options to it, don't =
hesitate
to ask.

Regards,
Tomas


----- Original Message -----=20
From: "Rasmus Pedersen" <rasmus@akvaservice.dk>
To: <linux-dvb@linuxtv.org>
Sent: Wednesday, March 11, 2009 12:19 AM
Subject: [linux-dvb] KNC1


> Hi,
>
> I've got some problems getting my KNC1 DVB-C working correctly.
>
> The card is found correctly as
.........
> My problem is that I want to record tv from the consol (I'm working on
> script that can record television and expose it thru mediatomb to be
> played on my PS3), and Kaffeine does not run without its UI.
.........
> The problem is also there when using zap and dvbstreamer. I have not =
yet
> tried mythtv or vdr, since I was hoping for a simpler solution using
> gnutv or similar software to just dump the stream to disk (decrypted
> ofcourse).
>
> I hope somebody might now what the problem could be..
>
> Regards,
> Rasmus Pedersen
>
>

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-------------------------------------------------------------------------=
-----


  _______________________________________________
  linux-dvb users mailing list
  For V4L/DVB development, please use instead =
linux-media@vger.kernel.org
  linux-dvb@linuxtv.org
  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_NextPart_000_0028_01C9A219.FE9DB400
Content-Type: text/html;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=EF=BB=BF<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dutf-8"><DEFANGED_META=20
CONTENT=3D"text/html; CHARSET=3DUTF-8" =
HTTP-EQUIV=3D"Content-Type"><DEFANGED_META=20
CONTENT=3D"GtkHTML/3.24.1.1" NAME=3D"GENERATOR">
<META content=3D"MSHTML 6.00.2800.1619" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hi Rasmus,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>something like</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>vlc -vvv --color -I dummy =
--ts-es-id-pid=20
--program=3D1 --dvb-adapter=3D0 dvb: --dvb-frequency=3D258000000 =
--dvb-srate=3D6900000=20
--dvb-modulation=3D64 --sout=20
'#standard{access=3Dfile,mux=3Dts,dst=3D"record.mpg"}'</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>does the job. Of course you need to =
pass your own=20
DVB-C options.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Regards,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Tomas</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;</DIV>
<DIV><BR></DIV></FONT>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3Drasmus@akvaservice.dk =
href=3D"mailto:rasmus@akvaservice.dk">Rasmus=20
  Pedersen</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Dlinux-dvb@linuxtv.org=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Wednesday, March 11, 2009 =
1:56=20
  AM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [linux-dvb] =
KNC1</DIV>
  <DIV><BR></DIV>
  <TABLE cellSpacing=3D0 cellPadding=3D0 width=3D"100%">
    <TBODY>
    <TR>
      <TD><BR></TD></TR></TBODY></TABLE>Hi Tomas,<BR><BR>VLC works =
perfect, I can=20
  view the encrypted channels now. One step closer to getting recorded =
tv on my=20
  PS3.<BR><BR>Now I just need to figure out how to make VLC save the =
stream to=20
  disk.<BR><BR>Thanks alot :-)<BR><BR>ons, 11 03 2009 kl. 00:43 +0100, =
skrev=20
  Rasmus Pedersen:<BR>
  <BLOCKQUOTE TYPE=3D"CITE">
    <TABLE cellSpacing=3D0 cellPadding=3D0 width=3D"100%">
      <TBODY>
      <TR>
        <TD><BR><BR></TD></TR></TBODY></TABLE>Hi Tomas<BR><BR>Ahh, I had =
forgotten=20
    all about VLC.<BR><BR>What options you use to get it=20
    working?<BR><BR>Regards,<BR>Rasmus<BR><BR>ons, 11 03 2009 kl. 00:26 =
+0100,=20
    skrev Tomas Drajsajtl:=20
    <BLOCKQUOTE TYPE=3D"CITE"><PRE>Hi Rasmus,
the VLC media player records programs for me perfectly from the command
line. If you have problems to give the correct options to it, don't =
hesitate
to ask.

Regards,
Tomas


----- Original Message -----=20
From: "Rasmus Pedersen" &lt;<A =
href=3D"mailto:rasmus@akvaservice.dk">rasmus@akvaservice.dk</A>&gt;
To: &lt;<A =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>&gt;
Sent: Wednesday, March 11, 2009 12:19 AM
Subject: [linux-dvb] KNC1


&gt; Hi,
&gt;
&gt; I've got some problems getting my KNC1 DVB-C working correctly.
&gt;
&gt; The card is found correctly as
.........
&gt; My problem is that I want to record tv from the consol (I'm working =
on
&gt; script that can record television and expose it thru mediatomb to =
be
&gt; played on my PS3), and Kaffeine does not run without its UI.
.........
&gt; The problem is also there when using zap and dvbstreamer. I have =
not yet
&gt; tried mythtv or vdr, since I was hoping for a simpler solution =
using
&gt; gnutv or similar software to just dump the stream to disk =
(decrypted
&gt; ofcourse).
&gt;
&gt; I hope somebody might now what the problem could be..
&gt;
&gt; Regards,
&gt; Rasmus Pedersen
&gt;
&gt;

</PRE></BLOCKQUOTE><PRE>_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead <A =
href=3D"mailto:linux-media@vger.kernel.org">linux-media@vger.kernel.org</=
A>
<A href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>
<A =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http:/=
/www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</A>
</PRE></BLOCKQUOTE>
  <P>
  <HR>

  <P></P>_______________________________________________<BR>linux-dvb =
users=20
  mailing list<BR>For V4L/DVB development, please use instead=20
  =
linux-media@vger.kernel.org<BR>linux-dvb@linuxtv.org<BR>http://www.linuxt=
v.org/cgi-bin/mailman/listinfo/linux-dvb</BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_0028_01C9A219.FE9DB400--



--===============1952271110==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1952271110==--
