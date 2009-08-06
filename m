Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n76NNgY7030930
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 19:23:42 -0400
Received: from mail-yw0-f197.google.com (mail-yw0-f197.google.com
	[209.85.211.197])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n76NNOFp001892
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 19:23:24 -0400
Received: by ywh35 with SMTP id 35so1580510ywh.19
	for <video4linux-list@redhat.com>; Thu, 06 Aug 2009 16:23:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090807005542.962158ltxqad3b0g@horde.phosco.info>
References: <20090807005542.962158ltxqad3b0g@horde.phosco.info>
Date: Thu, 6 Aug 2009 19:23:24 -0400
Message-ID: <829197380908061623t3f35c75dwb7a22164278294bf@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Andr=E9_Rothe?= <arothe@phosco.info>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: New device
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

On Thu, Aug 6, 2009 at 6:55 PM, André Rothe<arothe@phosco.info> wrote:
> Hi,
>
> I have bought a new video grabber device. It is an USB device from Q-sonic.
> The device is not successfully detected, so there is only an input=0
> available, the S-Video connector. But I get only black-white video, the
> other connector (Composite) delivers color video on Windows, but I cannot
> switch the driver to it.
>
> em28xx v4l2 driver version 0.1.0 loaded
> em28xx new video device (eb1a:2820): interface 0, class 255
> em28xx Doesn't have usb audio class
> em28xx #0: Alternate settings: 8
> em28xx #0: Alternate setting 0, max size= 0
> em28xx #0: Alternate setting 1, max size= 1024
> em28xx #0: Alternate setting 2, max size= 1448
> em28xx #0: Alternate setting 3, max size= 2048
> em28xx #0: Alternate setting 4, max size= 2304
> em28xx #0: Alternate setting 5, max size= 2580
> em28xx #0: Alternate setting 6, max size= 2892
> em28xx #0: Alternate setting 7, max size= 3072
> em28xx #0: em28xx chip ID = 18
> saa7115' 7-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> em28xx #0: found i2c device @ 0x4a [saa7113h]
> em28xx #0: Your board has no unique USB ID.
> em28xx #0: A hint were successfully done, based on i2c devicelist hash.
> em28xx #0: This method is not 100% failproof.
> em28xx #0: If the board were missdetected, please email this log to:
> em28xx #0:      V4L Mailing List  <video4linux-list@redhat.com>
> em28xx #0: Board detected as PointNix Intra-Oral Camera
> em28xx #0: Registering snapshot button...
> input: em28xx snapshot button as
> /devices/pci0000:00/0000:00:1d.7/usb2/2-1/input/input9
> em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> em28xx #0: Found PointNix Intra-Oral Camera
> usbcore: registered new interface driver em28xx
> em28xx-audio.c: probing for em28x1 non standard usbaudio
> em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> Em28xx: Initialized (Em28xx Audio Extension) extension
>
> Thank you
> Andre

Install the latest v4l-dvb code and it should all start working:

http://linuxtv.org/repo

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
