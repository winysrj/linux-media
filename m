Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tstrelar@gmail.com>) id 1NEW7N-0007fl-G3
	for linux-dvb@linuxtv.org; Sat, 28 Nov 2009 23:50:18 +0100
Received: by ey-out-2122.google.com with SMTP id 9so675248eyd.39
	for <linux-dvb@linuxtv.org>; Sat, 28 Nov 2009 14:50:13 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 28 Nov 2009 23:50:13 +0100
Message-ID: <355c45860911281450g70094174u7805884d669dd5ea@mail.gmail.com>
From: Tomislav Strelar <tstrelar@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Build fails when compiling dvb_frontend.c
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hello everyone.

I am trying to build v4l-dvb device drivers according to instruction
on linuxTV wiki
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

but it fails when compiling dvb_frontend.c

This is what I get:

/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l/dvb_frontend.c: In
function 'dvb_frontend_stop':
/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l/dvb_frontend.c:707: error:
implicit declaration of function 'init_MUTEX'
make[3]: *** [/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l/dvb_frontend.o]
Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-9-rt'

Kerner version is
Linux version 2.6.31-9-rt (buildd@yellow) (gcc version 4.4.1 (Ubuntu
4.4.1-4ubuntu8) ) #152-Ubuntu SMP PREEMPT RT Thu Oct 15 13:22:24 UTC
2009


I've searched everywhere, and I haven't find similar problem. Can
someone give me a hint what am I doing wrong. And just to say, I'm far
from being a linux expert. :)

Thank you,
Tomislav

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
