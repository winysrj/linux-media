Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.virginbroadband.com.au ([123.200.191.11])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <matt@pcmus.com>) id 1Mm91S-0007aB-My
	for linux-dvb@linuxtv.org; Fri, 11 Sep 2009 18:30:55 +0200
Received: from daw (unknown [121.91.168.9])
	by smtp.virginbroadband.com.au (Postfix) with ESMTP id 942AC1F9C174
	for <linux-dvb@linuxtv.org>; Sat, 12 Sep 2009 02:30:15 +1000 (EST)
From: "Matthew Skinner, PC Mus" <matt@pcmus.com>
To: <linux-dvb@linuxtv.org>
Date: Sat, 12 Sep 2009 02:30:14 +1000
Message-ID: <003901ca32fd$259ad820$70d08860$@com>
MIME-Version: 1.0
Content-Language: en-au
Subject: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote y04g0051 issues
Reply-To: linux-media@vger.kernel.org, matt@pcmus.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0226174407=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multipart message in MIME format.

--===============0226174407==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_003A_01CA3350.F746E820"
Content-Language: en-au

This is a multipart message in MIME format.

------=_NextPart_000_003A_01CA3350.F746E820
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hi,

 

I have the Leadtek WinFast DTV Dongle Gold which uses the af9015 chip and
the y04g0051 remote, after a lot of reading I now have the remote partially
working as only half of the keys are sending codes to "irw"

I read this thread and noticed that the exact keys which work are the ones
listed with reported codes. 

 

http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027058.html

 

The keys not mentioned in that thread are the ones not working, so I guess
the extra codes need to be reported to someone to be added into a new build?

 

Can I help in providing these codes and some testing.

 

Thank you.


------=_NextPart_000_003A_01CA3350.F746E820
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
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
@page Section1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-AU link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>Hi,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I have the Leadtek WinFast DTV Dongle Gold which =
uses the
af9015 chip and the y04g0051 remote, after a lot of reading I now have =
the
remote partially working as only half of the keys are sending codes to =
&#8220;irw&#8221;<o:p></o:p></p>

<p class=3DMsoNormal>I read this thread and noticed that the exact keys =
which
work are the ones listed with reported codes. <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p =
class=3DMsoNormal>http://www.linuxtv.org/pipermail/linux-dvb/2008-July/02=
7058.html<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>The keys not mentioned in that thread are the ones =
not
working, so I guess the extra codes need to be reported to someone to be =
added
into a new build?<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Can I help in providing these codes and some =
testing.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Thank you.<o:p></o:p></p>

</div>

</body>

</html>

------=_NextPart_000_003A_01CA3350.F746E820--



--===============0226174407==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0226174407==--
