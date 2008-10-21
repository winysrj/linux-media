Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LJDHDS015361
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 15:13:17 -0400
Received: from tsysmx2.t-systems.co.za (tsysmx2.t-systems.co.za
	[196.13.142.12])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9LJBQrJ010612
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 15:11:27 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Tue, 21 Oct 2008 21:15:01 +0200
Message-ID: <9D14A4B03ED2FD43A59EDD4038F9699B1089CDAE@s4zam1syex01.za01.t-systems.com>
From: "Cobus van Rooyen" <Cobus.vanRooyen@t-systems.co.za>
To: <video4linux-list@redhat.com>
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: Kworld vs-usb2800d on Fedora 9
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

Hi;
I wish I could say I'm a newbie to Linux but alas...  I know enough to
both enjoy and get myself in trouble when playing with Linux.
=20
I bought an IR security camera and want to connect it to my laptop which
will store the video feed via USB.  I use the KWorld vs-usb2800
<http://www.tigerdirect.com/applications/SearchTools/item-details.asp?Ed
pNo=3D612720&Sku=3DO38-1022>  DVD Maker device.  I think I have sorted ou=
t
ZoneMinder's dependancies but now have a problem with getting a video
feed.  I see that Clinton
<http://lists-archives.org/video4linux/22630-kworld-vs-usb2800d.html>
did get it to work but on 64 bit.  I have tried to follow his steps and
am short of the v4l-dvb only - can get it next week when I can connect
my laptop to the 'net again.
=20
I think however that my problem can be solved without the dvb software -
I just need to figure out how to modprobe and change the card type.=20
=20
I have tried to modprobe - r but get a "in use" error...
=20
I'm positive that I will be able to set up my security solution using
Linux and would be most happy.  Just as an aside - I'm using Fedora
because it apparently is the only distro currently picking up the EM28xx
chip but I'm actualy an openSuSE fan.  Does anyone here know if I can
get it working in openSuSE?
=20
Below is an excerpt of my dmesg:
=20
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
em28xx #0: Your board has no unique USB ID and thus need a hint to be
detected.
em28xx #0: You may try to use card=3D<n> insmod option to workaround that=
.
em28xx #0: Please send an email with this log to:
em28xx #0:  V4L Mailing List <video4linux-list@redhat.com>
em28xx #0: Board eeprom hash is 0x00000000
em28xx #0: Board i2c devicelist hash is 0x1ba50080
em28xx #0: Here is a list of valid choices for the card=3D<n> insmod
option:
em28xx #0:     card=3D0 -> Unknown EM2800 video grabber
em28xx #0:     card=3D1 -> Unknown EM2750/28xx video grabber
em28xx #0:     card=3D2 -> Terratec Cinergy 250 USB
em28xx #0:     card=3D3 -> Pinnacle PCTV USB 2
em28xx #0:     card=3D4 -> Hauppauge WinTV USB 2
em28xx #0:     card=3D5 -> MSI VOX USB 2.0
em28xx #0:     card=3D6 -> Terratec Cinergy 200 USB
em28xx #0:     card=3D7 -> Leadtek Winfast USB II
em28xx #0:     card=3D8 -> Kworld USB2800
em28xx #0:     card=3D9 -> Pinnacle Dazzle DVC 90/DVC 100
em28xx #0:     card=3D10 -> Hauppauge WinTV HVR 900
em28xx #0:     card=3D11 -> Terratec Hybrid XS
em28xx #0:     card=3D12 -> Kworld PVR TV 2800 RF
em28xx #0:     card=3D13 -> Terratec Prodigy XS
em28xx #0:     card=3D14 -> Pixelview Prolink PlayTV USB 2.0
em28xx #0:     card=3D15 -> V-Gear PocketTV
em28xx #0:     card=3D16 -> Hauppauge WinTV HVR 950
ath5k phy0: Atheros AR5213 chip found (MAC: 0x56, PHY: 0x41)
ath5k phy0: RF5111 5GHz radio found (0x17)
ath5k phy0: RF2111 2GHz radio found (0x23)
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Unknown EM2750/28xx video grabber
usbcore: registered new interface driver em28xx


This message and/or attachment(s) may contain privileged or confidential =
=20      =20
information. If you are not the intended recipient you may not disclose o=
r       =20
distribute any of the information contained within this message. In such
case you must destroy this message and inform the sender of the error.
T-Systems does not accept liability for any errors, omissions, informatio=
n
and viruses contained in the transmission of this message. Any opinions, =

conclusions and other information contained within this message not relat=
ed=20
to T-Systems' official business is deemed to be that of the individual on=
ly=20
and is not endorsed by T-Systems.       =20
=20                                                                      =
=20         =20
T-Systems - Business Flexibility
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
