Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <alain@satfans.be>) id 1KJqE5-00089O-Bv
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 15:42:28 +0200
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Fri, 18 Jul 2008 15:42:21 +0200
From: <alain@satfans.be>
Message-ID: <78fbccd765c111c5f53504a4f5b1fc45@localhost>
Subject: [linux-dvb] Technotrend TT3650 S2 USB and multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0655244683=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0655244683==
Content-Type: multipart/alternative;
	boundary="=_0c9111dc9615ed8a149ee68f862b46de"


--=_0c9111dc9615ed8a149ee68f862b46de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit



 Hi,
 I'm trying to use my DVB S2 USB with Ubuntu8.04 and MyTheatre.
 I found an how to
[url]http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI[/url]

 But I get stuck with the fail of the make.
 It claims about the audio driver?
 [QUOTE]make[2]: Entering directory
`/usr/src/linux-headers-2.6.24-19-generic'
   CC [M]  /home/alain/3650/multiproto/v4l/em28xx-audio.o
 In file included from
/home/alain/3650/multiproto/v4l/em28xx-audio.c:39:
 include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not
in a function)
 /home/alain/3650/multiproto/v4l/em28xx-audio.c:58: error: array
index in initializer not of integer type
 /home/alain/3650/multiproto/v4l/em28xx-audio.c:58: error: (near
initialization for 'index')
 make[3]: *** [/home/alain/3650/multiproto/v4l/em28xx-audio.o] Error
1
 [/QUOTE]
 Did someone succeed?
 I suppose it's due to the constant changing of the multiproto drive?
 Hope someone have a solution or I will have to forget Linux and
decide that

it still can't replace Windows.  

 Thanks.  
--=_0c9111dc9615ed8a149ee68f862b46de
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<p>
Hi,<br />
<br />
I'm trying to use my DVB S2 USB with Ubuntu8.04 and MyTheatre.<br />
I found an how to [url]http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT=
-connect_S2-3650_CI[/url] <br />
But I get stuck with the fail of the make.<br />
It claims about the audio driver?<br />
[QUOTE]make[2]: Entering directory `/usr/src/linux-headers-2.6.24-19-generi=
c'<br />
&nbsp; CC [M]&nbsp; /home/alain/3650/multiproto/v4l/em28xx-audio.o<br />
In file included from /home/alain/3650/multiproto/v4l/em28xx-audio.c:39:<br=
 />
include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a fu=
nction)<br />
/home/alain/3650/multiproto/v4l/em28xx-audio.c:58: error: array index in in=
itializer not of integer type<br />
/home/alain/3650/multiproto/v4l/em28xx-audio.c:58: error: (near initializat=
ion for 'index')<br />
make[3]: *** [/home/alain/3650/multiproto/v4l/em28xx-audio.o] Error 1<br />
[/QUOTE]<br />
<br />
Did someone succeed?<br />
I suppose it's due to the constant changing of the multiproto drive?<br />
<br />
Hope someone have a solution or I will have to forget Linux and decide that=
 it still can't replace Windows.
</p>
<p>
Thanks.=20
</p>

--=_0c9111dc9615ed8a149ee68f862b46de--




--===============0655244683==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0655244683==--
