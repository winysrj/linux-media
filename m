Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6V4OfCh016700
	for <video4linux-list@redhat.com>; Fri, 31 Jul 2009 00:24:41 -0400
Received: from mail-gx0-f221.google.com (mail-gx0-f221.google.com
	[209.85.217.221])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6V4OJwh028409
	for <video4linux-list@redhat.com>; Fri, 31 Jul 2009 00:24:19 -0400
Received: by gxk21 with SMTP id 21so3365625gxk.3
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 21:24:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907261604.30661.dinvlad@gmail.com>
References: <200907261604.30661.dinvlad@gmail.com>
Date: Fri, 31 Jul 2009 09:54:19 +0530
Message-ID: <77ca8eab0907302124n50bb8122p128f6f6934b2faf5@mail.gmail.com>
From: amol verule <amol.debian@gmail.com>
To: Denis Loginov <dinvlad@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: driver for 041e:4055 Creative Technology, Ltd Live! Cam Video IM
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

thanks denis,
                       after following these steps it worked me to detect
device but not to read or get picture from device. it is giving error as
usb 5-5: new high speed USB device using ehci_hcd and address 3
usb 5-5: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
gspca: main v2.7.0 registered
gspca: probing 041e:4055
zc3xx: Sensor Tas5130 (VF0250)
gspca: probe ok
usbcore: registered new interface driver zc3xx
zc3xx: registered
usb 5-5: USB disconnect, address 3
gspca: usb_submit_urb alt 2 err -19
gspca: disconnect complete
gspca: open failed err -19
gspca: open failed err -19
                               what this error means ..i think problem in
device driver it is not able to open device..how to resolve this error???


On Sun, Jul 26, 2009 at 6:34 PM, Denis Loginov <dinvlad@gmail.com> wrote:

> Actually, according to http://linux-uvc.berlios.de/ , you can just try
> 'USB
> Video Class' Driver, i.e. Device Drivers -> Multimedia Devices -> Video
> Capture Adapters -> V4L USB Devices -> (M) USB Video Class (UVC) & (y) UVC
> input events device support
> (CONFIG_USB_VIDEO_CLASS=m & USB_VIDEO_CLASS_INPUT_EVDEV=y).
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
