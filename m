Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <sakthisam@gmail.com>) id 1SlAR7-0004uL-KR
	for linux-dvb@linuxtv.org; Sun, 01 Jul 2012 05:03:22 +0200
Received: from mail-lb0-f182.google.com ([209.85.217.182])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1SlAR7-0001Iy-EU; Sun, 01 Jul 2012 05:02:57 +0200
Received: by lbon10 with SMTP id n10so6185946lbo.41
	for <linux-dvb@linuxtv.org>; Sat, 30 Jun 2012 20:02:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEEcfUdajeerSxO0woq_cd+XTFSVjHiob=7ab1vL5dnXXV0Fsw@mail.gmail.com>
References: <CAEEcfUdajeerSxO0woq_cd+XTFSVjHiob=7ab1vL5dnXXV0Fsw@mail.gmail.com>
Date: Sun, 1 Jul 2012 08:32:57 +0530
Message-ID: <CAEEcfUdaZz5OBq55yKG9M_RKaRp5DQyzonMT=8Fjy2PmQ2rfMA@mail.gmail.com>
From: sam <sakthisam@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] PCR Error rectification on MP2TS using Mplex iso13818
	or Replex
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1131625246=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1131625246==
Content-Type: multipart/alternative; boundary=bcaec552420612e3b804c3bbebf5

--bcaec552420612e3b804c3bbebf5
Content-Type: text/plain; charset=ISO-8859-1

*Hi all,

*
* i am using Opensource Multiplxer / Remultiplexer Software iso13818
specification , Name of the software is mplex (note: there are two mplex
most of them confusing i mean
www.scara.com/~schirmer/o/mplex13818<http://www.scara.com/%7Eschirmer/o/mplex13818>
  iso13818 , you can find this in linuxtv.org or else google it) now i
found pcr error after multiplexing mpeg 2 ts and data which is stored in
same place means i am not using ip encapsulator to transfer.So here is my
query.*
*
I want to find good solution for PCR Error Rectification in DVB
Multiplexing or Mpeg Multiplexing using mplex iso13818 can anyone support
for this or else irc chat service .*

*let me tell my scenario: i have h/w encoder which produce 4 TS and which
contain 8 programs , now my case is need to remux or mux or rejoin multiple
ts into single ts mp2ts,which tools can you suggest that too it should work
realtime ,remplex , mplex iso13818, opencaster else someother.?

if you want to see screenshot or else remote login for debug my issue ,i
can send , i hope you can help me out.thank you advance.waiting for reply.
*

*
-- 
Regards
sam*

--bcaec552420612e3b804c3bbebf5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><i><b>Hi all,</b><br><br></i><div><i> i am using=
 Opensource Multiplxer / Remultiplexer Software iso13818 specification , Na=
me of the software is <b>mplex</b> (note: there are two mplex most of them =
confusing i mean <cite><a href=3D"http://www.scara.com/%7Eschirmer/o/mplex1=
3818" target=3D"_blank">www.scara.com/~schirmer/o/<b>mplex</b>13818</a>=A0<=
/cite> iso13818 , you can find this in <a href=3D"http://linuxtv.org" targe=
t=3D"_blank">linuxtv.org</a>
 or else google it) now i found pcr error after multiplexing mpeg 2 ts=20
and data which is stored in same place means i am not using ip=20
encapsulator to transfer.So here is my query.</i><div><i><br><b>I want to f=
ind good solution for=20
PCR Error Rectification in DVB Multiplexing or Mpeg Multiplexing using=20
mplex iso13818 can anyone support for this or else irc chat service .</b></=
i>



</div></div><div><br><i><font color=3D"#000000"><b style=3D"color:rgb(255,0=
,0)"><u style=3D"color:rgb(153,0,0)">let
 me tell my scenario: </u><span style=3D"color:rgb(255,102,0)">i have h/w e=
ncoder which produce 4 TS and which=20
contain 8 programs , now my case is need to remux or mux or rejoin=20
multiple ts into single ts mp2ts,which tools can you suggest that too it sh=
ould work realtime ,remplex ,=20
mplex iso13818, opencaster else someother.?<br><br></span></b><div>
if you want to see screenshot or else remote login for debug my=20
issue ,i can send , i hope you can help me out.thank you advance.waiting
 for reply.</div></font></i></div><span class=3D"HOEnZb"></span><br></div><=
i><br>-- <br>Regards<br>sam</i><br>

--bcaec552420612e3b804c3bbebf5--


--===============1131625246==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1131625246==--
