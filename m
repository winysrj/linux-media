Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:36167 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbARDLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 22:11:51 -0500
Received: by mail-qg0-f67.google.com with SMTP id i50so682363qgf.2
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2015 19:11:50 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 18 Jan 2015 11:11:50 +0800
Message-ID: <CAJke7cKTYsNSE82N+C9Na+J8WWL403wdwMCYAd6cNTpBccGAAw@mail.gmail.com>
Subject: Latest media_build break Geniatech T230
From: Roy Keano <suratjebat@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

identification of the device with which you are having difficulty:
Geniatech T230

the device's subsystem ID, taken from the output of lspci -vnn (for
PCI/PCIe devices) or lsusb -v (for USB based devices):
ID 0572:c688

the environment your running it under (e.g. Fedora 10, with kernel
2.6.27.5, 64-bit), and with what other hardware (e.g. ASUS Core 2 Duo
motherboard):
Debian 7.7
3.2.0-4-amd64 #1 SMP Debian 3.2.63-2+deb7u2 x86_64 GNU/Linux

a note of whether you're using the built in kernel drivers supplied by
your distro or if you have installed the v4l-dvb driver set, or those
from one of the LinuxTV developers' repos
installed the v4l-dvb driver set using media_build

/var/log/message log:
cite the television standard applicable for your device (e.g. ATSC
tuner card, PAL capture card)

..................dvb_usb_cxusb: probe of 1-2:1.0 failed with error -22
...................usbcore: registered new interface driver dvb_usb_cxusb

Exact sequence of actions that causes your problem. If it is possible,
try to provide a simple reproducible test case, as this makes it much
easier to track down the actual problem.:

Install using the simple procedure of media_build without any
indication of error, latest copy of drivers was installed

Copied the 2 firmwares relevant to the tuner from openelec

Reboot the system

Plug in dvb-t stick

/dev/dvb file was MISSING

**************************************************************************
I googled around and found this post by  Crni Gruja:
https://tvheadend.org/boards/5/topics/10864?page=8

I downloaded and used his media_build script. (The link to poster's
media_build can be found at the above link)

The /var/log/message showed:

Jan 18 11:03:34 jebat kernel: [34051.900148] usb 7-1: new high-speed
USB device number 9 using ehci_hcd
Jan 18 11:03:34 jebat kernel: [34052.032992] usb 7-1: New USB device
found, idVendor=0572, idProduct=c688
Jan 18 11:03:34 jebat kernel: [34052.033001] usb 7-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=3
Jan 18 11:03:34 jebat kernel: [34052.033008] usb 7-1: Product: USB Stick
Jan 18 11:03:34 jebat kernel: [34052.033013] usb 7-1: Manufacturer: Max
Jan 18 11:03:34 jebat kernel: [34052.033018] usb 7-1: SerialNumber: 080116
Jan 18 11:03:34 jebat kernel: [34052.033712] dvb-usb: found a 'Mygica
T230 DVB-T/T2/C' in warm state.
Jan 18 11:03:34 jebat kernel: [34052.268209] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Jan 18 11:03:34 jebat kernel: [34052.268402] DVB: registering new
adapter (Mygica T230 DVB-T/T2/C)
Jan 18 11:03:34 jebat kernel: [34052.273649] input: IR-receiver inside
an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb7/7-1/input/input11
Jan 18 11:03:34 jebat kernel: [34052.273806] dvb-usb: schedule remote
query interval to 100 msecs.
Jan 18 11:03:34 jebat kernel: [34052.273989] dvb-usb: Mygica T230
DVB-T/T2/C successfully initialized and connected.
Jan 18 11:03:34 jebat mtp-probe: checking bus 7, device 9:
"/sys/devices/pci0000:00/0000:00:1d.7/usb7/7-1"
Jan 18 11:03:34 jebat mtp-probe: bus: 7, device: 9 was not an MTP device

ls -l /dev/dvd:
drwxr-xr-x 2 root root 100 Jan 18 11:03 adapter0


Best Regards
