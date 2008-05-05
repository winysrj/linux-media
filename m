Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45E8oaq014710
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 10:08:50 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m45E86Hx004069
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 10:08:18 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1062141rvb.51
	for <video4linux-list@redhat.com>; Mon, 05 May 2008 07:08:06 -0700 (PDT)
Message-ID: <d9def9db0805050708i5cdf35ffke063ab5c80030c3@mail.gmail.com>
Date: Mon, 5 May 2008 16:08:06 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: rmantovani@libero.it
In-Reply-To: <1209993388.17255.20.camel@mandoch.ael.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209993388.17255.20.camel@mandoch.ael.it>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: em28xx based intraoral usb camera
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

On Mon, May 5, 2008 at 3:16 PM, Roberto Mantovani - A&L
<rmantovani@libero.it> wrote:
> Hi to all,
>
>  Im'trying to use an intra-oral usb camera produced by Pointnix on Linux.
>  It's based on an em28xx chipset, this is the output of lsusb:
>
>  Bus 001 Device 005: ID eb1a:2860 eMPIA Technology, Inc.
>
>  This is the output of dmesg:
>
>  Linux video capture interface: v2.00
>  em28xx v4l2 driver version 0.1.0 loaded
>  em28xx new video device (eb1a:2860): interface 0, class 255
>  em28xx Doesn't have usb audio class
>  em28xx #0: Alternate settings: 8
>  em28xx #0: Alternate setting 0, max size= 0
>  em28xx #0: Alternate setting 1, max size= 0
>  em28xx #0: Alternate setting 2, max size= 1448
>  em28xx #0: Alternate setting 3, max size= 2048
>  em28xx #0: Alternate setting 4, max size= 2304
>  em28xx #0: Alternate setting 5, max size= 2580
>  em28xx #0: Alternate setting 6, max size= 2892
>  em28xx #0: Alternate setting 7, max size= 3072
>  em28xx #0: em28xx chip ID = 34
>  em28xx #0: found i2c device @ 0x4a [saa7113h]
>  em28xx #0: Your board has no unique USB ID and thus need a hint to be
>  detected.
>  em28xx #0: You may try to use card=<n> insmod option to workaround that.
>  em28xx #0: Please send an email with this log to:
>  em28xx #0:      V4L Mailing List <video4linux-list@redhat.com>
>  em28xx #0: Board eeprom hash is 0x00000000
>  em28xx #0: Board i2c devicelist hash is 0x1ba50080
>  em28xx #0: Here is a list of valid choices for the card=<n> insmod
>  option:
>  em28xx #0:     card=0 -> Unknown EM2800 video grabber
>  em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
>  em28xx #0:     card=2 -> Terratec Cinergy 250 USB
>  em28xx #0:     card=3 -> Pinnacle PCTV USB 2
>  em28xx #0:     card=4 -> Hauppauge WinTV USB 2
>  em28xx #0:     card=5 -> MSI VOX USB 2.0
>  em28xx #0:     card=6 -> Terratec Cinergy 200 USB
>  em28xx #0:     card=7 -> Leadtek Winfast USB II
>  em28xx #0:     card=8 -> Kworld USB2800
>  em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
>  em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
>  em28xx #0:     card=11 -> Terratec Hybrid XS
>  em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
>  em28xx #0:     card=13 -> Terratec Prodigy XS
>  em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
>  em28xx #0:     card=15 -> V-Gear PocketTV
>  em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
>  em28xx #0:     card=17 -> PointNix Intra-Oral Camera
>  em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
>  em28xx #0: Found Unknown EM2750/28xx video grabber
>  usbcore: registered new interface driver em28xx
>  em28xx-audio.c: probing for em28x1 non standard usbaudio
>  em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>  Em28xx: Initialized (Em28xx Audio Extension) extension
>
>  As you can see I've created a new card profile in the em28xx driver.
>
>  After executing this command:
>
>  rmmod em28xx_alsa; rmmod em28xx_dvb; rmmod em28xx; modprobe em28xx
>  card=17
>
>
>  the dmesg output is :
>  em28xx v4l2 driver version 0.1.0 loaded
>  em28xx new video device (eb1a:2860): interface 0, class 255
>  em28xx Doesn't have usb audio class
>  em28xx #0: Alternate settings: 8
>  em28xx #0: Alternate setting 0, max size= 0
>  em28xx #0: Alternate setting 1, max size= 0
>  em28xx #0: Alternate setting 2, max size= 1448
>  em28xx #0: Alternate setting 3, max size= 2048
>  em28xx #0: Alternate setting 4, max size= 2304
>  em28xx #0: Alternate setting 5, max size= 2580
>  em28xx #0: Alternate setting 6, max size= 2892
>  em28xx #0: Alternate setting 7, max size= 3072
>  em28xx #0: em28xx chip ID = 34
>  em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
>  em28xx #0: Found PointNix Intra-Oral Camera
>  usbcore: registered new interface driver em28xx
>  em28xx-audio.c: probing for em28x1 non standard usbaudio
>  em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>  Em28xx: Initialized (Em28xx Audio Extension) extension
>
>  My problem is that I cannot see anything usable from the camera, only a
>  green colored image.
>
>  Could you tell me what parameters I need to know from the manufacturer
>  of the
>  intra-oral camera to make it works (resolution, color depth ...) ?
>

I requested some information about that device, let's see.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
