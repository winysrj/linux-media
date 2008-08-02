Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m726bwaY020158
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 02:37:58 -0400
Received: from mout0.freenet.de (mout0.freenet.de [195.4.92.90])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m726bjvF002700
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 02:37:45 -0400
From: Sascha Sommer <saschasommer@freenet.de>
To: ar-grig@mail.ru
Date: Sat, 2 Aug 2008 08:39:16 +0200
References: <4890438E.8070703@mail.ru>
In-Reply-To: <4890438E.8070703@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808020839.16696.saschasommer@freenet.de>
Cc: cavedon@sssup.it, video4linux-list@redhat.com
Subject: Re: em28xx problem
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

Hi,

On Mittwoch, 30. Juli 2008, ar wrote:
> Hi !
> I have problems with em28xx --- no signal in tvtime and xawtv:
>
> kerne1 2.6.24.5
> v4l snapspot: f1cc98803a31
> device: intex gravity usb 2.0 tv box (works properly under XP)
> model No: IT-200USB made in China
> lsusb output:   Bus 001 Device 011: ID eb1a:2821 eMPIA Technology, Inc.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I guess Markus might know more about the em2821 chips.

> card number 1 selected automatically
> can not select tuner
> dmesg output:
> em28xx v4l2 driver version 0.1.0 loaded
> em28xx new video device (eb1a:2821): interface 0, class 255
> em28xx Has usb audio class
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
> saa7115' 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> em28xx #0: found i2c device @ 0x4a [saa7113h]
> em28xx #0: found i2c device @ 0x60 [remote IR sensor]
> em28xx #0: found i2c device @ 0xc6 [tuner (analog)]
> em28xx #0: Your board has no unique USB ID.
> em28xx #0: A hint were successfully done, based on i2c devicelist hash.
> em28xx #0: This method is not 100% failproof.
> em28xx #0: If the board were missdetected, please email this log to:
> em28xx #0:      V4L Mailing List  <video4linux-list@redhat.com>
> em28xx #0: Board detected as V-Gear PocketTV
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I think it is misdetected. The V-Gear PocketTV is an em2800 chip whereas the 
usb id indicates an em2820 chip.
You might want to try to modprobe the driver with card=Nr

Where nr is one of the em2820 chips from:

  0 -> Unknown EM2800 video grabber             (em2800)        [eb1a:2800]
  1 -> Unknown EM2750/28xx video grabber        (em2820/em2840) 
[eb1a:2750,eb1a:2820,eb1a:2821,eb1a:2860,eb1a:2861,eb1a:2870,eb1a:2881,eb1a:2883]
  2 -> Terratec Cinergy 250 USB                 (em2820/em2840) [0ccd:0036]
  3 -> Pinnacle PCTV USB 2                      (em2820/em2840) [2304:0208]
  4 -> Hauppauge WinTV USB 2                    (em2820/em2840) 
[2040:4200,2040:4201]
  5 -> MSI VOX USB 2.0                          (em2820/em2840)
  6 -> Terratec Cinergy 200 USB                 (em2800)
  7 -> Leadtek Winfast USB II                   (em2800)
  8 -> Kworld USB2800                           (em2800)
  9 -> Pinnacle Dazzle DVC 90/DVC 100           (em2820/em2840) 
[2304:0207,2304:021a]
 10 -> Hauppauge WinTV HVR 900                  (em2880)        
[2040:6500,2040:6502]
 11 -> Terratec Hybrid XS                       (em2880)        [0ccd:0042]
 12 -> Kworld PVR TV 2800 RF                    (em2820/em2840)
 13 -> Terratec Prodigy XS                      (em2880)        [0ccd:0047]
 14 -> Pixelview Prolink PlayTV USB 2.0         (em2820/em2840)
 15 -> V-Gear PocketTV                          (em2800)
 16 -> Hauppauge WinTV HVR 950                  (em2880)        [2040:6513]

Maybe one of those works.


> em28xx #0: i2c write timed out
> em28xx #0: i2c write timed out
> em28xx #0: i2c write timed out
> em28xx #0: i2c write timed out
> em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
> em28xx #0: Found V-Gear PocketTV
> usbcore: registered new interface driver em28xx
> ---------------------------END DMESG OUTPUT------------------------------
>
> so seems to be V-Gear PocketTV -- but no signal detected
> i am using PAL, and east-european channel list -- it works with xawtv on
> my other pci tv card (bttv driver)
>
>

Regards

Sascha

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
