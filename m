Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4M9oRl027198
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 17:09:50 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4M9a3V027996
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 17:09:37 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3106092fga.7
	for <video4linux-list@redhat.com>; Thu, 04 Dec 2008 14:09:36 -0800 (PST)
Message-ID: <e48b28270812041409t31139b4v1ca6c8ab1578b4e9@mail.gmail.com>
Date: Thu, 4 Dec 2008 23:09:36 +0100
From: "Nagy Gabor" <nagygabor.info@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: WinFast PalmTop DTV200H USB TvTuner
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

I've got a Leadtek
dtv200h<http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=413>usb
tv tuner, and it got 4 chips:

EMPIA 2882<http://kepfeltoltes.hu/081204/EMPIA_2882_www.kepfeltoltes.hu_.jpg>
WJCE6353 <http://kepfeltoltes.hu/081204/WJCE6353_www.kepfeltoltes.hu_.jpg>
CX25843-24Z<http://kepfeltoltes.hu/081204/CX25843-242_www.kepfeltoltes.hu_.jpg>
XCEIVE XC3028LCQ<http://kepfeltoltes.hu/081204/XCEIVE_XC3028LCQ_www.kepfeltoltes.hu_.jpg>
front<http://kepfeltoltes.hu/081204/258590942front_www.kepfeltoltes.hu_.jpg>
back <http://kepfeltoltes.hu/081204/22578894back_www.kepfeltoltes.hu_.jpg>

distro: I use Debian Lenny
2.6.26-1-amd64<http://cdimage.debian.org/cdimage/lenny_di_rc1/amd64/bt-cd/debian-testing-amd64-kde-CD-1.iso.torrent>-
"or anything you want" :D

lsusb:
Bus 007 Device 005: ID 0413:6f02 Leadtek Research, Inc.

dmesg:
[    2.787953] usb 7-1: new high speed USB device using ehci_hcd and address
2
[    2.928702] usb 7-1: configuration #1 chosen from 1 choice
[    2.928702] usb 7-1: New USB device found, idVendor=0413, idProduct=6f02
[    2.928702] usb 7-1: New USB device strings: Mfr=0, Product=1,
SerialNumber=2
[    2.928702] usb 7-1: Product: WinFast PalmTop DTV200 H
[    2.928702] usb 7-1: SerialNumber: 2222

tvtime-scanner:
videoinput: Cannot open capture device /dev/video0: No such file or
directory

Does someone know, how to get it work under Linux?
Thank you!

-- 
Nagy Gabor
http://szabadlinuxot.blogspot.com/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
