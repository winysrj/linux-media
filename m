Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40390 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0HBKON (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 06:14:13 -0400
Received: by bwz1 with SMTP id 1so1368011bwz.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 03:14:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik3M-qoNRqrQmFWF6kTMFLhLZJp5uznznwFWPfY@mail.gmail.com>
References: <AANLkTik3M-qoNRqrQmFWF6kTMFLhLZJp5uznznwFWPfY@mail.gmail.com>
Date: Mon, 2 Aug 2010 12:14:12 +0200
Message-ID: <AANLkTimbCeEsJU+T4hscNO_oPkBaQPaeDo-ge9K6UJw3@mail.gmail.com>
Subject: STK7700D id is 1164:0871 on Toshiba A660 laptops, conflicts with Yuan
	MC770
From: Olivier Poulet <unineurone@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I am running Ubuntu 10.04 on a Toshiba A660-14x laptop. The hybrid
tuner is being reported in Windows 7 as based on the STK7700D. Both
tuners (dvb & analog) work correctly there.

However, it's usb vendor & device strings are 1164:0871, see the
output of hwinfo below. This makes the dvb modules configure it as if
it where a "Yuan High-Tech MC770"

This results in Linux only seeing the DVB tuner, which works fine. The
analog one isn't used, so I am missing all the analog channels (there
are still some :-) ) I can catch from my location.

Is there any module options I could pass to "force" it to be seen as a STK770D ?

Best regards,
Olivier

09: USB 00.0: 0000 Unclassified device
[Created at usb.122]
UDI: /org/freedesktop/Hal/devices/usb_device_1164_871_0000000001_if0
Unique ID: VBUu.DOCYvzmCULD
Parent ID: ADDn.0j9+vWlqL56
SysFS ID: /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.0
SysFS BusID: 1-1.5:1.0
Hardware Class: unknown
Model: "YUAN High-Tech Development STK7700D"
Hotplug: USB
Vendor: usb 0x1164 "YUAN High-Tech Development Co., Ltd"
Device: usb 0x0871 "STK7700D"
Revision: "1.00"
Serial ID: "0000000001"
Driver: "dvb_usb_dib0700"
Driver Modules: "dvb_usb_dib0700"
Speed: 480 Mbps
Module Alias: "usb:v1164p0871d0100dc00dsc00dp00icFFisc00ip00"
Driver Info #0:
  Driver Status: dvb_usb_dib0700 is active
  Driver Activation Cmd: "modprobe dvb_usb_dib0700"
Config Status: cfg=new, avail=yes, need=no, active=unknown
Attached to: #5 (Hub)
