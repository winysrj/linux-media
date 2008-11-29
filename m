Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATL1rv9011459
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 16:01:53 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATL1fl6024336
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 16:01:41 -0500
Message-ID: <4931ADCD.2000407@free.fr>
Date: Sat, 29 Nov 2008 22:02:05 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Chris Grove <dj_gerbil@tiscali.co.uk>
References: <002901c95150$44c16b90$ce4442b0$@co.uk>
In-Reply-To: <002901c95150$44c16b90$ce4442b0$@co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
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

Hi Chris,

Chris Grove wrote:
> Hi there, I've got one of these cards but I'm having trouble getting it to
> work. The problem is that it loads ok, but when I try to use it, it turns
> out that the tuner module has loaded the wrong tuner type. Instead of using
> tuner type 1, a PAL-I tuner which mine is, it selects a PAL-BG tuner. Now
> I've tried using type=1 in the modprobe line but it turns out that, that is
> no longer supported. 
> 
>  
> 
> System Info.
> 
> I'm using GeexBox which is built on linux-2.6.21.3 kernel.
> 
>  
> 
> The Init.d script is:
> 
> #!/bin/sh
> 
> #
> 
> # setup tv cards
> 
> #
> 
> # runlevels: geexbox, debug, install
> 
>  
> 
> echo "### Setting up TV card ###"
> 
> modprobe tuner pal=I
> 
> modprobe tveeprom 
> 
> modprobe usbvision
> 
> modprobe saa7115 
> 
>  
> 
> echo -n "" > /var/tvcard 
> 
> exit 0  
> 
>  
> 
> And the output from dmesg is:
> 
> <6>usbvision_probe: Hauppauge WinTv-USB II (PAL) MODEL 566 found
> 
> <6>USBVision[0]: registered USBVision Video device /dev/video0 [v4l2]
> 
> <6>USBVision[0]: registered USBVision VBI device /dev/vbi0 [v4l2] (Not
> Working Yet!)
> 
> <6>usbcore: registered new interface driver usbvision
> 
> <6>USBVision USB Video Device Driver for Linux : 0.9.9
> 
> <6>eth0: Media Link On 100mbps full-duplex
> 
> <6>tuner 1-0042: chip found @ 0x84 (usbvision #0)
> 
> <6>tda9887 1-0042: tda988[5/6/7] found @ 0x42 (tuner)
> 
> <6>tuner 1-0061: chip found @ 0xc2 (usbvision #0)
> 
> <6>tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
> 
> <6>tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
> 
> <6>saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (usbvision #0)
> 
> <6>tda9887 1-0042: i2c i/o error: rc == -121 (should be 4)
please try a modprobe tda9887 debug=1 to see some debug messages where it fails.
Proceed like this:
modprobe tda9887 debug=1
modprobe saa7115 
modprobe usbvision
Then, plug-in your device.
Geeksbox is based on mplayer, I tested OK mplayer but with some tuning like this:
mplayer -tv driver=v4l2:width=320:height=240:norm=SECAM:outfmt=yuy2:channels=21-F2 tv://

Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
