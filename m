Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mxout1.netvision.net.il ([194.90.9.20])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <gennady@exatel-vs.com>) id 1Mno0N-0004Bc-1J
	for linux-dvb@linuxtv.org; Wed, 16 Sep 2009 08:28:39 +0200
Received: from Nissim ([212.143.127.51]) by mxout1.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTPA id <0KQ100BSYWMRB470@mxout1.netvision.net.il> for
	linux-dvb@linuxtv.org; Wed, 16 Sep 2009 09:28:03 +0300 (IDT)
Date: Wed, 16 Sep 2009 09:28:14 +0300
From: gennady <gennady@exatel-vs.com>
To: linux-dvb@linuxtv.org
Message-id: <C0EA3D8EE7E94C01A6FF929034F088C1@exatelvs.com>
MIME-version: 1.0
Subject: [linux-dvb] The Tuner stv6110x.c driver problem.
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0456336180=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0456336180==
Content-type: multipart/alternative;
 boundary="Boundary_(ID_TjinkK+afwJvCwEPHmZlbA)"

This is a multi-part message in MIME format.

--Boundary_(ID_TjinkK+afwJvCwEPHmZlbA)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT

Hi!

My stv6110a tuner doesn't work.

I see that there is problem with the divider calculation.

 

The code gets the same value = 3 in any case:

 

for (rDiv = 0; rDiv <= 3; rDiv++) 

 {

             pCalc = (REFCLOCK_kHz / 100) / R_DIV(rDiv);

 

             if ((abs((s32)(pCalc - pVal))) < (abs((s32)(1000 - pVal))))

             {

                        rDivOpt = rDiv;

             }

}

 

As result is the wrong divider value.

 

Is this driver working?

 

 

Gennady.

 

gennady@exatel-vs.com

 

 


--Boundary_(ID_TjinkK+afwJvCwEPHmZlbA)
Content-type: text/html; charset=us-ascii
Content-transfer-encoding: 7BIT

<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=us-ascii">
<meta name=Generator content="Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=EN-US link=blue vlink=purple>

<div class=Section1>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Hi!<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>My stv6110a tuner doesn&#8217;t work.<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>I see that there is problem with the divider calculation.<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>The code gets the same value = 3 in any case:<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>for (rDiv = 0; rDiv &lt;= 3; rDiv++) <o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;{<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;pCalc
= (REFCLOCK_kHz / 100) / R_DIV(rDiv);<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;if
((abs((s32)(pCalc - pVal))) &lt; (abs((s32)(1000 - pVal))))<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;{<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rDivOpt
= rDiv;<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;}<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>As result is the wrong divider value.<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Is this driver working?<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>Gennady.<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'>gennady@exatel-vs.com<o:p></o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=MsoNormal><font size=2 face=Arial><span style='font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

--Boundary_(ID_TjinkK+afwJvCwEPHmZlbA)--


--===============0456336180==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0456336180==--
