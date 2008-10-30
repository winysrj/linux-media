Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9UJQ0xK002515
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 15:26:00 -0400
Received: from QMTA02.emeryville.ca.mail.comcast.net
	(qmta02.emeryville.ca.mail.comcast.net [76.96.30.24])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m9UJOQj9010346
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 15:24:26 -0400
Message-ID: <490A09EA.2080300@personnelware.com>
Date: Thu, 30 Oct 2008 14:24:26 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: v4l-dvb/v4l/av7110.c:698: error: implicit declaration of function
 'swahw32'
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

sudo apt-get install libqt4-dev mercurial lsb-build-desktop3 libqt3-headers
hg clone http://linuxtv.org/hg/v4l-dvb

juser@dhcp186:~/vga2usb/v4l.org/v4l-dvb$ make
make -C /home/juser/vga2usb/v4l.org/v4l-dvb/v4l
make[1]: Entering directory `/home/juser/vga2usb/v4l.org/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.27-7-generic/build
make -C /lib/modules/2.6.27-7-generic/build
SUBDIRS=/home/juser/vga2usb/v4l.org/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
  CC [M]  /home/juser/vga2usb/v4l.org/v4l-dvb/v4l/av7110.o
/home/juser/vga2usb/v4l.org/v4l-dvb/v4l/av7110.c: In function 'gpioirq':
/home/juser/vga2usb/v4l.org/v4l-dvb/v4l/av7110.c:698: error: implicit
declaration of function 'swahw32'
make[3]: *** [/home/juser/vga2usb/v4l.org/v4l-dvb/v4l/av7110.o] Error 1
make[2]: *** [_module_/home/juser/vga2usb/v4l.org/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/juser/vga2usb/v4l.org/v4l-dvb/v4l'
make: *** [all] Error 2


        case DATA_IRCOMMAND:
                if (av7110->ir.ir_handler)
                        av7110->ir.ir_handler(av7110,
                                swahw32(irdebi(av7110, DEBINOSWAP, Reserved, 0,
4)));
                iwdebi(av7110, DEBINOSWAP, RX_BUFF, 0, 2);
                break;


Why don't I see that here: http://linuxtv.org/hg/v4l-dvb/file/c8a63c43b663/v4l/

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
