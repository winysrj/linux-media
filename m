Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp5.freeserve.com ([193.252.22.128])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <c.j.thornley@coolrose.fsnet.co.uk>)
	id 1MawAJ-0000xL-Ne
	for linux-dvb@linuxtv.org; Tue, 11 Aug 2009 20:33:44 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf3409.me.freeserve.com (SMTP Server) with ESMTP id 169161C00083
	for <linux-dvb@linuxtv.org>; Tue, 11 Aug 2009 20:33:05 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf3409.me.freeserve.com (SMTP Server) with ESMTP id 07ED31C00082
	for <linux-dvb@linuxtv.org>; Tue, 11 Aug 2009 20:33:05 +0200 (CEST)
Received: from SOL (unknown [91.109.64.68])
	by mwinf3409.me.freeserve.com (SMTP Server) with ESMTP id 5EAC21C00081
	for <linux-dvb@linuxtv.org>; Tue, 11 Aug 2009 20:33:04 +0200 (CEST)
From: "Christopher Thornley" <c.j.thornley@coolrose.fsnet.co.uk>
To: <linux-dvb@linuxtv.org>
Date: Tue, 11 Aug 2009 19:32:51 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5icHrgBAAAAAA==@coolrose.fsnet.co.uk>
MIME-Version: 1.0
Subject: [linux-dvb] TechnoTrend TT-connect S2-3650 CI
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

Hi,
I was wondering if you could help me. I am fairly new to using Linux so be a
bit patient with me and please explain things that might not be obvious to
me.

I have an "ASUS n80vc" Laptop which I have installed Ubuntu 9.04 Desktop
64bit.
I also have 2 USB DVB devices :-

Technotrend tt-connect S2-3650 CI (DVB-S and DVB-S2)
Technotrend tt-connect CT-3650 CI (DVB-T and DVB-C)

I am trying to get these to work with my machine.

I believe I need to some how to get these operating with something like
MythTV or Video4Linux or VDR with a software decoder.

So far I have tried to install a few packages via the synaptic installer but
so far non have work successfully with my devices.

I then did a little searching around and stumbled across this page
http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI

I think these are drivers or interfaces for my devices.

I have followed the instructions for both S2API and Multiproto.

S2API installation seemed to be successful but I have no way of confirming
this. I had to "Sudo insmod" the modules to install them. I am not to sure
if they will survive a reboot or will I have to install them again. These
appear to install without any complaints.

Multiproto installation did not seem to be entirely successful. I followed
the instructions but the modules are not found when I arrive at the insmod
stage. I suspect they did not compile successfully. I am clueless as how to
get these to work.

This is the output I received from the make command and I am not sure if
this will shed some light on the matter.

system@Firefly:~/3650/multiproto$ make
make -C /home/system/3650/multiproto/v4l 
make[1]: Entering directory `/home/system/3650/multiproto/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.28-14-generic/build
make -C /lib/modules/2.6.28-14-generic/build
SUBDIRS=/home/system/3650/multiproto/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.28-14-generic'
  CC [M]  /home/system/3650/multiproto/v4l/cx25840-core.o
In file included from /home/system/3650/multiproto/v4l/cx25840-core.c:42:
/home/system/3650/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.
h: In function 'v4l2_i2c_drv_init':
/home/system/3650/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.
h:197: warning: assignment from incompatible pointer type
/home/system/3650/multiproto/v4l/cx25840-core.c: At top level:
/home/system/3650/multiproto/v4l/cx25840-core.c:71: error: conflicting type
qualifiers for 'addr_data'
/home/system/3650/multiproto/v4l/../linux/include/media/v4l2-i2c-drv-legacy.
h:41: error: previous declaration of 'addr_data' was here
make[3]: *** [/home/system/3650/multiproto/v4l/cx25840-core.o] Error 1
make[2]: *** [_module_/home/system/3650/multiproto/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-14-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/system/3650/multiproto/v4l'
make: *** [all] Error 2
system@Firefly:~/3650/multiproto$ 

I probably would like to get both the S2API and Multiprot methods working.

The article also mentions that there is a "patched version of szap available
(search mailing list). " I presume this is the correct place to look but
some pointers and installation instructions would be helpful to me.

If I get the S2API and Multiprot installed how do I use them to tune into,
watch and download Mpeg Transport streams from DVB? Do they support multipul
devices plugged in at once and the use of the CI interface?

Any advise to the next stage would be gratefully appreciated.

Many Thanks
Chris






               />      Christopher J. Thornley is cjt@coolrose.fsnet.co.uk
  (           //------------------------------------------------------,
 (*)OXOXOXOXO(*>=*=O=S=U=0=3=6=*=---------                             >
  (           \\------------------------------------------------------'
               \>       Home Page :-http://www.coolrose.fsnet.co.uk
 




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
