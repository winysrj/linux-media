Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38406 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbcBOOtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 09:49:51 -0500
Received: by mail-ig0-f181.google.com with SMTP id y8so56267351igp.1
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 06:49:51 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 15 Feb 2016 11:49:50 -0300
Message-ID: <CAPAw7H6VbSp2HT=1y-FBYLCkwXTtf2nFGbUhUz1QxxyYVB751w@mail.gmail.com>
Subject: Geniatech Hybrid SBTD-T USB doesn't work
From: =?UTF-8?Q?Rodrigo_Sep=C3=BAlveda_Heerwagen?=
	<rodrigo.sepulveda@lox.cl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'd like to install a Geniatech Hybrid SBTD-T USB on Ubuntu 14.04,
x86_64, with kernel 3.13.0-76-generic, but I can't make it work.

Here you'll see some outputs:

$ lsusb
Bus 001 Device 009: ID 1f4d:6650 G-Tek Electronics Group

$ dmesg
[ 6096.458022] usb 1-3: new high-speed USB device number 9 using ehci-pci
[ 6096.597391] usb 1-3: New USB device found, idVendor=1f4d, idProduct=6650
[ 6096.597408] usb 1-3: New USB device strings: Mfr=16, Product=32,
SerialNumber=64
[ 6096.597417] usb 1-3: Product: Hybrid SBTD-T USB
[ 6096.597425] usb 1-3: Manufacturer: Geniatech
[ 6096.597433] usb 1-3: SerialNumber: 2004090820040908

I ran these commands to make it work:

$ sudo apt-get install linux-headers-`uname -r` linux-image-`uname -r`
build-essential dvb-apps git
$ git clone git://linuxtv.org/media_build.git
$ cd media_build
$ ./build
$ sudo make install
$ modprobe dvb-usb-dib0700

And when I tried to scan a channel list, nothing happens:

$ scan channels.conf > digitalchannels.conf
scanning channels.conf
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
main:2745: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No
such file or directory

Content of channels.conf...
--
T 473142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 14
T 479142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 15
T 485142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 16
T 491142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 17
T 497142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 18
T 503142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 19
T 509142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 20
T 515142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 21
T 521142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 22
T 527142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 23
T 533142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 24
T 539142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 25
T 545142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 26
T 551142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 27
T 557142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 28
T 563142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 29
T 569142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 30
T 575142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 31
T 581142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 32
T 587142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 33
T 593142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 34
T 599142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 35
T 605142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 36
# canal 37 no se usa
T 617142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 38
T 623142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 39
T 629142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 40
T 635142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 41
T 641142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 42
T 647142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 43
T 653142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 44
T 659142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 45
T 665142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 46
T 671142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 47
T 677142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 48
T 683142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 49
T 689142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 50
T 695142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 51
T 701142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 52
T 707142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 53
T 713142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 54
T 719142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 55
T 725142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 56
T 731142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 57
T 737142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 58
T 743142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 59
T 749142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 60
T 755142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 61
T 761142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 62
T 767142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 63
T 773142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 64
T 779142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 65
T 785142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 66
T 791142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 67
T 797142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 68
T 803142857 6MHz 3/4 AUTO AUTO AUTO AUTO NONE # canal 69
--

Please help me with this. Thanks in advance.

Regards,
Rodrigo S.
