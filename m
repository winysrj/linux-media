Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <divneil.wadhawan@st.com>) id 1UClE3-0003um-F3
	for linux-dvb@linuxtv.org; Tue, 05 Mar 2013 07:20:11 +0100
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with smtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1UClE3-0006AD-Gg; Tue, 05 Mar 2013 07:19:47 +0100
Received: from zeta.dmz-ap.st.com (ns6.st.com [138.198.234.13])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id B0596C6
	for <linux-dvb@linuxtv.org>; Tue,  5 Mar 2013 06:11:32 +0000 (GMT)
Received: from Webmail-ap.st.com (eapex1hubcas1.st.com [10.80.176.8])
	by zeta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 1B35FD0F
	for <linux-dvb@linuxtv.org>; Tue,  5 Mar 2013 06:19:42 +0000 (GMT)
From: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Tue, 5 Mar 2013 14:19:41 +0800
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB6616AFB3CF67A@EAPEX1MAIL1.st.com>
Content-Language: en-US
MIME-Version: 1.0
Subject: [linux-dvb] DMX_SET_SOURCE documentation
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0724542986=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0724542986==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_2CC2A0A4A178534D93D5159BF3BCB6616AFB3CF67AEAPEX1MAIL1st_"

--_000_2CC2A0A4A178534D93D5159BF3BCB6616AFB3CF67AEAPEX1MAIL1st_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I have been working on LinuxDVB port, where the application wants to switch=
 dynamically from FRONT0 to DVR0 as DEMUX0 source, time and again.
The obvious way to handle this is to use DMX_SET_SOURCE which connects/disc=
onnects the FRONT0/DVR0 to DEMUX0.

Before implementing that, I would like to have the some sort of documentati=
on on this.
I have LinuxDVB specs V4, which has the equivalent DVB_DEMUX_SET_SOURCE and=
 poses the restriction that device be opened in WRONLY mode.
The concern is; is there going to some updation on this interface? Can we u=
pdate and merge the documentation in LinuxDVB doc pages.

Regards,
Divneil

--_000_2CC2A0A4A178534D93D5159BF3BCB6616AFB3CF67AEAPEX1MAIL1st_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:m=3D"http://schema=
s.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html=
40"><head><meta http-equiv=3DContent-Type content=3D"text/html; charset=3Du=
s-ascii"><meta name=3DGenerator content=3D"Microsoft Word 14 (filtered medi=
um)"><style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Hi,<o:p></o:p></=
p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I have bee=
n working on LinuxDVB port, where the application wants to switch dynamical=
ly from FRONT0 to DVR0 as DEMUX0 source, time and again.<o:p></o:p></p><p c=
lass=3DMsoNormal>The obvious way to handle this is to use DMX_SET_SOURCE wh=
ich connects/disconnects the FRONT0/DVR0 to DEMUX0.<o:p></o:p></p><p class=
=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Before implementing =
that, I would like to have the some sort of documentation on this.<o:p></o:=
p></p><p class=3DMsoNormal>I have LinuxDVB specs V4, which has the equivale=
nt DVB_DEMUX_SET_SOURCE and poses the restriction that device be opened in =
WRONLY mode.<o:p></o:p></p><p class=3DMsoNormal>The concern is; is there go=
ing to some updation on this interface? Can we update and merge the documen=
tation in LinuxDVB doc pages.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp=
;</o:p></p><p class=3DMsoNormal>Regards,<o:p></o:p></p><p class=3DMsoNormal=
>Divneil<o:p></o:p></p></div></body></html>=

--_000_2CC2A0A4A178534D93D5159BF3BCB6616AFB3CF67AEAPEX1MAIL1st_--


--===============0724542986==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0724542986==--
