Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUHHqpa020707
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 12:17:52 -0500
Received: from web88206.mail.re2.yahoo.com (web88206.mail.re2.yahoo.com
	[206.190.37.221])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBUHHc78022952
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 12:17:38 -0500
Date: Tue, 30 Dec 2008 09:17:37 -0800 (PST)
From: Dwaine Garden <dwainegarden@rogers.com>
To: Michael Zapf <newsmail08@mizapf.eu>, video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <847660.41571.qm@web88206.mail.re2.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Re: USBVision: Camtel USB Video Genie Supported?
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

Did you get the device to work?=0A=0A=0A=0A=0A_____________________________=
___=0AFrom: Michael Zapf <newsmail08@mizapf.eu>=0ATo: video4linux-list@redh=
at.com=0ASent: Sunday, December 21, 2008 6:32:39 PM=0ASubject: USBVision: C=
amtel USB Video Genie Supported?=0A=0AHello,=0A=0AI somehow can't get the U=
SB Video Genie to work with VLC or xawtv, so I=0Asuppose the problem starts=
 in v4l. The device is a small USB box with a=0Agrey button and a S-Video a=
nd a Composite input jack. Plugging the USB=0Abox in, I get=0A=0Akernel: us=
b 6-2: new full speed USB device using uhci_hcd and address 2=0Akernel: usb=
 6-2: new device found, idVendor=3D0573, idProduct=3D0003=0Akernel: usb 6-2=
: new device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0=0Akernel: usb =
6-2: configuration #1 chosen from 1 choice=0Akernel: Linux video capture in=
terface: v2.00=0Akernel: usbvision_probe: USBGear USBG-V1 resp. HAMA USB fo=
und=0Akernel: USBVision[0]: registered USBVision Video device /dev/video0 [=
v4l2]=0Akernel: USBVision[0]: registered USBVision VBI device /dev/vbi0 [v4=
l2]=0A(Not Working Yet!)=0Akernel: usbcore: registered new interface driver=
 usbvision=0Akernel: USBVision USB Video Device Driver for Linux : 0.9.9=0A=
kernel: saa7115 1-0024: saa7111 found (1f7111d1e200000) @ 0x48=0A(usbvision=
 #0)=0A=0AThat's all I find in the log. From v4l-info I get=0A=0A### v4l2 d=
evice info [/dev/video0] ###=0Ageneral info=0A=A0 =A0 VIDIOC_QUERYCAP=0A=A0=
 =A0 =A0 =A0 driver=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : "USBVision"=0A=A0 =
=A0 =A0 =A0 card=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : "USBGear USBG-V1 =
resp. HAMA USB"=0A=A0 =A0 =A0 =A0 bus_info=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 :=
 "6-2"=0A=A0 =A0 =A0 =A0 version=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 0.9.9=0A=
=A0 =A0 =A0 =A0 capabilities=A0 =A0 =A0 =A0 =A0 =A0 : 0x5020001=0A[VIDEO_CA=
PTURE,AUDIO,READWRITE,STREAMING]=0A=0A...=0A=0AVLC does not open a window w=
hen I select the device for play; doing a=0Aplain "cat /dev/video0" does no=
t produce anything. Tried the different=0Ainputs, no result. Am I missing s=
omething here? Do I require a special=0Afirmware for this device?=0A=0AThan=
ks for any help,=0A=0AMichael=0A=0A--=0Avideo4linux-list mailing list=0AUns=
ubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe=
=0Ahttps://www.redhat.com/mailman/listinfo/video4linux-list=0A
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
