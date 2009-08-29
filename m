Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7TLKhGw001356
	for <video4linux-list@redhat.com>; Sat, 29 Aug 2009 17:20:43 -0400
Received: from sssup.it (ms01.sssup.it [193.205.80.99])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7TLKUcK029756
	for <video4linux-list@redhat.com>; Sat, 29 Aug 2009 17:20:31 -0400
Received: from [78.13.138.76] (HELO dse-adry-mob.sp.unipi.it)
	by sssup.it (CommuniGate Pro SMTP 4.1.8)
	with ESMTP-TLS id 53248708 for video4linux-list@redhat.com;
	Sat, 29 Aug 2009 23:05:40 +0200
Date: Sat, 29 Aug 2009 23:20:29 +0200
From: Angelo Secchi <secchi@sssup.it>
To: video4linux-list@redhat.com
Message-Id: <20090829232029.63f48ff0.secchi@sssup.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Lenovo compact cam 17ef:4802
Reply-To: angelo.secchi@sssup.it
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


Hi,
I'm experiencing problems in having my Lenovo USB cam working in Gentoo
with kernel 2.6.30-gentoo-r4. I have installed gspca-af183a871db8 and
it seems that the cam is correctly recognized

>dmesg
Linux video capture interface: v2.00
gspca: main v2.6.0 registered
gspca: probing 17ef:4802
vc032x: check sensor header 20
vc032x: Sensor ID 143a (3)
vc032x: Find Sensor MI1310_SOC
gspca: probe ok
usbcore: registered new interface driver vc032x
vc032x: registered

However when I try with cheese to get it working I get this error

>cheese                                          
(cheese:21741): GStreamer-WARNING **: pad source:src returned caps which are not a real subset of its template caps
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error
libv4l2: error dequeuing buf: Input/output error

Cheese does not show any available resolutions. Problems also with xawtv

>xawtv
This is xawtv-3.95, running on Linux/i686 (2.6.30-gentoo-r4)
WARNING: v4l-conf is compiled without DGA support.
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
no way to get: 384x288 32 bit TrueColor (LE: bgr-)

Any help to debug my problem?
Thanks in advance

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
