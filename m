Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAT94uYk002769
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 04:04:56 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAT94giW007699
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 04:04:42 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: kin2031@yahoo.com
In-Reply-To: <368069.23199.qm@web39708.mail.mud.yahoo.com>
References: <368069.23199.qm@web39708.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 29 Nov 2008 09:47:11 +0100
Message-Id: <1227948431.1733.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Unable to achieve 30fps using 'read()' in C
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

On Sat, 2008-11-29 at 00:27 -0800, wei kin wrote:
> I installed qc-usb-0.6.6 and gspca-modules-2.6.18-5-xen-686 in my debian 2.6.18-5-xen. Below are what I got:
> 
> lsusb
> Bus 004 Device 004: ID 046d:0920 Logitech, Inc. QuickCam Express
> 
> dmesg | grep usb
> usbcore: registered new driver usbfs
> usbcore: registered new driver hub
> usb usb1: configuration #1 chosen from 1 choice
> usb usb2: configuration #1 chosen from 1 choice
> usb usb3: configuration #1 chosen from 1 choice
> usb usb4: configuration #1 chosen from 1 choice
> usb 4-1: new full speed USB device using uhci_hcd and address 2
> usb 4-1: configuration #1 chosen from 1 choice
> usb usb5: configuration #1 chosen from 1 choice
>  sda:<6>usb 4-1: USB disconnect, address 2
> usb 4-1: new full speed USB device using uhci_hcd and address 3
> usb 4-1: configuration #1 chosen from 1 choice
> usbcore: registered new driver gspca
> usb 4-1: USB disconnect, address 3
> usb 4-1: new full speed USB device using uhci_hcd and address 4
> usb 4-1: configuration #1 chosen from 1 choice
> 
> dmesg | grep Logitech
> input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
> 
> I did try out the API example in http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/a16706.htm. However, I get error message stated that  '/dev/video0 is no V4L2 device'.
> 
> Do anyone have any idea?

You use the gspca v1 which is not v4l2 compliant. Please, switch to
gspca v2 (look at my web page). Note that for your webcam, the subdriver
has some remaining problems. I hope to fix them soon.

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
