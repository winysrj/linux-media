Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1MHGpuk010345
	for <video4linux-list@redhat.com>; Sun, 22 Feb 2009 12:16:51 -0500
Received: from ns1.tacitlabs.com (support.team.at.shellium.org
	[207.192.71.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1MHGdi5007957
	for <video4linux-list@redhat.com>; Sun, 22 Feb 2009 12:16:39 -0500
Date: Sun, 22 Feb 2009 12:16:38 -0500
To: video4linux-list@redhat.com
Message-ID: <20090222171638.GA19029@shellium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
From: dkremer@shellium.org
Subject: PROBLEM: gspca driver with a logitech quickcam express and a USB hub
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

My webcam doesn't work when it is plugged with a hub to my computer.

When my webcam is used with a hub, I have the following error log :

//loading of the device by gspca
usb 1-4.4: new full speed USB device using ehci_hcd and address 12
usb 1-4.4: configuration #1 chosen from 1 choice
gspca: probing 046d:0928
gspca: probe ok

//I'm launching svv, the soft shipped by Jean François Moine
gspca: usb_submit_urb [0] err -28
gspca: usb_submit_urb [0] err -28
gspca: usb_submit_urb [0] err -28
gspca: usb_submit_urb [0] err -28
gspca: usb_submit_urb [0] err -28
gspca: usb_submit_urb [0] err -28

When I use a direct acces to a USB port of my computer, without a hub
between the host and the camera, the camera is working perfectly, and I
have not this problem.

The complete lsusb map is :
 
Bus 001 Device 012: ID 046d:0928 Logitech, Inc. QuickCam Express
Bus 001 Device 011: ID 152d:2336 JMicron Technology Corp. / JMicron USA
Technology Corp.
Bus 001 Device 004: ID 046d:c404 Logitech, Inc. TrackMan Wheel
Bus 001 Device 003: ID 0603:00f2 Novatek Microelectronics Corp.
Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

The usb string id for my webcam is :
ID 046d:0928 Logitech, Inc. QuickCam Express

The usb string id for my HUB is :
ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB

I'm currently using archlinux, with a 2.6.28.6 kernel. I'm using the
gspca_main and gspca_spca561 modules.

cat /proc/version :
Linux version 2.6.28-ARCH (root@T-POWA-LX) (gcc version 4.3.3 (GCC) ) #1
SMP PREEMPT Wed Feb 18 21:27:38 UTC 2009

I just wanted help maybe for the gspca driver if it could be. Thank you
to Jean François Moine for gspca.

-- 

David Kremer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
