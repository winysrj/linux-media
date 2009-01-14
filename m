Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EBM1WG007066
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 06:22:01 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0EBLlOv003953
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 06:21:47 -0500
Received: by bwz13 with SMTP id 13so1379017bwz.3
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 03:21:47 -0800 (PST)
Message-ID: <62e5edd40901140321tb436157mae3ed58b88066489@mail.gmail.com>
Date: Wed, 14 Jan 2009 12:21:46 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Salvatore De Paolis" <depaolis.salvatore@libero.it>
In-Reply-To: <20090114113155.570da69f@pc3-sid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090114113155.570da69f@pc3-sid>
Cc: video4linux-list@redhat.com
Subject: Re: gspca pac7311 with v4l2
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

2009/1/14 Salvatore De Paolis <depaolis.salvatore@libero.it>:
> Hi all
> I updated the kernel to the newest stable, 2.6.28 and i noticed some changes in
> v4l.
> I have a Trust webcam which is driven by gspca, in detail pac7311.
> When i run xawtv the webcam led blink for a while and stops and i can see the
> screen in black.
> Here is some log, please if you need something more just ask me.
>
> Sal

Please ensure that you have libv4l installed.

Regards,
Erik

> ---
>
> $ dmesg | tail
> [drm] Initialized i915 1.6.0 20080730 on minor 0
> usb 1-2: new full speed USB device using uhci_hcd and address 2
> usb 1-2: configuration #1 chosen from 1 choice
> gspca: main v2.3.0 registered
> gspca: probing 093a:2608
> gspca: probe ok
> gspca: probing 093a:2608
> gspca: probing 093a:2608
> usbcore: registered new interface driver pac7311
> pac7311: registered
>
> $ xawtv -hwscan
> This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.28)
> looking for available devices
> port 83-98
>    type : Xvideo, image scaler
>    name : Intel(R) Textured Video
>
> port 99-99
>    type : Xvideo, image scaler
>    name : Intel(R) Video Overlay
>
> /dev/video0: OK                         [ -device /dev/video0 ]
>    type : v4l2
>    name : USB Camera (093a:2608)
>    flags:  capture
>
> $ xawtv
> This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.28)
> xinerama 0: 1024x768+0+0
> /dev/video0 [v4l2]: no overlay support
> v4l-conf had some trouble, trying to continue anyway
> Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to
> type FontStruct no way to get: 384x288 32 bit TrueColor (LE: bgr-)
>
> $ v4l-conf
> v4l-conf: using X11 display :0.0
> dga: version 2.0
> mode: 1024x768, depth=24, bpp=32, bpl=4096, base=0xc0800000
> /dev/video0 [v4l2]: no overlay support
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
