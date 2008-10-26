Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <francesco.fumanti@gmx.net>) id 1KuC0k-0002SF-95
	for linux-dvb@linuxtv.org; Sun, 26 Oct 2008 21:14:55 +0100
Message-ID: <4904CF95.9030703@gmx.net>
Date: Sun, 26 Oct 2008 21:14:13 +0100
From: Francesco Fumanti <francesco.fumanti@gmx.net>
MIME-Version: 1.0
To: Darron Broad <darron@kewl.org>
References: <49038A28.4040601@gmx.net> <19118.1224969301@kewl.org>
In-Reply-To: <19118.1224969301@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] kaffeine s2api v2 patch
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

Hello Darron,


I followed your instructions below which solved the compilation problem 
and I was able to compile and install kaffeine. Thanks.

A new scan found also the dvb-s2 channels (Anixe HD, Simul HD,...).

When I try to watch them, there are a lot of artifacts and picture 
hangers which is surely normal for a Pentium 4 and a nvidia 6610 XL.

However, kaffeine also crashes when watching hd content and in the last 
lines in the terminal (I launched it from terminal to have feedback), 
there is a "Internal error: picture buffer overflow".

As the crashes did not occur during channel switches, but while watching 
hd content, I suppose that the problem is rather due to xine than to the 
s2api patch.


Cheers,

Francesco


Darron Broad wrote:
> In message <49038A28.4040601@gmx.net>, Francesco Fumanti wrote:
>> Hello,
> 
> Hi Francesco.
> 
>> Did anybody succeed to compile kaffeine from svn with the s2api patch on 
>> Ubuntu 8.10 (not Kubuntu) ?
>>
>> I have been using the instructions on http://kaffeine.kde.org/?q=devel 
>> but I get the following error:
>> make[6]: Entering directory 
>> `/home/frafu/kaffeine-svn/kaffeine/src/input/dvb'
>> /bin/bash ../../../../libtool --silent --tag=CXX   --mode=compile g++ 
>> -DHAVE_CONFIG_H -I. -I../../../.. -I../../../../kaffeine/src/input/ 
>> -I../../../../kaffeine/src/input/dvb/lib 
>> -I../../../../kaffeine/src/input/dvb/plugins/stream 
>> -I../../../../kaffeine/src/input/dvb/plugins/epg 
>> -I../../../../kaffeine/src -I/usr/include/kde -I/usr/share/qt3/include 
>> -I.   -DQT_THREAD_SUPPORT  -D_REENTRANT  -Wno-long-long -Wundef -ansi 
>> -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -Wcast-align -Wchar-subscripts -Wall 
>> -W -Wpointer-arith -O2 -Wformat-security -Wmissing-format-attribute 
>> -Wno-non-virtual-dtor -fno-exceptions -fno-check-new -fno-common 
>> -DQT_CLEAN_NAMESPACE -DQT_NO_ASCII_CAST -DQT_NO_STL -DQT_NO_COMPAT 
>> -DQT_NO_TRANSLATION  -MT audioeditor.lo -MD -MP -MF 
>> .deps/audioeditor.Tpo -c -o audioeditor.lo audioeditor.cpp
>> In file included from audioeditor.h:24,
>>                  from audioeditor.cpp:30:
>> channeldesc.h:104: error: 'fe_rolloff_t' does not name a type
>> make[6]: *** [audioeditor.lo] Error 1
>> make[6]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src/input/dvb'
>> make[5]: *** [all-recursive] Error 1
>> make[5]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src/input/dvb'
>> make[4]: *** [all-recursive] Error 1
>> make[4]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src/input'
>> make[3]: *** [all-recursive] Error 1
>> make[3]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine/src'
>> make[2]: *** [all-recursive] Error 1
>> make[2]: Leaving directory `/home/frafu/kaffeine-svn/kaffeine'
>> make[1]: *** [all-recursive] Error 1
>> make[1]: Leaving directory `/home/frafu/kaffeine-svn'
>> make: *** [all] Error 2
>>
>> You might perhaps also want to know that the application of the patch 
>> worked without error.
> 
> You need to update frontend.h in /usr/include/linux/dvb/
> 
> eg.
> 
> mv /usr/include/linux/dvb/frontend.h /usr/include/linux/dvb/frontend.h.bak
> cp /???/v4l-dvb/linux/include/linux/dvb/frontend.h /usr/include/linux/dvb/frontend.h
> 
> Then recompile. Obviously replace ??? with the path to your v4l-dvb source
> files.
> 
> Good luck.
> 
> --
> 
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \ 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
