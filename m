Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01HwRoN030402
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 12:58:27 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01HvKCM010155
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 12:57:20 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2461566qwe.39
	for <video4linux-list@redhat.com>; Thu, 01 Jan 2009 09:57:19 -0800 (PST)
Message-ID: <412bdbff0901010957x7930dc1fha5c3722e77582642@mail.gmail.com>
Date: Thu, 1 Jan 2009 12:57:19 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Hans-Georg Heinscher" <hanson@onlinehome.de>
In-Reply-To: <495CFC8E.2070505@onlinehome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495CFC8E.2070505@onlinehome.de>
Cc: video4linux-list@redhat.com
Subject: Re: em28xx-problem: new ? board id [eb1a:2870]
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

On Thu, Jan 1, 2009 at 12:25 PM, Hans-Georg Heinscher
<hanson@onlinehome.de> wrote:
> Hi,
> I've made tests with my Samsung X20-Notebook (Centrino 1.6Ghz) board:
>
> *Model*: Pinnacle PCTV USB Stick (DVB-T)
> *Vendor/Product id*: [eb1a:2870].
>
> *Tests made*: - functions well under Windows XP
>
> - Ubuntu 8.10: Problem recognizing DVB-T (see below)
> lsusb (only once after restart) shows: Bus 005 Device 003: ID eb1a:2870
> eMPIA Technology, Inc.
> File em28xx was put in /etc/modprobe.d containing:
> alias char-major-81 videodev
> alias char-major-81-0 tveeprom
> alias char-major-81-1 em28xx
> options em28xx card=03
> options tuner pal=b secam=b
>
> Devices /dev/video0 and /dev/vbi0 are recognized.
>
> BUT: I cannot get the video / receiver part running:
>
> me-tv doesn't know any device:      me-tv expects nonexistent devices
> /dev/dvb/adapter/.. (in ~/.me-tv/me-tv.config) ???
> kaffeine: Binding to DVB-Client not possible.      DVB-Client: Address:
> 192.168.0.255; Ports: 1234 and 1235
>      I have put local channels.dvb in ~/.kde/share/apps/kaffeine.
> What to do ? What card-No. to choose for em28xx?
> What is missing for installation?
>
> Tested by: Hanson@onlinehome.de
> ------------------
> dmesg | grep em28xx
> [  150.712474] em28xx v4l2 driver version 0.1.0 loaded
> [  150.712792] em28xx new video device (eb1a:2870): interface 0, class 255
> [  150.712801] em28xx Doesn't have usb audio class
> [  150.712804] em28xx #0: Alternate settings: 8
> [  150.712806] em28xx #0: Alternate setting 0, max size= 0
> [  150.712809] em28xx #0: Alternate setting 1, max size= 0
> [  150.712812] em28xx #0: Alternate setting 2, max size= 1448
> [  150.712815] em28xx #0: Alternate setting 3, max size= 2048
> [  150.712818] em28xx #0: Alternate setting 4, max size= 2304
> [  150.712821] em28xx #0: Alternate setting 5, max size= 2580
> [  150.712823] em28xx #0: Alternate setting 6, max size= 2892
> [  150.712826] em28xx #0: Alternate setting 7, max size= 3072
> [  150.714664] em28xx #0: em28xx chip ID = 35
> [  150.982141] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00
> 6a 22 00 00
> [  150.982166] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00
> 00 00 00 00
> [  150.982184] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00
> 5b 00 00 00
> [  150.982201] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00
> 06 f8 f1 47
> [  150.982219] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982236] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982253] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03
> 55 00 53 00
> [  150.982270] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00
> 20 00 44 00
> [  150.982287] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00
> 00 00 00 00
> [  150.982305] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982322] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982339] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982356] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982373] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982390] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  150.982407] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [  151.274387] tuner' 0-0060: chip found @ 0xc0 (em28xx #0)
> [  151.880148] em28xx #0: V4L2 device registered as /dev/video0 and
> /dev/vbi0
> [  151.882078] em28xx #0: Found Pinnacle PCTV USB 2
> [  151.894399] usbcore: registered new interface driver em28xx
> [  151.926252] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [  151.926268] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

There is active development going on for this device.  Hoping to have
it working in the next week or so.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
