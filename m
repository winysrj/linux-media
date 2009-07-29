Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6TEYSgt004485
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 10:34:28 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6TEYBcI020081
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 10:34:11 -0400
Received: by qw-out-2122.google.com with SMTP id 5so375159qwi.39
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 07:34:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7058FA.4060409@gmail.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<1246654555282-3203325.post@n2.nabble.com>
	<1246882966.1165.1323684945@webmail.messagingengine.com>
	<4A7058FA.4060409@gmail.com>
Date: Wed, 29 Jul 2009 10:34:11 -0400
Message-ID: <829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "buhochileno@gmail.com" <buhochileno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: V4L Mailing List <video4linux-list@redhat.com>
Subject: Re: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera -
	No Composite Input
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

On Wed, Jul 29, 2009 at 10:13 AM,
buhochileno@gmail.com<buhochileno@gmail.com> wrote:
> Hi Kay,
>
> Sadly in my case it not work, in my case is the Robotis expert kit wireless
> camera set that is recognized by my fedora10 (kernel  2.6.27.15-170.2.24) as
> a PointNix Intra-Oral  and it also have a Composite and also a Turner, so I
> make another post to the v4l list with my dmesg info, here is what the dmesg
> tell me just in case:
>
> usb 1-3: new high speed USB device using ehci_hcd and address 5
> usb 1-3: configuration #1 chosen from 1 choice
> em28xx new video device (eb1a:2860): interface 0, class 255
> em28xx Doesn't have usb audio class
> em28xx #0: Alternate settings: 8
> em28xx #0: Alternate setting 0, max size= 0
> em28xx #0: Alternate setting 1, max size= 0
> em28xx #0: Alternate setting 2, max size= 1448
> em28xx #0: Alternate setting 3, max size= 2048
> em28xx #0: Alternate setting 4, max size= 2304
> em28xx #0: Alternate setting 5, max size= 2580
> em28xx #0: Alternate setting 6, max size= 2892
> em28xx #0: Alternate setting 7, max size= 3072
> em28xx #0: chip ID is em2860
> saa7115' 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> em28xx #0: found i2c device @ 0x4a [saa7113h]
> em28xx #0: Your board has no unique USB ID.
> em28xx #0: A hint were successfully done, based on i2c devicelist hash.
> em28xx #0: This method is not 100% failproof.
> em28xx #0: If the board were missdetected, please email this log to:
> em28xx #0:     V4L Mailing List  <video4linux-list@redhat.com>
> em28xx #0: Board detected as PointNix Intra-Oral Camera
> em28xx #0: Registering snapshot button...
> input: em28xx snapshot button as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input11
> em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> em28xx-audio.c: probing for em28x1 non standard usbaudio
> em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> em28xx #0: Found PointNix Intra-Oral Camera
> usb 1-3: New USB device found, idVendor=eb1a, idProduct=2860
> usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>
> Cheers,
>
> Mauricio

Hello Mauricio,

If the above is your dmesg output, then you did not properly install
the v4l-dvb tree as described here:

http://linuxtv.org/repo

I can tell from the dmesg output that the code you are running in
still very old.  The current code will now dump out the "Alternate
Setting" lines and will identify the device as an "em28xx/saa713x
reference design".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
