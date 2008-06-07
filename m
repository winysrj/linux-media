Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m570Cxrm002959
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 20:12:59 -0400
Received: from n0sq.us (mo-65-41-216-18.sta.embarqhsd.net [65.41.216.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m570CWUP032009
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 20:12:34 -0400
Received: from server2.lan (server2 [192.168.1.4])
	by n0sq.us (Postfix) with ESMTP id E5A221827FF
	for <video4linux-list@redhat.com>; Fri,  6 Jun 2008 18:09:50 -0600 (MDT)
From: engage <engage@n0sq.us>
To: video4linux-list@redhat.com
Date: Fri, 6 Jun 2008 18:12:30 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061812.30755.engage@n0sq.us>
Subject: webcams
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

I don't know if I'm OT but I believe that v4l is used with usb webcams. I just 
bought an HP webcam but can't get it to work in Mandriva 2008.1 with amsn or 
camorama on any PC. lsusb says it's a Pixart Imaging device.

lsusb output:

Bus 003 Device 002: ID 093a:2621 Pixart Imaging, Inc.

dmesg output:

usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
usbcore: registered new interface driver gspca
/var/lib/dkms/gspca/1.00.20-2mdv2008.1/build/gspca_core.c: gspca driver 
01.00.20 registered

lsmod | grep gspca output:

gspca                 676016  0
videodev               27104  1 gspca
usbcore               126860  6 gspca,usb_storage,uhci_hcd,ohci_hcd,ehci_hcd

lsmod | grep v4l output:

v4l2_common            16128  1 videodev
v4l1_compat            14340  1 videodev

ls /dev/video* output:

ls: cannot access /dev/video*: No such file or directory

Mandriva kernel 2.6.24.5-laptop-1mnb, 
gspca-kernel-2.6.24.4-laptop-3mnb-1.00.20-2mdv2008.1, 
x11-driver-video-v4l-0.1.1-6mdv2008.1, KDE 3.5.9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
