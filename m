Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <armbaia@gmail.com>) id 1OyBJW-000602-Mn
	for linux-dvb@linuxtv.org; Wed, 22 Sep 2010 00:27:50 +0200
Received: from mail-qy0-f182.google.com ([209.85.216.182])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OyBJW-0007nQ-0U; Wed, 22 Sep 2010 00:27:50 +0200
Received: by qyk4 with SMTP id 4so7033217qyk.20
	for <linux-dvb@linuxtv.org>; Tue, 21 Sep 2010 15:27:47 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 Sep 2010 23:27:46 +0100
Message-ID: <AANLkTi=AmAr8axyR7mr0SZftSAFeTDRo1KrSbdoX06jn@mail.gmail.com>
From: Baia Armando <armbaia@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Scan-s2
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1235458059=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1235458059==
Content-Type: multipart/alternative; boundary=e0cb4e887b1bd0edca0490cc89bc

--e0cb4e887b1bd0edca0490cc89bc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

I do not speak English! This text was translated by google!
For some time I had problems with my s card Technotrend dvb-32000! Channels
did not open or scan the frequencies with Symbolrate <5000! This problem wa=
s
solved with the drivers s2-liplianin opensue + 11.1 + kernel
2.6.27.7-9-default! The problem, in my ignorance has to do with the fronten=
d
stb0899_drv.c of v4l-dvb or the current kernels, which do not recognize
Symbolrate <5000. The frontend stb0899_drv.c offered by the drivers for
s2-liplianin allow the scan to Symbolrate,> =3D 1000!
Now, another problem arose I install the scan-s2

linux-syaw:/usr/src/scan-s2 # make
gcc -I../s2/linux/include -c atsc_psip_section.c -o atsc_psip_section.o
gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
In file included from diseqc.c:7:
scan.h:91: error: expected specifier-qualifier-list before =91fe_rolloff_t=
=92
make: *** [diseqc.o] Error 1
linux-syaw:/usr/src/scan-s2 #


What is this error? Thank you.

--=20
Tanto leio a National Geografic como folheio a Plaiboy ambas me mostram
paisagens que doutra forma nunca visitaria!

--e0cb4e887b1bd0edca0490cc89bc
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

<span id=3D"result_box" class=3D"long_text"><span style=3D"background-color=
: rgb(255, 255, 255);" title=3D"">I do not speak English! </span><span titl=
e=3D"">This text was translated by google!<br></span><span style=3D"backgro=
und-color: rgb(255, 255, 255);" title=3D"">For some time I had problems wit=
h my s card Technotrend dvb-32000! </span><span style=3D"" title=3D"">Chann=
els did not open or scan the frequencies with Symbolrate &lt;5000! </span><=
span title=3D"">This problem was solved with the drivers s2-liplianin opens=
ue + 11.1 + kernel 2.6.27.7-9-default! </span><span style=3D"background-col=
or: rgb(255, 255, 255);" title=3D"">The
problem, in my ignorance has to do with the frontend stb0899_drv.c of
v4l-dvb or the current kernels, which do not recognize Symbolrate
&lt;5000. </span><span style=3D"background-color: rgb(255, 255, 255);" titl=
e=3D"">The frontend stb0899_drv.c offered by the drivers for s2-liplianin a=
llow the scan to Symbolrate,&gt; =3D 1000!<br></span><span style=3D"backgro=
und-color: rgb(255, 255, 255);" title=3D"">Now, another problem arose I ins=
tall the scan-s2<br>
<br>linux-syaw:/usr/src/scan-s2 # make<br>gcc -I../s2/linux/include -c atsc=
_psip_section.c -o atsc_psip_section.o<br>gcc -I../s2/linux/include -c dise=
qc.c -o diseqc.o<br>In file included from diseqc.c:7:<br>scan.h:91: error: =
expected specifier-qualifier-list before =91fe_rolloff_t=92<br>
make: *** [diseqc.o] Error 1<br>linux-syaw:/usr/src/scan-s2 #<br><br></span=
></span><span id=3D"result_box" class=3D"long_text"><span title=3D""><br></=
span><span style=3D"" title=3D"">What is this error? </span><span style=3D"=
" title=3D"">Thank you.</span></span><br clear=3D"all">
<br>-- <br>Tanto leio a National Geografic como folheio a Plaiboy ambas me =
mostram paisagens que doutra forma nunca visitaria!<br>

--e0cb4e887b1bd0edca0490cc89bc--


--===============1235458059==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1235458059==--
