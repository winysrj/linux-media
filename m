Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx-01.fra.se ([194.18.169.41])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <ola.ekedahl@fra.se>) id 1K71km-00014k-Gu
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 07:23:13 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mx-01.fra.se (Postfix) with ESMTP id DC42D5A9CCB
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 07:23:08 +0200 (CEST)
Received: from mx-01.fra.se ([127.0.0.1])
	by localhost (mx-01.fra.se [127.0.0.1]) (amavisd-new, port 10024)
	with SMTP id BQ8H6B+fHtzt for <linux-dvb@linuxtv.org>;
	Fri, 13 Jun 2008 07:23:07 +0200 (CEST)
Received: from masi.fra.se (NAT [194.18.171.253])
	by mx-01.fra.se (Postfix) with ESMTP id 244A45A92F1
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 07:23:07 +0200 (CEST)
Message-ID: <4852042D.8060000@fra.se>
Date: Fri, 13 Jun 2008 07:22:53 +0200
From: Ola Ekedahl <ola.ekedahl@fra.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem compiling
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi everyone!

I just downloaded the latest drivers for DVB-S2 from the CVS and tried
to compile them, but I get errors which I have pasted into this email
further down.
Before I downloaded the latest version I used a version which I
downloaded about half a year ago. They compile without any problem.

And it's actually on the same machine Im trying to compile the new
ones on, so no new or changed hardware or software.

Am I doing something wrong, have I missed something?

best regards
Ola Ekedahl


/home/kurt/Desktop/dvb/multipr
oto/v4l/stb0899_drv.c: In function
'stb0899_diseqc_init':
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:834: warning:
unused variable 'ret_2'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:833: warning:
unused variable 'ret_1'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:832: warning:
unused variable 'trial'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:830: warning:
unused variable 'i'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:830: warning:
unused variable 'count'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:826: warning:
unused variable 'rx_data'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c: In function
'stb0899_sleep':
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:899: warning:
unused variable 'reg'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c: In function
'stb0899_track':
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:1930: warning:
unused variable 'internal'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:1927: warning:
unused variable 'lock_lost'
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c: At top level:
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:1722: warning:
'stb0899_track_carrier' defined but not used
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:1739: warning:
'stb0899_get_ifagc' defined but not used
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:1756: warning:
'stb0899_get_s1fec' defined but not used
/home/kurt/Desktop/dvb/multiproto/v4l/stb0899_drv.c:1784: warning:
'stb0899_get_modcod' defined but not used
CC [M]  /home/kurt/Desktop/dvb/multiproto/v4l/stb0899_algo.o
CC [M]  /home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.o
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c: In function
'stk_isoc_handler':
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:400: warning:
implicit declaration of function 'list_first_entry'
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:401: error:
expected expression before 'struct'
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:401: warning:
assignment makes pointer from integer without a cast
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:448: error:
expected expression before 'struct'
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:448: warning:
assignment makes pointer from integer without a cast
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c: In function 
'v4l_stk_read':
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:778: error:
expected expression before 'struct'
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:778: warning:
assignment makes pointer from integer without a cast
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c: In function
'stk_vidioc_dqbuf':
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:1251: error:
expected expression before 'struct'
/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.c:1251: warning:
assignment makes pointer from integer without a cast
make[3]: *** [/home/kurt/Desktop/dvb/multiproto/v4l/stk-webcam.o] Error 1
make[2]: *** [_module_/home/kurt/Desktop/dvb/multiproto/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.21-1.3194.fc7-i686'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/kurt/Desktop/dvb/multiproto/v4l'
make: *** [all] Error 2

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
