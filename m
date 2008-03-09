Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m296jDx0023580
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 01:45:13 -0500
Received: from cabrera.red.sld.cu (cabrera.red.sld.cu [201.220.222.139])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m296iXlx005884
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 01:44:35 -0500
Received: from [201.220.219.1] by cabrera.red.sld.cu with esmtp (Exim 4.63)
	(envelope-from <moya-lists@infomed.sld.cu>) id 1JYFGU-0000cC-5N
	for video4linux-list@redhat.com; Sun, 09 Mar 2008 02:44:10 -0400
From: Maykel Moya <moya-lists@infomed.sld.cu>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Sun, 09 Mar 2008 02:46:57 -0400
Message-Id: <1205045217.6188.274.camel@gloria.red.sld.cu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Problems compiling ~mchehab/tm6010 repo
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

I did a clone of tm6010 repo. The build process stopped with:

moya@gloria:~/src/tm6010$ make
make -C /home/moya/src/tm6010/v4l 
make[1]: se ingresa al directorio `/home/moya/src/tm6010/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.24-1-686/build
make -C /lib/modules/2.6.24-1-686/build
SUBDIRS=/home/moya/src/tm6010/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.24-1-686'
  CC [M]  /home/moya/src/tm6010/v4l/tm6000-i2c.o
/home/moya/src/tm6010/v4l/tm6000-i2c.c:356: error: unknown field
'algo_control' specified in initializer
/home/moya/src/tm6010/v4l/tm6000-i2c.c:356: warning: initialization from
incompatible pointer type
make[3]: *** [/home/moya/src/tm6010/v4l/tm6000-i2c.o] Error 1
make[2]: *** [_module_/home/moya/src/tm6010/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-1-686'
make[1]: *** [default] Error 2
make[1]: se sale del directorio `/home/moya/src/tm6010/v4l'
make: *** [all] Error 2

A search in Google lead me to this[1], a patch by akpm just removing the
same line for another driver. I dropped the line and the tree was built
OK.

Some questions then
- Why the warning if function algo_control is defined in the same file?
(sorry for not knowing enough C to figure this out by myself)
- Is it correct what I did?
- If tm6010 the correct tree for building a working tm5600.ko ?

Regards,
maykel

[1]
http://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/broken-out/git-dvb-vs-i2c-tree.patch


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
