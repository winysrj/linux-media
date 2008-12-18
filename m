Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBI0BE2J031387
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 19:11:14 -0500
Received: from bay0-omc2-s12.bay0.hotmail.com (bay0-omc2-s12.bay0.hotmail.com
	[65.54.246.148])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBI0AxEF013061
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 19:10:59 -0500
Message-ID: <BAY135-W40EFD75EC68542FE991AB0BFF30@phx.gbl>
From: Lehel Kovach <lehelkovach@hotmail.com>
To: <moinejf@free.fr>
Date: Wed, 17 Dec 2008 16:10:58 -0800
In-Reply-To: <1229496250.1747.4.camel@localhost>
References: <BAY135-W47952C51F5ED0CAEE9809BFF50@phx.gbl>
	<1229421997.1745.23.camel@localhost>
	<BAY135-W526C1AC293891AC584A4B7BFF50@phx.gbl>
	<1229496250.1747.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: RE: quickcam express
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


the old cam has this:

Bus 002 Device 002: ID 046d:0840 Logitech=2C Inc. QuickCam Express


[ 2040.384046] usb 2-5: new full speed USB device using ohci_hcd and addres=
s 4
[ 2040.594160] usb 2-5: configuration #1 chosen from 1 choice
[ 2040.596641] quickcam: QuickCam USB camera found (driver version QuickCam=
 USB 0.6.6 $Date: 2006/11/04 08:38:14 $)
[ 2040.596659] quickcam: Kernel:2.6.27-9-generic bus:2 class:FF subclass:FF=
 vendor:046D product:0840
[ 2040.611297] quickcam: Sensor HDCS-1000/1100 detected
[ 2040.621744] quickcam: Registered device: /dev/video0

i bought another quickcam (communicate model) and tried it out and got this=
:

Bus 002 Device 005: ID 046d:089d Logitech=2C Inc.=20

[ 2190.096046] usb 2-5: new full speed USB device using ohci_hcd and addres=
s 5
[ 2190.300304] usb 2-5: configuration #1 chosen from 1 choice
[ 2190.641232] usbcore: registered new interface driver snd-usb-audio

(the video portion of it didn't register)



> Subject: RE: quickcam express
> From: moinejf@free.fr
> To: lehelkovach@hotmail.com
> CC: video4linux-list@redhat.com
> Date: Wed=2C 17 Dec 2008 07:44:10 +0100
>=20
> On Tue=2C 2008-12-16 at 08:42 -0800=2C Lehel Kovach wrote:
> > its  a logitech quickcam express -- the old one: model# 961121-0403
> >=20
> > im using 0.6.6 i believe (the one with distroed with ubuntu 8.1). =20
>=20
> Bad answer! I want to know the vendor and product IDs and also which
> Linux driver handles your webcam. Please do:
> 	lsusb
> and
> 	dmesg | tail -20
> after connecting the webcam.
>=20
> --=20
> Ken ar c'henta=F1 |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>=20
>=20
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
