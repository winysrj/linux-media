Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KLJ4KN018248
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 17:19:04 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net
	(elasmtp-galgo.atl.sa.earthlink.net [209.86.89.61])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4KLIqmh028363
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 17:18:52 -0400
Received: from [209.86.224.27] (helo=mswamui-billy.atl.sa.earthlink.net)
	by elasmtp-galgo.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <aglover.v4l@mindspring.com>) id 1JyZEN-0006EN-2V
	for video4linux-list@redhat.com; Tue, 20 May 2008 17:18:47 -0400
Message-ID: <4291817.1211318326884.JavaMail.root@mswamui-billy.atl.sa.earthlink.net>
Date: Tue, 20 May 2008 14:18:46 -0700 (GMT-07:00)
From: Adam Glover <aglover.v4l@mindspring.com>
To: video4linux-list@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Problems building on Debian Etch
Reply-To: Adam Glover <aglover.v4l@mindspring.com>
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

Kernel 2.6.18 (2.6.18.6?) is over a year old.  I don't know what
the latest kernel available in the Etch repositories but Sid has
the latest stable version (2.6.18.25 as of a few weeks ago) so
you might want to update your kernel.  Etch doesn't appear to
have a newer kernel, so you will need to compile your own.

I had problems just a few weeks ago compiling mercurial against
2.6.25.2 (linux stable) due to recent changes in the Linux GIT
branches not yet merged into stable.  In my case, the errors
only occurred for certain modules which I did not need so I was
able to compile without them.

My first guess would be that you're seeing the same type of thing.
This is probably fairly common.

good luck
Adam Glover

-----Original Message-----
>From: Ernesto Hernández-Novich <emhn@usb.ve>
>Sent: May 20, 2008 11:56 AM
>To: video4linux-list@redhat.com
>Subject: Problems building on Debian Etch
>
>I'm trying to build the latest sources from Mercurial on an up-to-date
>Debian Etch system. I've installed linux-headers-2.6.18-6-686 and
>there's a corresponding link from /lib/modules/2.6.18-6-686/build
>pointing to the headers.
>
>Then I simply 'make' and after a while get
>
>/usr/src/v4l-dvb/v4l/videodev.c:499: error: unknown field 'dev_attrs'
>specified in initializer
>/usr/src/v4l-dvb/v4l/videodev.c:499: warning: initialization from
>incompatible pointer type
>make[3]: *** [/usr/src/v4l-dvb/v4l/videodev.o] Error 1
>make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
>make[2]: Leaving directory `/usr/src/linux-headers-2.6.18-6-686'
>make[1]: *** [default] Error 2
>make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
>make: *** [all] Error 2
>
>I was able to build using the _exact_ same procedure about a month and a
>half ago, withouth problems. Ideas?
>-- 
>Prof. Ernesto Hernández-Novich - MYS-220C
>Geek by nature, Linux by choice, Debian of course.
>If you can't aptitude it, it isn't useful or doesn't exist.
>GPG Key Fingerprint = 438C 49A2 A8C7 E7D7 1500 C507 96D6 A3D6 2F4C 85E3
>
>--
>video4linux-list mailing list
>Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
