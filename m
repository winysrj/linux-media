Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBFDSnIY003460
	for <video4linux-list@redhat.com>; Tue, 15 Dec 2009 08:28:49 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nBFDSYTW000693
	for <video4linux-list@redhat.com>; Tue, 15 Dec 2009 08:28:35 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 15 Dec 2009 14:28:33 +0100
From: romil1@gmx.de
Message-ID: <20091215132832.282400@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Transfer-Encoding: 8bit
Subject: libv4l2 link error
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

Hello,

I've a usb webcam which I want to apply to my ARM platform.
The webcam just supports pjpg format therefore I want to use libv4l2.
When I try to link libv4l2 to my application I get this error:

arm-linux-uclibc-gcc -Wall -O2 -g -I../libv4l2/include -L../libv4l2/lib  -o capture capture.c -lv4l2 -lv4lconvert

../libv4l2/lib/libv4lconvert.so: undefined reference to `shm_open'
collect2: ld returned 1 exit status
make: *** [test] Fehler 1

I know this looks like a mistake with my cross compiler rather than a libv4l2 mistake but on all other appl/libs my compiler works fine.

I compiled the lib simply with:
make CC=arm-linux-uclibc-gcc PREFIX=my/path/libv4l2/ install

Anything missing?
Maybe someone can give me a hint how to solve this.

THX
Niko
-- 
Preisknaller: GMX DSL Flatrate für nur 16,99 Euro/mtl.!
http://portal.gmx.net/de/go/dsl02

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
