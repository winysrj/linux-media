Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KtqTQ-0003aY-Ku
	for linux-dvb@linuxtv.org; Sat, 25 Oct 2008 23:15:06 +0200
From: Darron Broad <darron@kewl.org>
To: Francesco Fumanti <francesco.fumanti@gmx.net>
In-reply-to: <49038A28.4040601@gmx.net> 
References: <49038A28.4040601@gmx.net>
Date: Sat, 25 Oct 2008 22:15:01 +0100
Message-ID: <19118.1224969301@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] kaffeine s2api v2 patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <49038A28.4040601@gmx.net>, Francesco Fumanti wrote:
>Hello,

Hi Francesco.

>Did anybody succeed to compile kaffeine from svn with the s2api patch on 
>Ubuntu 8.10 (not Kubuntu) ?
>
>I have been using the instructions on http://kaffeine.kde.org/?q=devel 
>but I get the following error:
>make[6]: Entering directory 
>`/home/frafu/kaffeine-svn/kaffeine/src/input/dvb'
>/bin/bash ../../../../libtool --silent --tag=CXX   --mode=compile g++ 
>-DHAVE_CONFIG_H -I. -I../../../.. -I../../../../kaffeine/src/input/ 
>-I../../../../kaffeine/src/input/dvb/lib 
>-I../../../../kaffeine/src/input/dvb/plugins/stream 
>-I../../../../kaffeine/src/input/dvb/plugins/epg 
>-I../../../../kaffeine/src -I/usr/include/kde -I/usr/share/qt3/include 
>-I.   -DQT_THREAD_SUPPORT  -D_REENTRANT  -Wno-long-long -Wundef -ansi 
>-D_XOPEN_SOURCE=500 -D_BSD_SOURCE -Wcast-align -Wchar-subscripts -Wall 
>-W -Wpointer-arith -O2 -Wformat-security -Wmissing-format-attribute 
>-Wno-non-virtual-dtor -fno-exceptions -fno-check-new -fno-common 
>-DQT_CLEAN_NAMESPACE -DQT_NO_ASCII_CAST -DQT_NO_STL -DQT_NO_COMPAT 
>-DQT_NO_TRANSLATION  -MT audioeditor.lo -MD -MP -MF 
>.deps/audioeditor.Tpo -c -o audioeditor.lo audioeditor.cpp
>In file included from audioeditor.h:24,
>                  from audioeditor.cpp:30:
>channeldesc.h:104: error: 'fe_rolloff_t' does not name a type
>make[6]: *** [audioeditor.lo] Error 1
>make[6]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src/input/dvb'
>make[5]: *** [all-recursive] Error 1
>make[5]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src/input/dvb'
>make[4]: *** [all-recursive] Error 1
>make[4]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src/input'
>make[3]: *** [all-recursive] Error 1
>make[3]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src'
>make[2]: *** [all-recursive] Error 1
>make[2]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine'
>make[1]: *** [all-recursive] Error 1
>make[1]: Leaving directory `/home/frafu/kaffeine-svn'
>make: *** [all] Error 2
>
>You might perhaps also want to know that the application of the patch 
>worked without error.

You need to update frontend.h in /usr/include/linux/dvb/

eg.

mv /usr/include/linux/dvb/frontend.h /usr/include/linux/dvb/frontend.h.bak
cp /???/v4l-dvb/linux/include/linux/dvb/frontend.h /usr/include/linux/dvb/frontend.h

Then recompile. Obviously replace ??? with the path to your v4l-dvb source
files.

Good luck.

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
