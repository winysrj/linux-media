Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.159]:18597 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZHKTAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 15:00:18 -0400
Received: from smtp5.freeserve.com (mwinf3409 [10.232.11.37])
	by mwinf3405.me.freeserve.com (SMTP Server) with ESMTP id 694B01C00C53
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 20:43:03 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf3409.me.freeserve.com (SMTP Server) with ESMTP id 23C8F1C00083
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 20:42:31 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf3409.me.freeserve.com (SMTP Server) with ESMTP id 158F21C00082
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 20:42:31 +0200 (CEST)
Received: from SOL (unknown [91.109.64.68])
	by mwinf3409.me.freeserve.com (SMTP Server) with ESMTP id 648F71C00081
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 20:42:30 +0200 (CEST)
From: "Christopher Thornley" <c.j.thornley@coolrose.fsnet.co.uk>
To: <linux-media@vger.kernel.org>
Subject: TechnoTrend TT-connect S2-3650 CI
Date: Tue, 11 Aug 2009 19:42:17 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAMZF2wgv2ABAovNyl0ClejEBAAAAAA==@coolrose.fsnet.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I was wondering if you could help me. I am fairly new to using Linux so be a
bit patient with me and please explain things that might not be obvious to
me.

I have an "ASUS n80vc" Laptop which I have installed Ubuntu 9.04 Desktop
64bit.
I also have 2 USB DVB devices :-

Technotrend tt-connect S2-3650 CI (DVB-S and DVB-S2) Technotrend tt-connect
CT-3650 CI (DVB-T and DVB-C)

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
 



