Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eir.is.scarlet.be ([193.74.71.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alain@satfans.be>) id 1KMgvU-0003sR-Sx
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 12:23:02 +0200
Received: from multimedia2005 (ip-81-11-213-112.dsl.scarlet.be [81.11.213.112])
	by eir.is.scarlet.be (8.14.2/8.14.2) with ESMTP id m6QAMu4G003721
	for <linux-dvb@linuxtv.org>; Sat, 26 Jul 2008 12:22:56 +0200
Message-Id: <200807261022.m6QAMu4G003721@eir.is.scarlet.be>
From: "Alain Satfans" <alain@satfans.be>
To: <linux-dvb@linuxtv.org>
Date: Sat, 26 Jul 2008 12:22:57 +0200
MIME-Version: 1.0
Subject: Re: [linux-dvb] Technotrend 3650 and Ubuntu Heron
Reply-To: alain@satfans.be
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0208461131=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0208461131==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0000_01C8EF1A.577B0F90"

This is a multi-part message in MIME format.

------=_NextPart_000_0000_01C8EF1A.577B0F90
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks Dominik

 

this is what the end of the answer gives, or do you need more. 

Thanks. 

  

22, running e2fsck is recomended 

[ 4138,716183] dvb_pll: Unknown symbol 12c_transfer 

[ 4508,603967] dvb_pll: Unknown symbol 12c_transfer 

[ 4861,755297] dvb_pll: Unknown symbol 12c_transfer 

  

I still  don't know how to answer on these mailing lists. 

Can't this be done in a board? 

 Thanks 

  

Alain 

 

Message: 5

Date: Wed, 23 Jul 2008 14:53:19 +0200

From: Dominik Kuhlen <dkuhlen@gmx.net>

Subject: Re: [linux-dvb] Technotrend 3650 and Ubuntu Heron

To: linux-dvb@linuxtv.org

Message-ID: <200807231453.19124.dkuhlen@gmx.net>

Content-Type: text/plain; charset="utf-8"

 

Hi, 

On Wednesday 23 July 2008, alain@satfans.be wrote:

> 

>  So that_s where I am now.  

> 

>  Anyone a last tip before I give up Linux?  

>  lsmod | grep dvb

>  shows there are no modules running (that is what he asks you about)

>  the drivers are compiled on:

>  /home/alain/3650/multiproto/

>  from there I do make install 

>  and it seems to work..

>   insmod dvb-core.ko    works....

>  insmod dvb-pll.ko  doen't work (and with lsmod I have proved it is

> not already loaded somehow)

>  root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-core.ko 

>  root@TELEVISION:~/3650/multiproto/v4l# lsmod | grep dvb

>  dvb_core               89212  0 

>  root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-pll.ko 

>  insmod: error inserting './dvb-pll.ko': -1 Unknown symbol in module 

type 

dmesg 

to get the unknown symbol name. 

this normally leads to the required module.

 

---snip--

 

Dominik

-------------- next part --------------

 


------=_NextPart_000_0000_01C8EF1A.577B0F90
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p
	{mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 70.85pt 70.85pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DFR link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>Thanks =
Dominik<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
lang=3DEN-GB
style=3D'font-size:12.0pt'>this is what the end of the answer gives, or =
do you
need more. <o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>Thanks. <o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>&nbsp; <o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>22,
running e2fsck is recomended <o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>[
4138,716183] dvb_pll: Unknown symbol 12c_transfer =
<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>[
4508,603967] dvb_pll: Unknown symbol 12c_transfer =
<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>[
4861,755297] dvb_pll: Unknown symbol 12c_transfer =
<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>&nbsp;
<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>I
still&nbsp; don't know how to answer on these mailing lists. =
<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>Can't
this be done in a board? <o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>&nbsp;</span>Thanks
<o:p></o:p></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>&nbsp; <o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>Alain <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Message: 5<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>Date: =
Wed, 23 Jul
2008 14:53:19 +0200<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>From: =
Dominik
Kuhlen &lt;dkuhlen@gmx.net&gt;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Subject: Re:
[linux-dvb] Technotrend 3650 and Ubuntu =
Heron<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>To:
linux-dvb@linuxtv.org<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Message-ID:
&lt;200807231453.19124.dkuhlen@gmx.net&gt;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Content-Type:
text/plain; charset=3D&quot;utf-8&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>Hi, =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>On =
Wednesday 23
July 2008, alain@satfans.be wrote:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DFR-BE style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt; =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; So that_s
where I am now.&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt; =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; Anyone a
last tip before I give up Linux?&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; lsmod |
grep dvb<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; shows there
are no modules running (that is what he asks you =
about)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; the drivers
are compiled on:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp;
/home/alain/3650/multiproto/<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; from there
I do make install <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; and it
seems to work..<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp;&nbsp; insmod
dvb-core.ko&nbsp;&nbsp;&nbsp; works....<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; insmod
dvb-pll.ko&nbsp; doen't work (and with lsmod I have proved it =
is<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt; =
not already
loaded somehow)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp;
root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-core.ko =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp;
root@TELEVISION:~/3650/multiproto/v4l# lsmod | grep =
dvb<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp;
dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 89212&nbsp; 0 <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp;
root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-pll.ko =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'>&gt;&nbsp; insmod: error
inserting './dvb-pll.ko': -1 Unknown symbol in module =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>type =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>dmesg =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>to get =
the
unknown symbol name. <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier New"'>this =
normally
leads to the required module.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DFR-BE style=3D'font-size:10.0pt;font-family:"Courier =
New"'>---snip--<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DFR-BE style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DFR-BE style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Dominik<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span
lang=3DFR-BE style=3D'font-size:10.0pt;font-family:"Courier =
New"'>--------------
next part --------------<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_0000_01C8EF1A.577B0F90--



--===============0208461131==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0208461131==--
