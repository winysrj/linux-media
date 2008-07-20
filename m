Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KEAOaP017231
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:10:24 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KEADKU014467
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:10:13 -0400
Received: by ik-out-1112.google.com with SMTP id c30so789559ika.3
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 07:10:12 -0700 (PDT)
Message-ID: <de8cad4d0807200710xde576bfpb495ae5dbbd0b394@mail.gmail.com>
Date: Sun, 20 Jul 2008 10:10:12 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: compat_ioctl32.o: Error compiling latest HG clone of v4l-dvb
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

Greetings,

Snippet below.

Thanks!

Brandon

CC [M]  /root/v4l-dvb/v4l/compat_ioctl32.o
/root/v4l-dvb/v4l/compat_ioctl32.c: In function 'v4l_compat_ioctl32':
/root/v4l-dvb/v4l/compat_ioctl32.c:985: error: implicit declaration of
function 'v4l_printk_ioctl'
make[3]: *** [/root/v4l-dvb/v4l/compat_ioctl32.o] Error 1
make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.26'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
