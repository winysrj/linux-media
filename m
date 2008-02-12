Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1C3fkNB031029
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 22:41:46 -0500
Received: from web34401.mail.mud.yahoo.com (web34401.mail.mud.yahoo.com
	[66.163.178.150])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m1C3fGUD014456
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 22:41:16 -0500
Date: Mon, 11 Feb 2008 19:41:10 -0800 (PST)
From: Muppet Man <muppetman4662@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <653934.59125.qm@web34401.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Subject: Trouble compiling driver in PClinuxOS
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

Greetings all,
I am having trouble compiling the latest v4l-dvb in order to get my pinnicale pci card to work.  I am running PClinuxOS 2007.  I have downloaded the latest tree, mkdir v4l-dvb extracted the tz file to that folder, went into root mode and got this error when I make the file

make -C /home/ed/v4l-dvb/v4l
make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.18.8.tex5/build
make -C /lib/modules/2.6.18.8.tex5/build SUBDIRS=/home/ed/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.18.8.tex5'
  CC [M]  /home/ed/v4l-dvb/v4l/videodev.o
/home/ed/v4l-dvb/v4l/videodev.c:491: error: unknown field 'dev_attrs' specified in initializer
/home/ed/v4l-dvb/v4l/videodev.c:491: warning: initialization from incompatible pointer type
/home/ed/v4l-dvb/v4l/videodev.c:492: error: unknown field 'dev_release' specified in initializer
/home/ed/v4l-dvb/v4l/videodev.c:492: warning: missing braces around initializer
/home/ed/v4l-dvb/v4l/videodev.c:492: warning: (near initialization for 'video_class.subsys')
/home/ed/v4l-dvb/v4l/videodev.c:492: warning: initialization from incompatible pointer type
make[3]: *** [/home/ed/v4l-dvb/v4l/videodev.o] Error 1
make[2]: *** [_module_/home/ed/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.18.8.tex5'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'

I know this driver works because I had it running under ubuntu, but I heard so much about PClinuxOS that I thought I would give it a shot.

Any help would be greatly appreciated.
Ed






      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
