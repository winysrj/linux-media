Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m36MlFaN003674
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 18:47:15 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m36MkocW004048
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 18:46:51 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dwaine Garden <dwainegarden@rogers.com>
In-Reply-To: <314237.83517.qm@web88210.mail.re2.yahoo.com>
References: <314237.83517.qm@web88210.mail.re2.yahoo.com>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 00:46:35 +0200
Message-Id: <1207521995.6334.18.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: v4l-dvb tree will not compile all modules??
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Dwaine,

Am Sonntag, den 06.04.2008, 14:41 -0700 schrieb Dwaine Garden:
> I'm trying to compile all the modules in the hg tree.   The tree compiles ok on my mythtv box, but does not compile all of it.
> If I compile the 2.6.18 kernel, all the modules do compile properly.   But the v4l-dvb tree still only compiles 198 modules.

to avoid misunderstandings, the 2.6.18 compiles on its own, that I would
expect without that it is explicitly mentioned, but you even get the
current v4l-dvb master compiled on a 2.6.18 again? That is hard to
believe, since this is known since a while.

  LD [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/ir-common.o
  CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.o
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.c:491: error: unknown field 'dev_attrs' specified in initializer
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.c:491: warning: initialization from incompatible pointer type
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.c:492: error: unknown field 'dev_release' specified in initializer
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.c:492: warning: missing braces around initializer
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.c:492: warning: (near initialization for 'video_class.subsys')
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.c:492: warning: initialization from incompatible pointer type
make[3]: *** [/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/videodev.o] Error 1
make[2]: *** [_module_/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l] Error 2
 

But discovered too recently, we have some additional build backward
compat issues.
For the short tests I did, 2.6.23,24,25 are OK, 21,22 not tested yet.

2.6.18 fails since quite long, no sysfs compat, for sure I can say
2.6.20 still compiles all what is excluded in versions.txt for its
level, if you force it with make xconfig/menuconfig/manually or
whatsoever. 2.6.19 is deleted here, but should be the switch/border.

> make[2]: Leaving directory `/usr/src/linux-source-2.6.18-chw-13'
> ./scripts/rmmod.pl check
> found 198 modules
> make[1]: Leaving directory `/myth/v4l-dvb-1abbd650fe07/v4l'
> 
> Try it on another box and I get all the modules to compile?????
> 
> make[2]: Leaving directory `/usr/src/kernels/2.6.25-0.195.rc8.git1.fc9.i686'
> ./scripts/rmmod.pl check
> found 229 modules
> make[1]: Leaving directory `/usr/src/v4l-dvb-37d5a01a14ca/v4l'
> 
> What am I missing?
> 
> Dwaine

Compat is broken and it becomes slightly more broken over the time also
for the build system.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
