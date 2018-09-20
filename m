Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:38250 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbeITJs3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 05:48:29 -0400
Received: by mail-it0-f65.google.com with SMTP id p129-v6so10633947ite.3
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 21:07:11 -0700 (PDT)
Message-ID: <8b990b3c13db04ee04bcb1b5b3a566f8054754f3.camel@gmail.com>
Subject: 4.18 regression: dvb-usb-v2: General Protection Fault shortly after
 boot
From: Dan Ziemba <zman0900@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
Date: Thu, 20 Sep 2018 00:07:09 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I reported this on bugzilla also a few days ago, but I'm not sure if
that is actually the right place to report, so copying to the mailing
list...


Starting with the first 4.18 RC kernel, my system experiences general
protection faults leading to kernel panic shortly after the login
prompt appears on most boots.  Occasionally that doesn't happen and
instead numerous other seemingly random stack traces are printed (bad
page map, scheduling while atomic, null pointer deref, etc), but either
way the system is unusable.  This bug remains up through the latest
mainline kernel 4.19-rc2.

Booting with my USB ATSC tv tuner disconnected prevents the bug from
happening.


Kernel bisection between v4.17 and 4.18-rc1 shows problem is caused by:

1a0c10ed7bb1 media: dvb-usb-v2: stop using coherent memory for URBs


Building both 4.18.6 and 4.19-rc2 with that commit reverted resolves
the bug for me.  


My DVB hardware uses driver mxl111sf:

Bus 002 Device 003: ID 2040:c61b Hauppauge 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2040 Hauppauge
  idProduct          0xc61b 
  bcdDevice            0.00
  iManufacturer           1 Hauppauge
  iProduct                2 WinTV Aero-M

Other system info:

Arch Linux x86_64
Intel i7-3770
16 GB ram

Bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=201055

Arch bug:
https://bugs.archlinux.org/task/59990


Thanks,
Dan Ziemba
