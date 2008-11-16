Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGH1qSD002459
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 12:01:52 -0500
Received: from tomts27-srv.bellnexxia.net (tomts27.bellnexxia.net
	[209.226.175.101])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAGH1JmX020102
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 12:01:19 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: Markus Rechberger <mrechberger@gmail.com>
Date: Sun, 16 Nov 2008 12:00:33 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB101208165C79D39B@Colmatec004.COLMATEC.INT>
References: <09CD2F1A09A6ED498A24D850EB101208165C79D399@Colmatec004.COLMATEC.INT>,
	<d9def9db0811142147k4405d5fbq24744d7db22e9986@mail.gmail.com>
In-Reply-To: <d9def9db0811142147k4405d5fbq24744d7db22e9986@mail.gmail.com>
Content-Language: fr-CA
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE : crop problem... or scaling with em28xx with 2860empiatech
 chipset kworld usb device
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

it'S no problem use tvtime and set up the overscan option. The show
isn't transmitted in a perfecet way the next show could
already use more of the available surface.

Do you know what v4l2 driver or function to do the samething as tvtime option OVERSCAN?
________________________________________
De : Markus Rechberger [mrechberger@gmail.com]
Date d'envoi : 15 novembre 2008 00:47
À : Jonathan Lafontaine
Cc : video4linux-list@redhat.com
Objet : Re: crop problem... or scaling with em28xx with 2860empiatech chipset kworld usb device

On Fri, Nov 14, 2008 at 5:32 PM, Jonathan Lafontaine
<jlafontaine@ctecworld.com> wrote:
> HI, I got a KWORLD usb 28000d
>
> detected by lspci 2860 emphia tec chipset.
>
> Bus 006 Device 011: ID eb1a:2860 eMPIA Technology, Inc.
>
>
> When I use V4L2 with experimental drivers OR NOT ex from mcentral, I want to get NTSC 640 X 480 pictures
>
> (at least 720x480 --> full crop cap size from v4l2 application)
>
> But, unfortunately, If I use this standard I have some lines at the bottom of the pictures empty (black)
>
> If I Use PAL_M, theres black lines at the right (12 pixel)
>
> i use this for video treatment and I dont want to use scaling options... cause I will lose precision, accuracy
>
> My device with standard modprobe launch is detected like a card=53 -> Typhoon DVD Maker
>
> I used others like generic 2860
>
> I got no picture or same problem
>
> I think theres no eeprom in this version of the dvd maker. maybe correct me
>
> but thats why the driver with standard modprobe command choose to use typhoon really similar video grabber (external physical look )
>
> http://www.rueducommerce.fr/Photo-Video-Numerique/Acquisition/Boitier-Externe/TYPHOON/376625-DVD-Maker-Boitier-d-acquisition-Video-pour-cassettes-VHS.htm
>
>
> Can u explain me how to use the not experimental version of the driver or it will change nothing... question mark
>
> http://mcentral.de/screenshots/full/xgl_pinnacle_pctv_usb2_analog.jpg
>
> look this picture similar problem
>

it'S no problem use tvtime and set up the overscan option. The show
isn't transmitted in a perfecet way the next show could
already use more of the available surface.

> I<M from canada, I think my produtcs were ordered by tiger direct
>
> http://www.kworlduk.com/products/usb2800d/index.php
>
> I only found the dvd maker on the uk site
>
> but have a look at http://www.kworldcomputer.com/
>
> IF any details I can add to this email me back!
>
>
> [10339.953650] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> [10339.966602] attach_inform: saa7113 detected.
> [10339.977444] em28xx #0: found i2c device @ 0x4a [saa7113h]
> [10340.000810] em28xx #0: V4L2 device registered as /dev/video0
> [10340.000813] em28xx #0: Found Hauppauge WinTV USB 2
> [10340.000831] usbcore: registered new interface driver em28xx
> [10427.436411] usbcore: deregistering interface driver em28xx
> [10427.436452] em28xx #0: disconnecting em28xx#0 video
> [10427.436454] em28xx #0: V4L2 VIDEO devices /dev/video0 deregistered
> [10428.442900] Linux video capture interface: v2.00
> [10428.450875] em28xx v4l2 driver version 0.0.1 loaded
> [10428.450915] em28xx new video device (eb1a:2860): interface 0, class 255
> [10428.450918] em28xx: device is attached to a USB 2.0 bus
> [10428.450920] em28xx: you're using the experimental/unstable tree from mcentral.de
> [10428.450922] em28xx: there's also a stable tree available but which is limited to
> [10428.450923] em28xx: linux <=2.6.19.2
> [10428.450924] em28xx: it's fine to use this driver but keep in mind that it will move
> [10428.450926] em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
> [10428.450927] em28xx: proved to be stable

this source is months old, and not even available anymore, it has been
symlinked to something else nowadays.

Markus

> [10428.450930] em28xx #0: Alternate settings: 8
> [10428.450931] em28xx #0: Alternate setting 0, max size= 0
> [10428.450933] em28xx #0: Alternate setting 1, max size= 0
> [10428.450934] em28xx #0: Alternate setting 2, max size= 1448
> [10428.450936] em28xx #0: Alternate setting 3, max size= 2048
> [10428.450938] em28xx #0: Alternate setting 4, max size= 2304
> [10428.450939] em28xx #0: Alternate setting 5, max size= 2580
> [10428.450941] em28xx #0: Alternate setting 6, max size= 2892
> [10428.450942] em28xx #0: Alternate setting 7, max size= 3072
> [10428.500907] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> [10428.513857] attach_inform: saa7113 detected.
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--

This message has been verified by LastSpam (http://www.lastspam.com) eMail security service, provided by SoluLAN
Ce courriel a ete verifie par le service de securite pour courriels LastSpam (http://www.lastspam.com), fourni par SoluLAN (http://www.solulan.com)
www.solulan.com


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
