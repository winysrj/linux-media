Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHDXewc020431
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 08:33:40 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHDXOrS000369
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 08:33:24 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1659061fga.7
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 05:33:23 -0800 (PST)
Message-ID: <412bdbff0812170533h1e1d4017i908003af0c592918@mail.gmail.com>
Date: Wed, 17 Dec 2008 08:33:23 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Umar <unix.co@gmail.com>
In-Reply-To: <1229514568468-1667543.post@n2.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229514568468-1667543.post@n2.nabble.com>
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle USB Stick 2870
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

On Wed, Dec 17, 2008 at 6:49 AM, Umar <unix.co@gmail.com> wrote:
>
> Hi Dear Members!
>
> I am trying to get my Pinnacle PCTV USB (DVB-T device [eb1a:2870]) to
> work on my Slackware 12.1 Linux. I fetched sources from
> http://linuxtv.org/hg/v4l-dvb and then did a make, make install and make
> load.
>
> After the reboot I did try tvtime. A blank screen is appear there no
> picture.
>
> Here is my dmesg logs.
>
> usb 1-6: new high speed USB device using ehci_hcd and address 3
> usb 1-6: configuration #1 chosen from 1 choice
> em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870, interface 0, class
> 0)
> em28xx #0: Identified as Pinnacle PCTV USB 2 (card=3)
> em28xx #0: em28xx chip ID = 35
> Chip ID is not zero. It is not a TEA5767
> tuner' 2-0060: chip found @ 0xc0 (em28xx #0)
> em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
> em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
> em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 9f 4f a5 4a
> em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
> em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
> em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xcf6a1fc3
> em28xx #0: EEPROM info:
> em28xx #0: No audio on board.
> em28xx #0: 500mA max power
> em28xx #0: Table at 0x04, strings=0x226a, 0x0000, 0x0000
> tuner-simple 2-0060: creating new instance
> tuner-simple 2-0060: type set to 56 (Philips PAL/SECAM multi (FQ1216AME
> MK4))
> em28xx #0: Config register raw data: 0xc0
> em28xx #0: No AC97 audio processor
> em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> em28xx-audio.c: probing for em28x1 non standard usbaudio
> em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>
>
> Please help what should i do?
>
> Regards,
>
> Umar
> --
> View this message in context: http://n2.nabble.com/Pinnacle-USB-Stick-2870-tp1667543p1667543.html
> Sent from the video4linux-list mailing list archive at Nabble.com.
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Hello Umar,

On Sunday I sent a patch to a user for this device for testing.  I am
waiting to hear back from that person.

Work is ongoing for this device, and I hope to have it working soon.
Check back in a few days.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
