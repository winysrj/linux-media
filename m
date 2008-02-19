Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mandm.thompson@gmail.com>) id 1JRJxm-0001T8-Cz
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 05:20:14 +0100
Received: by wf-out-1314.google.com with SMTP id 28so447098wfa.17
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 20:19:59 -0800 (PST)
Message-ID: <949AFE693DD44583A2F694F5EF46FEAA@LaptopPC>
From: "Martin Thompson" <marty@mandmservices.com.au>
To: <linux-dvb@linuxtv.org>
Date: Tue, 19 Feb 2008 15:19:44 +1100
MIME-Version: 1.0
Subject: [linux-dvb] dvico dual digital 4 new revision 2.0
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0652338702=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0652338702==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0027_01C8730A.DAF6E560"

This is a multi-part message in MIME format.

------=_NextPart_000_0027_01C8730A.DAF6E560
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

just bought a new dvico dd4 card
i has a revision 2.0 stamped on it
it is not picked up by mythtv
in the usb driver id the card is ID 0fe9:db78 DVICO  ID 0fe9:db78 DVICO
mine apperars as the same id exept on the ned not 78
so i changed the id to 98
linux picked it up as a dvico dd4 dvb card with two tuners
now mythtv finds the card but no frontend
i think they have changed that as well

dmesg | grep dvb-usb
[ 45.568438] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in =
warm state.
[ 45.568759] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[ 45.676871] dvb-usb: no frontend was attached by 'DViCO FusionHDTV =
DVB-T Dual Digital 4'
[ 45.677733] dvb-usb: schedule remote query interval to 100 msecs.
[ 45.677855] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully =
initialized and connected.
[ 45.677872] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in =
warm state.
[ 45.678261] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[ 46.003003] dvb-usb: no frontend was attached by 'DViCO FusionHDTV =
DVB-T Dual Digital 4'
[ 46.003591] dvb-usb: schedule remote query interval to 100 msecs.
[ 46.003900] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully =
initialized and connected.

lsusb
-snip-
Bus 002 Device 003: ID 0fe9:db98 DVICO
Bus 002 Device 002: ID 0fe9:db98 DVICO

lspci
-snip-
05:06.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 =
Controller (rev 62)
05:06.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 =
Controller (rev 62)
05:06.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
05:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video =
and Audio Decoder (rev 05)
05:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and =
Audio Decoder [MPEG Port] (rev 05)
05:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video =
Capture (rev 11)
05:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture =
(rev 11)
------=_NextPart_000_0027_01C8730A.DAF6E560
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.6000.16609" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>
<DIV><FONT face=3DArial size=3D2>
<DIV><FONT face=3DArial size=3D2>just bought a new dvico dd4 =
card</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>i has a revision 2.0 stamped on =
it</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>it is not picked up by =
mythtv</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>in the usb driver id the card is <SPAN=20
class=3Dwcrep2><FONT face=3D"Times New Roman" size=3D3>ID =
0fe9:db<B>78</B> DVICO=20
&nbsp;ID 0fe9:db<B>78</B> DVICO</FONT></SPAN></FONT></DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2>mine apperars as the same id =
exept on the=20
ned not 78</SPAN></FONT></DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2>so i changed the id to=20
98</SPAN></FONT></DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2>linux picked it up as a dvico =
dd4 dvb card=20
with two tuners</SPAN></FONT></DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2>now mythtv finds the card but =
no=20
frontend</SPAN></FONT></DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2>i think they have changed that =
as=20
well</SPAN></FONT></DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2>dmesg | grep dvb-usb<BR>[ =
45.568438]=20
dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm =
state.<BR>[=20
45.568759] dvb-usb: will pass the complete MPEG2 transport stream to the =

software demuxer.<BR>[ 45.676871] dvb-usb: no frontend was attached by =
'DViCO=20
FusionHDTV DVB-T Dual Digital 4'<BR>[ 45.677733] dvb-usb: schedule =
remote query=20
interval to 100 msecs.<BR>[ 45.677855] dvb-usb: DViCO FusionHDTV DVB-T =
Dual=20
Digital 4 successfully initialized and connected.<BR>[ 45.677872] =
dvb-usb: found=20
a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.<BR>[ 45.678261] =

dvb-usb: will pass the complete MPEG2 transport stream to the software=20
demuxer.<BR>[ 46.003003] dvb-usb: no frontend was attached by 'DViCO =
FusionHDTV=20
DVB-T Dual Digital 4'<BR>[ 46.003591] dvb-usb: schedule remote query =
interval to=20
100 msecs.<BR>[ 46.003900] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital =
4=20
successfully initialized and connected.</SPAN></FONT></DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT size=3D+0><SPAN class=3Dwcrep2>lsusb<BR>-snip-<BR>Bus 002 =
Device 003: ID=20
0fe9:db98 DVICO<BR>Bus 002 Device 002: ID 0fe9:db98=20
DVICO<BR><BR>lspci<BR>-snip-<BR>05:06.0 USB Controller: VIA =
Technologies, Inc.=20
VT82xxxxx UHCI USB 1.1 Controller (rev 62)<BR>05:06.1 USB Controller: =
VIA=20
Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62)<BR>05:06.2 =
USB=20
Controller: VIA Technologies, Inc. USB 2.0 (rev 65)<BR>05:07.0 =
Multimedia video=20
controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev=20
05)<BR>05:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video =
and Audio=20
Decoder [MPEG Port] (rev 05)<BR>05:08.0 Multimedia video controller: =
Brooktree=20
Corporation Bt878 Video Capture (rev 11)<BR>05:08.1 Multimedia =
controller:=20
Brooktree Corporation Bt878 Audio Capture (rev=20
11)</SPAN></FONT></DIV></FONT></DIV></FONT></DIV></BODY></HTML>

------=_NextPart_000_0027_01C8730A.DAF6E560--



--===============0652338702==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0652338702==--
