Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <ashley.fry@ge.com>) id 1Vldgd-0000cd-Fm
	for linux-dvb@linuxtv.org; Wed, 27 Nov 2013 12:53:46 +0100
Received: from exprod5og109.obsmtp.com ([64.18.0.188])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-5) with smtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1Vldgb-0007ga-7M; Wed, 27 Nov 2013 12:53:43 +0100
From: "Fry, Ashley (GE Intelligent Platforms)" <ashley.fry@ge.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Wed, 27 Nov 2013 11:53:33 +0000
Message-ID: <5E7BEC406408D249B00BF3A73A0A36DF1071F847@LONURLNA02.e2k.ad.ge.com>
Content-Language: en-US
MIME-Version: 1.0
Subject: [linux-dvb] Unknown symbol altera_init (err -22)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1977379724=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1977379724==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_5E7BEC406408D249B00BF3A73A0A36DF1071F847LONURLNA02e2kad_"

--_000_5E7BEC406408D249B00BF3A73A0A36DF1071F847LONURLNA02e2kad_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I have retrieved the latest by

sudo git clone git://linuxtv.org/media_build.git

cd media_build

sudo ./build


This build ok and installs but the driver does not load correctly, I get :-


[    9.607094] cx23885: disagrees about version of symbol altera_init

[    9.607099] cx23885: Unknown symbol altera_init (err -22)

afry@ubtest:~$ dmesg | grep cx23885

[    9.607094] cx23885: disagrees about version of symbol altera_init

[    9.607099] cx23885: Unknown symbol altera_init (err -22)

I have search for a solution but have not found one yet.
What's strange the issue appears to have been around for nearly 2 years,
see this post...  https://linuxtv.org/patch/8068/

I have tried the patch as described in  https://linuxtv.org/patch/8068/ and=
 it no longer works.....

Thinking maybe this patch never got pulled,

Be grateful if someone could help me, solve this issue

Thx,

Ash.





--_000_5E7BEC406408D249B00BF3A73A0A36DF1071F847LONURLNA02e2kad_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";
	mso-fareast-language:EN-GB;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-GB" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Hi, <o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
I have retrieved the latest by<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;Co=
urier New&quot;;mso-fareast-language:EN-GB">sudo git clone git://linuxtv.or=
g/media_build.git<o:p></o:p></span></p>
<pre>cd media_build<o:p></o:p></pre>
<pre>sudo ./build<o:p></o:p></pre>
<pre><o:p>&nbsp;</o:p></pre>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
This build ok and installs but the driver does not load correctly, I get :-=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<pre>[&nbsp;&nbsp;&nbsp; 9.607094] cx23885: disagrees about version of symb=
ol altera_init<o:p></o:p></pre>
<pre>[&nbsp;&nbsp;&nbsp; 9.607099] cx23885: Unknown symbol altera_init (err=
 -22)<o:p></o:p></pre>
<pre>afry@ubtest:~$ dmesg | grep cx23885<o:p></o:p></pre>
<pre>[&nbsp;&nbsp;&nbsp; 9.607094] cx23885: disagrees about version of symb=
ol altera_init<o:p></o:p></pre>
<pre>[&nbsp;&nbsp;&nbsp; 9.607099] cx23885: Unknown symbol altera_init (err=
 -22)<o:p></o:p></pre>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
I have search for a solution but have not found one yet.<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
What&#8217;s strange the issue appears to have been around for nearly 2 yea=
rs,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
see this post&#8230; &nbsp;<a href=3D"https://linuxtv.org/patch/8068/">http=
s://linuxtv.org/patch/8068/</a><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
I have tried the patch as described in &nbsp;<a href=3D"https://linuxtv.org=
/patch/8068/">https://linuxtv.org/patch/8068/</a> and it no longer works&#8=
230;..<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Thinking maybe this patch never got pulled,
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Be grateful if someone could help me, solve this issue<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Thx,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
Ash.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;">=
<o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_5E7BEC406408D249B00BF3A73A0A36DF1071F847LONURLNA02e2kad_--


--===============1977379724==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1977379724==--
