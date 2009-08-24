Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:21699 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZHXJ5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 05:57:22 -0400
Received: by ey-out-2122.google.com with SMTP id 22so573413eye.37
        for <linux-media@vger.kernel.org>; Mon, 24 Aug 2009 02:57:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380908211317k401b6b2etdb88a90e6e7e53fa@mail.gmail.com>
References: <54b126f90908211227k78cfeebbqcee4da4958743a3b@mail.gmail.com>
	 <829197380908211238i58670a12p39537af14dbfc009@mail.gmail.com>
	 <54b126f90908211305j6911820es52c8ffc2be6b9667@mail.gmail.com>
	 <829197380908211317k401b6b2etdb88a90e6e7e53fa@mail.gmail.com>
Date: Mon, 24 Aug 2009 11:57:22 +0200
Message-ID: <54b126f90908240257t362bf59byc0100bf6aa4b315b@mail.gmail.com>
Subject: Re: detection of Empire Media Pen Dual TV
From: Baggius <baggius@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/8/21 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Fri, Aug 21, 2009 at 4:05 PM, Baggius<baggius@gmail.com> wrote:
>> Hello Devin,
>> I have an Empire Media Pen Dual TV and it has same layout as Kworld dvb-t 310u.
>> while MSI Digivox A/D has "similar" layout and supports 1080i extra resolution,
>> as http://www.msi.com/index.php?func=proddesc&maincat_no=132&prod_no=626
>>
>> If you want I can capture usb device startup log using Usbsnoop/SniffUSB  ...
>> Giuseppe
>
> Hmmm...  Let's hold off on a usb capture for now.  Now that I
> understand that you have the Empire board, I am looking at the dmesg
> trace again and am a bit confused.  Do you happen to have a "card=49"
> parameter in your modprobe configuration?  However, the code does
> appear to also recognize the board as the Empire board (see the "Board
> detected as Empire dual TV").

No, I havent' any card parameter in modprobe.conf, I commented out
"options em28xx ..." line.
Now some info on my system:

Kernel is Linux box 2.6.29-sabayon #1 SMP Wed Aug 19 22:18:09 UTC 2009
x86_64 Intel(R) Core(TM)2 Duo CPU T9300 @ 2.50GHz GenuineIntel
GNU/Linux,

Linux Distro is Sabayon 4.2 x86_64 Gnome edition, regularly updated,

on Acer Aspire 5920G http://support.acer-euro.com/drivers/notebook/as_5920.html

>
> I agree that something appears to be wrong.  I will have to take a
> look at the code and see where the "Identified as" messages comes
> from.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Well, after some searches I got from web another eeprom contents,
from a similar board, a Conitech CN610DVB-DT
http://www.conitech.it/conitech/ita/prod.asp?cod=CN610DVB-DT
and using rebuil_eeprom.pl
generated .sh script to change my eeprom contents. Here both eeproms bytes:

empire media pen dual tv eeprom contents (vid=eb1a pid=e310):
[11196.181543] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12
5c 03 6a 22 00 00
[11196.181559] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00
00 00 00 00 00 00
[11196.181572] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00
00 00 5b 1e 00 00
[11196.181585] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[11196.181598] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181610] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181622] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[11196.181635] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 44 00
[11196.181648] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[11196.181660] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181673] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181685] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181698] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181710] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181722] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[11196.181735] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00

conitech cn610dvb-dt eeprom contents (vid=eb1a pid=2881):
[  127.753053] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12
5c 03 6a 20 6a 00
[  127.753073] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4
00 00 02 02 00 00
[  127.753090] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00
00 00 5b 1e 00 00
[  127.753107] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01
00 00 00 00 00 00
[  127.753123] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  127.753140] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  127.753156] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 53 00
[  127.753173] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 56 00
[  127.753189] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00
00 00 00 00 00 00
[  127.753206] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  127.753222] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  127.753239] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  127.753255] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  127.753271] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  127.753288] em28xx #0: i2c eeprom e0: 5a 00 55 aa e5 2b 59 03 00 17
fc 01 00 00 00 00
[  127.753305] em28xx #0: i2c eeprom f0: 00 00 00 01 00 00 00 00 00 00
00 00 00 00 00 00

wrote new eeprom, I used card=48 as em28xx parameter (kworld 310U) and
analog part,
WITH audio, was ALL working (both tv and audio/video input) with extra
feature of usb power management,
as dmesg told:
[19178.415552] em28xx #0:       USB Remote wakeup capable

Result was a less hot device :D

To route audio from usb card to my audio card and launch tvtime I used
this script:

--- begin of start-analog-tv.sh
#!/bin/sh
#-q
# sudo apt-get install sox libsox-fmt-all
#
# start-tv.sh
#
#sox -c 2 -s -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -r 32000 /dev/dsp &
sox -c 2 -s -r 48000 -t alsa hw:1,0 -t alsa -r 48000 hw:0,0 &
soxpid=$!
sleep 0.5
tvtime --device /dev/video1
kill $soxpid
--- end of start-analog-tv.sh

I hope this solution for this card can be useful to correct and fixes
audio problems in v4l-dvb trunk device recognition
routines
