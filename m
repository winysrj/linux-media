Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m830aIk3020692
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 20:36:18 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m830ZZgA025772
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 20:35:35 -0400
Received: by wx-out-0506.google.com with SMTP id i27so664928wxd.6
	for <video4linux-list@redhat.com>; Tue, 02 Sep 2008 17:35:35 -0700 (PDT)
Date: Tue, 2 Sep 2008 21:34:40 -0400
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080902213440.43bffd9d@gmail.com>
In-Reply-To: <1220396812.3752.46.camel@lars-laptop>
References: <1220396812.3752.46.camel@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: em28xx-based KWorld 310U delivers no signal, 2 drivers tried
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

Hello Lars,

On Wed, 03 Sep 2008 01:06:52 +0200
Lars Oliver Hansen <lolh@ymail.com> wrote:

> 
> Then I switched to the v4l-dvb driver which is the first link in the
> users section on v4l wikis main page. This driver put out to dmesg: 
> 
> [    0.000000] Linux video capture interface: v2.00
> [    0.000000] em28xx v4l2 driver version 0.1.0 loaded
> [    0.000000] em28xx new video device (eb1a:e310): interface 0, class
> 255
> [    0.000000] em28xx Has usb audio class
> [    0.000000] em28xx #0: Alternate settings: 8
> [    0.000000] em28xx #0: Alternate setting 0, max size= 0
> [    0.000000] em28xx #0: Alternate setting 1, max size= 0
> [    0.000000] em28xx #0: Alternate setting 2, max size= 1448
> [    0.000000] em28xx #0: Alternate setting 3, max size= 2048
> [    0.000000] em28xx #0: Alternate setting 4, max size= 2304
> [    0.000000] em28xx #0: Alternate setting 5, max size= 2580
> [    0.000000] em28xx #0: Alternate setting 6, max size= 2892
> [    0.000000] em28xx #0: Alternate setting 7, max size= 3072
> [    0.000000] em28xx #0: chip ID is em2882/em2883
> [    0.000000] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 50 12
> 5c 03 6a 22 00 00
> [    0.000000] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00
> 00 00 5b 1e 00 00
> [    0.000000] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
> 22 03 55 00 53 00
> [    0.000000] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
> 31 00 20 00 44 00
> [    0.000000] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    0.000000] EEPROM ID= 0x9567eb1a, hash = 0x966a0441
> [    0.000000] Vendor/Product ID= eb1a:e310
> [    0.000000] AC97 audio (5 sample rates)
> [    0.000000] 500mA max power
> [    0.000000] Table at 0x04, strings=0x226a, 0x0000, 0x0000
> [    0.000000] em28xx #0: 
> [    0.000000] 
> [    0.000000] em28xx #0: The support for this board weren't valid
> yet. [    0.000000] em28xx #0: Please send a report of having this
> working [    0.000000] em28xx #0: not to V4L mailing list (and/or to
> other addresses)
> [    0.000000] 
> [    0.000000] tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
> [    0.000000] xc2028 1-0061: creating new instance
> [    0.000000] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [    0.000000] tvp5150 1-005c: tvp5150am1 detected.
> [    0.000000] em28xx #0: V4L2 device registered as /dev/video0
> and /dev/vbi0
> [    0.000000] em28xx #0: Found MSI DigiVox A/D
> [    0.000000] usbcore: registered new interface driver em28xx
> [    0.000000] tvp5150 1-005c: tvp5150am1 detected.
> [    0.000000] tvp5150 1-005c: tvp5150am1 detected.
> [    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [    0.000000] tvp5150 1-005c: tvp5150am1 detected.
> [    0.000000] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> 
> After I got the firmware following the instructions on the wiki,
> tvtimes takes approximately 10 seconds to load (it seems to load 80
> different firmwares) in contrast to instant load before but tvtime
> says no signal and while it can scan the screen remains blue.
> 
> I tried the zapping application but it delivers 3 error messages
> before it segfaults: /dev/vbi0 is no vbi device, -- that's it at
> another try, it was sth like driver doesn't support video_overlay and
> sth long string before.
> 
> What are the best working options to get my KWorld DVB-T 310U usable
> in analog TV mode at least? 

Could you sniff your device using usbsnoop tool? After that, please
send the log file back to the list. With log file we can try to figure
out the issue.

Here some info about usbsnoop:
http://www.linuxtv.org/v4lwiki/index.php/Usbsnoop

> Which driver to I have to take, what
> would I have to do? 

At video4linux mailist we're working only in mainline source.

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
