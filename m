Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <funihao@gmail.com>) id 1L2ukc-0004JL-BX
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 22:38:20 +0100
Received: by gv-out-0910.google.com with SMTP id n29so101496gve.16
	for <linux-dvb@linuxtv.org>; Wed, 19 Nov 2008 13:38:14 -0800 (PST)
Message-ID: <9382b27d0811191338n7f4f9cf4ie6e807e426332e51@mail.gmail.com>
Date: Wed, 19 Nov 2008 22:38:13 +0100
From: "=?ISO-8859-1?Q?Jos=E9_Jes=FAs_Palacios_Rodr=EDguez?="
	<funihao@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] HVR-3000 on Ubuntu 8.10
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0580566864=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0580566864==
Content-Type: multipart/alternative;
	boundary="----=_Part_84000_7389713.1227130694044"

------=_Part_84000_7389713.1227130694044
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello folks,

I'm try to run my HVR-3000 on Ubuntu 8.10 and I follow the wiki page
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-3000 about Steve
Toth's repository.

My kernel and ...
Linux version 2.6.27-7-generic (buildd@palmer) (gcc version 4.3.2 (Ubuntu
4.3.2-1ubuntu11) )
#1 SMP Tue Nov 4 19:33:20 UTC 2008 (Ubuntu 2.6.27-7.16-generic)

It is producing a warning and one error when I try to "make".

Here, they are:

  CC [M]  /usr/src/v4l-dvb/v4l/cx18-driver.o
/usr/src/v4l-dvb/v4l/cx18-driver.c: In function 'cx18_request_module':
/usr/src/v4l-dvb/v4l/cx18-driver.c:549: warning: format not a string literal
and no format arguments
.............................................................................................................
  CC [M]  /usr/src/v4l-dvb/v4l/cx23885-cards.o
In file included from /usr/src/v4l-dvb/v4l/cx23885-cards.c:29:
/usr/src/v4l-dvb/v4l/cx23885.h:227: error: field 'frontends' has incomplete
type
make[3]: *** [/usr/src/v4l-dvb/v4l/cx23885-cards.o] Error 1
make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic'

Some help, if it's possible.

Thanks to everybody ....
JJ

------=_Part_84000_7389713.1227130694044
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello folks,<br><br>I&#39;m try to run my HVR-3000 on Ubuntu 8.10 and I follow the wiki page <a href="http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-3000">http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-3000</a> about Steve Toth&#39;s repository.<br>
<br>My kernel and ... <br>Linux version 2.6.27-7-generic (buildd@palmer) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) <br>#1 SMP Tue Nov 4 19:33:20 UTC 2008 (Ubuntu 2.6.27-7.16-generic)<br><br>It is producing a warning and one error when I try to &quot;make&quot;.<br>
<br>Here, they are:<br><br>&nbsp; CC [M]&nbsp; /usr/src/v4l-dvb/v4l/cx18-driver.o<br>/usr/src/v4l-dvb/v4l/cx18-driver.c: In function &#39;cx18_request_module&#39;:<br>/usr/src/v4l-dvb/v4l/cx18-driver.c:549: warning: format not a string literal and no format arguments<br>
.............................................................................................................<br>&nbsp; CC [M]&nbsp; /usr/src/v4l-dvb/v4l/cx23885-cards.o<br>In file included from /usr/src/v4l-dvb/v4l/cx23885-cards.c:29:<br>
/usr/src/v4l-dvb/v4l/cx23885.h:227: error: field &#39;frontends&#39; has incomplete type<br>make[3]: *** [/usr/src/v4l-dvb/v4l/cx23885-cards.o] Error 1<br>make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2<br>make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic&#39;<br>
<br>Some help, if it&#39;s possible.<br><br>Thanks to everybody ....<br>JJ<br>

------=_Part_84000_7389713.1227130694044--


--===============0580566864==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0580566864==--
