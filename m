Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3FAkScj014901
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 06:46:28 -0400
Received: from smtp-out2.blueyonder.co.uk (smtp-out2.blueyonder.co.uk
	[195.188.213.5])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3FAkEFO002257
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 06:46:14 -0400
Received: from [172.23.170.140] (helo=anti-virus02-07)
	by smtp-out2.blueyonder.co.uk with smtp (Exim 4.52)
	id 1Lu2dB-0001fX-KF
	for video4linux-list@redhat.com; Wed, 15 Apr 2009 11:46:13 +0100
Received: from [77.97.147.200] (helo=[192.168.178.23])
	by asmtp-out2.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1Lu2dB-000805-0c
	for video4linux-list@redhat.com; Wed, 15 Apr 2009 11:46:13 +0100
Message-ID: <49E5BAF4.6020200@leafcom.co.uk>
Date: Wed, 15 Apr 2009 11:46:12 +0100
From: Brian <linuxtv@leafcom.co.uk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Hauppauge DVB s/s2 card: Problem installing driver
Reply-To: linuxtv@leafcom.co.uk
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

DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=8.04
DISTRIB_CODENAME=hardy
DISTRIB_DESCRIPTION="Ubuntu 8.04.2"
GNU/Linux 2.6.24-23-generic
'Build Essential' is installed. Reports as latest version.

I have tried installing this WinTV Nova DVB S2 card: card (see it here
tinyurl.com/cw3upv) using two similar methods using different sources.
Both give the same kind of problem. I have got the firmware down OK but I
am having problems installing the driver. Below is a listing of the part
of the installation where the problem arises (file missing for the 'make')

As you can see it can't find a file in the 'build' directory. Not
surprising as that directory doesn't exist. So I made a 'build' directory
but still it wouldn't work. I have some experience with Linux but it is
limited. I am using Ubuntu 8.04, fully updated to latest version, kernel
2.6.24-23-generic .
Can anyone tell me how I can proceed from here please?

..................................
brian@MC:/usr/local/src/liplianindvb$ ls
COPYING   INSTALL  mailimport  README          v4l        v4l_experimental
hgimport  linux    Makefile    README.patches  v4l2-apps
brian@MC:/usr/local/src/liplianindvb$ sudo make
[sudo] password for brian:  
make -C /usr/local/src/liplianindvb/v4l
make[1]: Entering directory `/usr/local/src/liplianindvb/v4l'
Updating/Creating .config
Preparing to compile for kernel version 2.6.24
File not found: /lib/modules/2.6.24-23-generic/build/.config at ./scripts/
make_kconfig.pl line 32, <IN> line 4.
make[1]: *** No rule to make target `.myconfig', needed by `config-
compat.h'. Stop.
make[1]: Leaving directory `/usr/local/src/liplianindvb/v4l'
make: *** [all] Error 2
brian@MC:/usr/local/src/liplianindvb$
........................................................................

and slightly different setup here... same problem
brian@MC:/usr/local/src/v4l-dvb/v4l$ ls
compat.h Kconfig.sound Makefile.kernel obsolete.txt
firmware Makefile Makefile.media scripts
i2c-compat.h Makefile.kern24 Makefile.sound versions.txt
brian@MC:/usr/local/src/v4l-dvb/v4l$ sudo make Updating/Creating
.config Preparing to compile for kernel version 2.6.24 File not found:
/lib/modules/2.6.24-23-generic/build/.config at ./scripts/make_kconfig.pl
line 32, <IN> line 4.
make: *** No rule to make target `.myconfig', needed by `config-compat.h'.
Stop.
brian@MC:/usr/local/src/v4l-dvb/v4l$
...................




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
