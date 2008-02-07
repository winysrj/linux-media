Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from web57805.mail.re3.yahoo.com ([68.142.236.83])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ar.saikia@yahoo.com>) id 1JN2xy-0002ME-GJ
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 10:22:46 +0100
Date: Thu, 7 Feb 2008 01:22:13 -0800 (PST)
From: ashim saikia <ar.saikia@yahoo.com>
To: Linux Forum 4 Dvb <linux-dvb@linuxtv.org>,
	Linux-dvb-CityK <CityK@rogers.com>,
	Linux-dvb-Jean-Claude Repetto <jrepetto@free.fr>
MIME-Version: 1.0
Message-ID: <459889.81141.qm@web57805.mail.re3.yahoo.com>
Subject: [linux-dvb] BUG in linuxtv-dvb-1.1.1/build2.6/make.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1814649756=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1814649756==
Content-Type: multipart/alternative; boundary="0-1247186421-1202376133=:81141"

--0-1247186421-1202376133=:81141
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I have obtained a linuxtv-dvb-1.1.1.tar.bz2 source and tried to compile the=
 source files in linuxtv-dvb-1.1.1/build2.6/.=0AExecuting make gives the fo=
llowing error:-=0A=0A/linuxtv-dvb-1.1.1/build-2.6/dvbdev.c:384: error: expe=
cted =E2)=E2 before string constant=0Amake[2]: *** [/linuxtv-dvb-1.1.1/buil=
d-2.6/dvbdev.o] Error 1=0Amake[1]: *** [/linuxtv-dvb-1.1.1/build-2.6] Error=
 2=0Amake[1]: Leaving directory `/usr/src/linux-headers-2.6.20-15-generic'=
=0Amake: *** [all] Error 2=0A=0AI have come to know that this error is due =
to the use of macro MODULE_PARM (e.g. MODULE_PARM (dvbdev_debug,"i") in dvb=
dev.c line no 386)in many of the files.=0A=0ACan anybody there to help me o=
ut. What I need to do to recitify the problem.=0A=0ARegards=0A=0A=0A=0A=0A=
=0A=0A      _______________________________________________________________=
_____________________=0ALooking for last minute shopping deals?  =0AFind th=
em fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/catego=
ry.php?category=3Dshopping
--0-1247186421-1202376133=:81141
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman, new york, times, serif;=
font-size:12pt">I have obtained a linuxtv-dvb-1.1.1.tar.bz2 source and trie=
d to compile the source files in linuxtv-dvb-1.1.1/build2.6/.<br>Executing =
make gives the following error:-<br><br>/linuxtv-dvb-1.1.1/build-2.6/dvbdev=
.c:384: error: expected =E2)=E2 before string constant<br>make[2]: *** [/li=
nuxtv-dvb-1.1.1/build-2.6/dvbdev.o] Error 1<br>make[1]: *** [/linuxtv-dvb-1=
.1.1/build-2.6] Error 2<br>make[1]: Leaving directory `/usr/src/linux-heade=
rs-2.6.20-15-generic'<br>make: *** [all] Error 2<br><br>I have come to know=
 that this error is due to the use of macro MODULE_PARM (e.g. MODULE_PARM (=
dvbdev_debug,"i") in dvbdev.c line no 386)in many of the files.<br><br>Can =
anybody there to help me out. What I need to do to recitify the problem.<br=
><br>Regards<br><br><br><br></div><br>=0A      <hr size=3D1>Be a better fri=
end, newshound, and =0Aknow-it-all with Yahoo! Mobile. <a href=3D"http://us=
.rd.yahoo.com/evt=3D51733/*http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDy=
pao8Wcj9tAcJ "> Try it now.</a></body></html>
--0-1247186421-1202376133=:81141--


--===============1814649756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1814649756==--
