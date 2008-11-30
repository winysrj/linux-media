Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAU5QuUv003650
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 00:26:56 -0500
Received: from web39701.mail.mud.yahoo.com (web39701.mail.mud.yahoo.com
	[209.191.106.47])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAU5Q7D5017381
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 00:26:07 -0500
Date: Sat, 29 Nov 2008 21:26:06 -0800 (PST)
From: wei kin <kin2031@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <980206.90162.qm@web39701.mail.mud.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: Unable to achieve 30fps using 'read()' in C
Reply-To: kin2031@yahoo.com
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

Hi guys, thanks for the advice. However, after I install gspca v2 and run t=
he API example in http://www.linuxtv.org/downloads/video4linux/API/V4L2_API=
/spec/a16706.htm, I still get only 5fps. I am still wondering how others ma=
nage to get higher fps. Or do I need other programming technique such as th=
read programming to achieve that?

Thanks.
Rgds,
nik2031

On Sat, 2008-11-29 at 00:27 -0800, wei kin wrote:
> I installed qc-usb-0.6.6 and gspca-modules-2.6.18-5-xen-686 in my debian =
2.6.18-5-xen. Below are what I got:
>=20
> lsusb
> Bus 004 Device 004: ID 046d:0920 Logitech, Inc. QuickCam Express
>=20
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
>=A0 sda:<6>usb 4-1: USB disconnect, address 2
> usb 4-1: new full speed USB device using uhci_hcd and address 3
> usb 4-1: configuration #1 chosen from 1 choice
> usbcore: registered new driver gspca
> usb 4-1: USB disconnect, address 3
> usb 4-1: new full speed USB device using uhci_hcd and address 4
> usb 4-1: configuration #1 chosen from 1 choice
>=20
> dmesg | grep Logitech
> input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
>=20
> I did try out the API example in http://www.linuxtv.org/downloads/video4l=
inux/API/V4L2_API/spec/a16706.htm. However, I get error message stated that=
=A0 '/dev/video0 is no V4L2 device'.
>=20
> Do anyone have any idea?=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
