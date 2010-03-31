Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <Martin.Gibson@opentv.com>) id 1Nx39n-0002mC-TK
	for linux-dvb@linuxtv.org; Wed, 31 Mar 2010 21:00:55 +0200
Received: from mtv2.opentv.com ([207.138.150.228]
	helo=mtv-ex-01.AD.opentv.local)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Nx39m-0006fc-C1; Wed, 31 Mar 2010 21:00:51 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Wed, 31 Mar 2010 12:00:21 -0700
Message-ID: <FA9524FC5D121D4FAD0016D8843D2D8103EA59D8@mtv-ex-01.AD.opentv.local>
From: "Martin Gibson" <Martin.Gibson@opentv.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Is the dvb API doc current?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1716518299=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1716518299==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CAD104.6A26006D"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CAD104.6A26006D
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

=20

I have been looking at doing some experiments with Linux on standard set
top boxes leveraging off the existing Linux DVB API. I was wondering if
the document on the web is current
(http://linuxtv.org/downloads/v4l-dvb-apis/pt02.html) since there seems
to be some missing parts.=20

=20

For instance in the frontend there is no distinction between DVB-S &
DVB-S2, and there are definitely some missing S2 values, i.e.

-          FEC values: 3/5, 9/10=20

-          Modulation: auto and 8PSK

-          No roll-off spec

-          On=20

=20

In the demux API there seems to be no support for configuration of
hardware exclusion filtering in sections=20

=20

To be clear this is not a criticism. I am just trying to establish if I
have the latest documents or if - for the purposes of my experiments - i
need to extend the capabilities of the devices.

=20

Also, reading through the documentation I saw the following comment:

... Linux DVB-API called "S2API" and now DVB API 5

=20

Is this a different API? Still in development?

=20

Thanks

Martin

=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Martin Gibson  |    Architect

OpenTV =20

1215 Terra Bella Ave,  Mountain View,  CA 94043

Phone:  650-962-2184

Mobile: 415-290-3706

=20

=20


------_=_NextPart_001_01CAD104.6A26006D
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
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
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:1293369856;
	mso-list-type:hybrid;
	mso-list-template-ids:1753006920 -1852553858 134807555 134807557 =
134807553 134807555 134807557 134807553 134807555 134807557;}
@list l0:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:-;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Calibri","sans-serif";
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:"Times New Roman";}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-GB link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>Hi all,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I have been looking at doing some experiments with =
Linux on
standard set top boxes leveraging off the existing Linux DVB API. I was
wondering if the document on the web is current (<a
href=3D"http://linuxtv.org/downloads/v4l-dvb-apis/pt02.html">http://linux=
tv.org/downloads/v4l-dvb-apis/pt02.html</a>)
since there seems to be some missing parts. <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>For instance in the frontend there is no =
distinction between
DVB-S &amp; DVB-S2, and there are definitely some missing S2 values, =
i.e.<o:p></o:p></p>

<p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 =
level1 lfo1'><![if !supportLists]><span
style=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>FEC values: 3/5, 9/10 <o:p></o:p></p>

<p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 =
level1 lfo1'><![if !supportLists]><span
style=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>Modulation: auto and 8PSK<o:p></o:p></p>

<p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 =
level1 lfo1'><![if !supportLists]><span
style=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>No roll-off spec<o:p></o:p></p>

<p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 =
level1 lfo1'><![if !supportLists]><span
style=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>On <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>In the demux API there seems to be no support for =
configuration
of hardware exclusion filtering in sections <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>To be clear this is not a criticism. I am just =
trying to
establish if I have the latest documents or if &#8211; for the purposes =
of my
experiments - i need to extend the capabilities of the =
devices.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Also, reading through the documentation I saw the =
following
comment:<o:p></o:p></p>

<p class=3DMsoNormal>... <i>Linux DVB-API called &quot;S2API&quot; and =
now DVB
API 5</i><o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Is this a different API? Still in =
development?<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Thanks<o:p></o:p></p>

<p class=3DMsoNormal>Martin<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span =
lang=3DEN-US>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Martin Gibson&nbsp; =
|&nbsp;&nbsp;&nbsp;
Architect<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>OpenTV&nbsp; =
<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>1215 Terra Bella Ave,&nbsp; =
Mountain
View,&nbsp; CA 94043<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Phone:&nbsp; =
650-962-2184<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US>Mobile: =
415-290-3706<o:p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

------_=_NextPart_001_01CAD104.6A26006D--


--===============1716518299==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1716518299==--
