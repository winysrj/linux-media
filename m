Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOG2eJA017956
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 11:02:40 -0500
Received: from relay-pt2.poste.it (relay-pt2.poste.it [62.241.5.253])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOG2Q6W018379
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 11:02:26 -0500
Received: from geppetto.reilabs.com (78.15.202.84) by relay-pt2.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 49517C0000006C4E for video4linux-list@redhat.com;
	Wed, 24 Dec 2008 17:02:26 +0100
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1LFWA2-00077t-GG
	for video4linux-list@redhat.com; Wed, 24 Dec 2008 17:00:38 +0100
Date: Wed, 24 Dec 2008 17:00:38 +0100
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: video4linux-list Mailing List <video4linux-list@redhat.com>
Message-ID: <20081224160038.GD475@geppetto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: gspca, linux 2.6.26 and ioctl(VIDIOC_QUERYCAP) returning -1,
	what's wrong?
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

Hi all,

I'm using linux 2.6.26 and the Debian gspca module, and I'm getting
ioctl(VIDIOC_QUERYCAP) return -1 after the device is opened.

Do you have any hint to share?

Here there are some relevant informations:

stefano@geppetto ~/s/ffmpeg> uname -a
Linux geppetto 2.6.26-1-686 #1 SMP Sat Oct 18 16:22:25 UTC 2008 i686 GNU/Linux
stefano@geppetto ~/s/ffmpeg> sudo modinfo gspca 
filename:       /lib/modules/2.6.26-1-686/kernel/drivers/usb/media/gspca.ko
author:         Michel Xhaard <mxhaard@users.sourceforge.net> based on spca50x driver by Joel Crisp <cydergoth@users.sourceforge.net>,ov511 driver by Mark McClelland <mwm@i.am>
description:    GSPCA/SPCA5XX USB Camera Driver
license:        GPL
vermagic:       2.6.26-1-686 SMP mod_unload modversions 686 
depends:        usbcore,videodev
alias:          usb:v093Ap2463d*dc*dsc*dp*ic*isc*ip*
[...]
parm:           force_gamma_id:Forced assigning ID of contrast settings (0=default,1,2,3) Zc03xx only (int)
parm:           force_sensor_id:Forced assigning ID sensor (Zc03xx only). Dangerous, only for experts !!! (int)
parm:           lightfreq:Light frequency banding filter. Set to 50 or 60 Hz, or 0 for NoFlicker (default=50) Zc03xx only (int)
parm:           usbgrabber:Is a usb grabber 0x0733:0x0430 ? (default 1)  (int)
parm:           compress:Turn on/off compression (not functional yet) (int)
parm:           GGreen:Gain Green setting range 0 to 512 /256  (int)
parm:           GBlue:Gain Blue setting range 0 to 512 /256  (int)
parm:           GRed:Gain Red setting range 0 to 512 /256  (int)
parm:           OffGreen:OffGreen setting range -128 to 128 (int)
parm:           OffBlue:OffBlue setting range -128 to 128 (int)
parm:           OffRed:OffRed setting range -128 to 128 (int)
parm:           gamma:gamma setting range 0 to 7 3-> gamma=1 (int)
parm:           force_rgb:Read RGB instead of BGR (int)
parm:           debug:Debug level: 0=none, 1=init/detection, 2=warning, 3=config/control, 4=function call, 5=max (int)
parm:           autoexpo:Enable/Disable auto exposure (default=1: enabled) (PC-CAM 600/Zc03xx/spca561a/Etoms Only !!!) (int)

stefano@geppetto ~/s/ffmpeg> dmesg
[...]
[38586.942147] Linux video capture interface: v2.00
[38586.945359] gspca: USB GSPCA camera found.(ZC3XX) 
[38586.945359] gspca: [spca5xx_probe:4275] Camera type JPEG 
[38587.582486] gspca: [zc3xx_config:669] Find Sensor HV7131R(c)
[38587.586948] gspca: [spca5xx_getcapability:1249] maxw 640 maxh 480 minw 160 minh 120
[38587.586948] usbcore: registered new interface driver gspca
[38587.586948] gspca: gspca driver 01.00.20 registered
[38611.561635] gspca: [spca5xx_set_light_freq:1932] Sensor currently not support light frequency banding filters.
[38611.561740] gspca: [gspca_set_isoc_ep:945] ISO EndPoint found 0x81 AlternateSet 7
[38627.563632] gspca: [spca5xx_set_light_freq:1932] Sensor currently not support light frequency banding filters.
[38627.563726] gspca: [gspca_set_isoc_ep:945] ISO EndPoint found 0x81 AlternateSet 7
[38629.217385] gspca: [spca5xx_do_ioctl:2124] Bridge ZC301-2 
[38634.087208] gspca: [spca5xx_set_light_freq:1932] Sensor currently not support light frequency banding filters.
[38634.087208] gspca: [gspca_set_isoc_ep:945] ISO EndPoint found 0x81 AlternateSet 7

The failing application is ffplay (ffplay -s 320x240 -f video4linux2
/dev/video0) if that matters.

Regards.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
