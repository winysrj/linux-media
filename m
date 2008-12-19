Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJEYVQa019875
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 09:34:31 -0500
Received: from smtp1.aruba.it (smtp.katamail.com [62.149.157.154])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBJEYH6g006774
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 09:34:17 -0500
From: H725 <forromale@katamail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Fri, 19 Dec 2008 15:26:25 +0100
Message-Id: <1229696785.5940.23.camel@debian.debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: USB 2.0 DVB-T TV STICK LOG
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

Hello,
I just tried to see TV on linux, but with no success (for now).
I have an USB tv receiver , on its pack is written "USB 2.0 DVB-T TV
STICK", but I didn't find the brand (I think it came from China).
Anyway, I connected it and dmesg shows a message where says to write to
this ML and paste the log.


[ 1305.832046] usb 4-5: new high speed USB device using ehci_hcd and
address 7
[ 1305.967663] usb 4-5: configuration #1 chosen from 1 choice
[ 1305.967958] em28xx new video device (eb1a:2881): interface 0, class
255
[ 1305.967975] em28xx Has usb audio class
[ 1305.967981] em28xx #0: Alternate settings: 8
[ 1305.967988] em28xx #0: Alternate setting 0, max size= 0
[ 1305.967994] em28xx #0: Alternate setting 1, max size= 0
[ 1305.968037] em28xx #0: Alternate setting 2, max size= 1448
[ 1305.968045] em28xx #0: Alternate setting 3, max size= 2048
[ 1305.968051] em28xx #0: Alternate setting 4, max size= 2304
[ 1305.968058] em28xx #0: Alternate setting 5, max size= 2580
[ 1305.968065] em28xx #0: Alternate setting 6, max size= 2892
[ 1305.968072] em28xx #0: Alternate setting 7, max size= 3072
[ 1305.969229] em28xx #0: chip ID is em2882/em2883
[ 1305.999411] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12
5c 00 6a 22 00 00
[ 1305.999443] em28xx #0: i2c eeprom 10: 00 00 04 57 66 57 00 00 60 f4
00 00 02 02 00 00
[ 1305.999469] em28xx #0: i2c eeprom 20: 56 00 01 00 f0 10 01 00 b8 00
00 00 5b 1e 00 00
[ 1305.999493] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02
00 00 00 00 00 00
[ 1305.999518] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999542] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999566] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[ 1305.999590] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 44 00
[ 1305.999614] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[ 1305.999638] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999662] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999686] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999710] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999734] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999757] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999781] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1305.999809] EEPROM ID= 0x9567eb1a, hash = 0xa4e09589
[ 1305.999816] Vendor/Product ID= eb1a:2881
[ 1305.999821] AC97 audio (5 sample rates)
[ 1305.999826] USB Remote wakeup capable
[ 1305.999831] 500mA max power
[ 1305.999837] Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 1306.013693] em28xx #0: found i2c device @ 0x1e [???]
[ 1306.051276] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 1306.055650] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[ 1306.057403] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 1306.068281] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[ 1306.068288] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[ 1306.068290] em28xx #0: Please send an email with this log to:
[ 1306.068293] em28xx #0: 	V4L Mailing List
<video4linux-list@redhat.com>
[ 1306.068295] em28xx #0: Board eeprom hash is 0xa4e09589
[ 1306.068297] em28xx #0: Board i2c devicelist hash is 0x944d008f
[ 1306.068300] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[ 1306.068303] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 1306.068305] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[ 1306.068308] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 1306.068310] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 1306.068313] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 1306.068315] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 1306.068317] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 1306.068320] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 1306.068322] em28xx #0:     card=8 -> Kworld USB2800
[ 1306.068324] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
[ 1306.068327] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 1306.068329] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 1306.068332] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 1306.068334] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 1306.068336] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB
2.0
[ 1306.068339] em28xx #0:     card=15 -> V-Gear PocketTV
[ 1306.068341] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 1306.138657] em28xx #0: V4L2 device registered as /dev/video0
and /dev/vbi0
[ 1306.138664] em28xx #0: Found Unknown EM2750/28xx video grabber
[ 1306.138733] em28xx audio device (eb1a:2881): interface 1, class 1
[ 1306.160677] usb 4-5: New USB device found, idVendor=eb1a,
idProduct=2881
[ 1306.160684] usb 4-5: New USB device strings: Mfr=0, Product=1,
SerialNumber=0
[ 1306.160688] usb 4-5: Product: USB 2881 Device

And this is done.

Thank you in advance for any help.

Bye.









--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
