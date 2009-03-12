Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1Lhj5m-0002fp-61
	for linux-dvb@linuxtv.org; Thu, 12 Mar 2009 12:28:52 +0100
Message-ID: <008c01c9a306$0980ff70$f4c6a5c1@tommy>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: <rasmus@akvaservice.dk>
References: <1236727187.8238.17.camel@SailCat><000d01c9a1d7$b1a28af0$217da8c0@tdrpc><1236728592.8238.20.camel@SailCat><1236733002.7701.3.camel@SailCat><002b01c9a211$9ceecfd0$217da8c0@tdrpc>
	<1236808127.6961.4.camel@SailCat>
Date: Thu, 12 Mar 2009 12:31:08 +0100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KNC1
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1269489897=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1269489897==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0089_01C9A30E.6B3784C0"

This is a multi-part message in MIME format.

------=_NextPart_000_0089_01C9A30E.6B3784C0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rasmus,
I haven't tested my HD channels yet, in fact there was nothing =
intersting I would like to record yet. ;-) All my favourite channels are =
still provided in MPEG-2 PAL. Try another mux=3D option or transcode. =
What about "mp4"? http://wiki.videolan.org/Codec#Muxers Maybe I will try =
it during the weekend.

Regards,
Tomas


  ----- Original Message -----=20
  From: Rasmus Pedersen=20
  To: linux-dvb@linuxtv.org=20
  Cc: linux-dvb@linuxtv.org=20
  Sent: Wednesday, March 11, 2009 10:48 PM
  Subject: Re: [linux-dvb] KNC1


  Hi Tomas

  Thanks for the info. I successfully recorded various channels and =
played them on the PS3, so fare so good.  :)

  I only have a bit of trouble recording the h.264 channels. If I view =
them with VLC they work fin, but if I record them with VLC and then view =
them with VLC they get all pixelated.=20

  The PS3 wont play them either, even tho it plays a h.264 stream =
recorded with Xine from the same channel.=20

  I think I might be missing some setting when recording the h.264 =
stream, since it works perfecly when viewing live tv with VLC.

  Regards,
  Rasmus

      =20

  ons, 11 03 2009 kl. 07:21 +0100, skrev Tomas Drajsajtl:

    =EF=BB=BF=20
    Hi Rasmus,=20
    something like=20
    =20
    vlc -vvv --color -I dummy --ts-es-id-pid --program=3D1 =
--dvb-adapter=3D0 dvb: --dvb-frequency=3D258000000 --dvb-srate=3D6900000 =
--dvb-modulation=3D64 --sout =
'#standard{access=3Dfile,mux=3Dts,dst=3D"record.mpg"}'=20
    =20
    does the job. Of course you need to pass your own DVB-C options.=20
    =20
    Regards,=20
    Tomas 
------=_NextPart_000_0089_01C9A30E.6B3784C0
Content-Type: text/html;
	charset="UTF-8"
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
<DIV><FONT face=3DArial size=3D2>I haven't tested&nbsp;my HD channels =
yet, in fact=20
there was nothing intersting I would like to record yet. ;-) All my =
favourite=20
channels are&nbsp;still provided in MPEG-2&nbsp;PAL. =
Try&nbsp;another&nbsp;mux=3D=20
option or transcode.&nbsp;What about "mp4"? <A=20
href=3D"http://wiki.videolan.org/Codec#Muxers">http://wiki.videolan.org/C=
odec#Muxers</A>&nbsp;Maybe=20
I will try it during the weekend.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Regards,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Tomas</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
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
  <DIV style=3D"FONT: 10pt arial"><B>Cc:</B> <A =
title=3Dlinux-dvb@linuxtv.org=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Wednesday, March 11, 2009 =
10:48=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [linux-dvb] =
KNC1</DIV>
  <DIV><BR></DIV>Hi Tomas<BR><BR>Thanks for the info. I successfully =
recorded=20
  various channels and played them on the PS3, so fare so good.&nbsp;=20
  :)<BR><BR>I only have a bit of trouble recording the h.264 channels. =
If I view=20
  them with VLC they work fin, but if I record them with VLC and then =
view them=20
  with VLC they get all pixelated. <BR><BR>The PS3 wont play them =
either, even=20
  tho it plays a h.264 stream recorded with Xine from the same channel.=20
  <BR><BR>I think I might be missing some setting when recording the =
h.264=20
  stream, since it works perfecly when viewing live tv with=20
  VLC.<BR><BR>Regards,<BR>Rasmus<BR>
  <TABLE cellSpacing=3D0 cellPadding=3D0 width=3D"100%">
    <TBODY>
    <TR>
      <TD><BR></TD></TR></TBODY></TABLE><BR>ons, 11 03 2009 kl. 07:21 =
+0100, skrev=20
  Tomas Drajsajtl:<BR>
  <BLOCKQUOTE TYPE=3D"CITE">=EF=BB=BF </BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"><FONT size=3D2>Hi Rasmus,</FONT> =
</BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"><FONT size=3D2>something like</FONT> =
</BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"> </BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"><FONT size=3D2>vlc -vvv --color -I dummy=20
    --ts-es-id-pid --program=3D1 --dvb-adapter=3D0 dvb: =
--dvb-frequency=3D258000000=20
    --dvb-srate=3D6900000 --dvb-modulation=3D64 --sout=20
    '#standard{access=3Dfile,mux=3Dts,dst=3D"record.mpg"}'</FONT> =
</BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"> </BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"><FONT size=3D2>does the job. Of course you =
need to=20
    pass your own DVB-C options.</FONT> </BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"> </BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"><FONT size=3D2>Regards,</FONT> </BLOCKQUOTE>
  <BLOCKQUOTE TYPE=3D"CITE"><FONT size=3D2>Tomas</FONT>=20
</BLOCKQUOTE></BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_0089_01C9A30E.6B3784C0--



--===============1269489897==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1269489897==--
