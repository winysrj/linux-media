Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1MI6uD6022298
	for <video4linux-list@redhat.com>; Sun, 22 Feb 2009 13:06:56 -0500
Received: from mk-outboundfilter-6.mail.uk.tiscali.com
	(mk-outboundfilter-6.mail.uk.tiscali.com [212.74.114.14])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1MI6UX1009903
	for <video4linux-list@redhat.com>; Sun, 22 Feb 2009 13:06:30 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: video4linux-list@redhat.com
Date: Sun, 22 Feb 2009 18:06:28 +0000
References: <20090222171638.GA19029@shellium.org>
In-Reply-To: <20090222171638.GA19029@shellium.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200902221806.28268.linux@baker-net.org.uk>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: PROBLEM: gspca driver with a logitech quickcam express and a
	USB hub
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

On Sunday 22 February 2009, dkremer@shellium.org wrote:
> Hello,
>
> My webcam doesn't work when it is plugged with a hub to my computer.
>
> When my webcam is used with a hub, I have the following error log :
>
> //loading of the device by gspca
> usb 1-4.4: new full speed USB device using ehci_hcd and address 12
> usb 1-4.4: configuration #1 chosen from 1 choice
> gspca: probing 046d:0928
> gspca: probe ok
>
> //I'm launching svv, the soft shipped by Jean François Moine
> gspca: usb_submit_urb [0] err -28
> gspca: usb_submit_urb [0] err -28
> gspca: usb_submit_urb [0] err -28
> gspca: usb_submit_urb [0] err -28
> gspca: usb_submit_urb [0] err -28
> gspca: usb_submit_urb [0] err -28
>

error -28 is ENOSPC which means that there isn't enough bandwidth available on 
the USB bus to do what you are attempting. 

> When I use a direct acces to a USB port of my computer, without a hub
> between the host and the camera, the camera is working perfectly, and I
> have not this problem.
>
> The complete lsusb map is :
>
> Bus 001 Device 012: ID 046d:0928 Logitech, Inc. QuickCam Express
> Bus 001 Device 011: ID 152d:2336 JMicron Technology Corp. / JMicron USA
> Technology Corp.
> Bus 001 Device 004: ID 046d:c404 Logitech, Inc. TrackMan Wheel
> Bus 001 Device 003: ID 0603:00f2 Novatek Microelectronics Corp.
> Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>
> The usb string id for my webcam is :
> ID 046d:0928 Logitech, Inc. QuickCam Express
>

Looking at the above it seems the camera is usb 1.1

> The usb string id for my HUB is :
> ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
>

and the hub is 2.0. That means it needs to use a transaction translator in the 
hub to convert the usb 1.1 camera to usb 2.0 and it is failing to reserve 
enough bandwidth to do so. If the camera is near the limit for a full speed 
device then there are a number of possibilities.

1) something else on the hub has reserved some bandwidth so there is not 
enough left for the camera.

2) The hub only has one transaction translator and bus scheduling issues mean 
that not all of the capacity is usable.

3) There's a bug in the USB subsystem leading to it miscalculating the 
required / available bandwidth (as there appear to be such errors in the USB 
spec this wouldn't be too surprising).

> I'm currently using archlinux, with a 2.6.28.6 kernel. I'm using the
> gspca_main and gspca_spca561 modules.
>
> cat /proc/version :
> Linux version 2.6.28-ARCH (root@T-POWA-LX) (gcc version 4.3.3 (GCC) ) #1
> SMP PREEMPT Wed Feb 18 21:27:38 UTC 2009
>
> I just wanted help maybe for the gspca driver if it could be. Thank you
> to Jean François Moine for gspca.

Adam


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
