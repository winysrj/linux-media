Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36733 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751526AbdBGMdy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 07:33:54 -0500
Received: by mail-wm0-f52.google.com with SMTP id c85so158873368wmi.1
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 04:33:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
References: <20161123123851.GB14257@shambles.local> <20161123223419.GA25515@gofer.mess.org>
 <20161124121253.GA17639@shambles.local> <20161124133459.GA32385@gofer.mess.org>
 <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
 <20161127193510.GA20548@gofer.mess.org> <20161130090229.GB639@shambles.local>
 <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
 <20170202233533.GA14357@gofer.mess.org> <CAEsFdVMhbxb3d=_ugYjfYSCRZsQMhtt=kmsqX81x-6UjTYc-bg@mail.gmail.com>
 <20170204191050.GA31779@gofer.mess.org> <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Tue, 7 Feb 2017 23:33:51 +1100
Message-ID: <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
Subject: Re: ir-keytable: infinite loops, segfaults
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried your patch, after disabling the custom keymap file I had put
in. Unfortunately the remote isn't working at all. When the relevant
modules get loaded I see this in dmesg


[    7.838223] media: Linux media interface: v0.10
[    7.840484] WARNING: You are using an experimental version of the
media stack.
                As the driver is backported to an older kernel, it doesn't offer
                enough quality for its usage in production.
                Use it with care.
               Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
                47b037a0512d9f8675ec2693bed46c8ea6a884ab [media]
v4l2-async: failing functions shouldn't have side effects
                79a2eda80c6dab79790c308d9f50ecd2e5021ba3 [media]
mantis_dvb: fix some error codes in mantis_dvb_init()
                c2987aaf0c9c2bcb0d4c5902d61473d9aa018a3d [media]
exynos-gsc: Avoid spamming the log on VIDIOC_TRY_FMT
[    7.843667] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_generic_rw
[    7.843669] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_rw (err -22)
[    7.843692] dvb_usb_cxusb: disagrees about version of symbol rc_keydown
[    7.843693] dvb_usb_cxusb: Unknown symbol rc_keydown (err -22)
[    7.843701] dvb_usb_cxusb: disagrees about version of symbol
dib0070_wbd_offset
[    7.843702] dvb_usb_cxusb: Unknown symbol dib0070_wbd_offset (err -22)
[    7.843707] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_device_init
[    7.843708] dvb_usb_cxusb: Unknown symbol dvb_usb_device_init (err -22)
[    7.843712] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_generic_write
[    7.843713] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_write (err -22)
[    8.089033] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_generic_rw
[    8.089035] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_rw (err -22)
[    8.089068] dvb_usb_cxusb: disagrees about version of symbol rc_keydown
[    8.089070] dvb_usb_cxusb: Unknown symbol rc_keydown (err -22)
[    8.089079] dvb_usb_cxusb: disagrees about version of symbol
dib0070_wbd_offset
[    8.089080] dvb_usb_cxusb: Unknown symbol dib0070_wbd_offset (err -22)
[    8.089085] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_device_init
[    8.089086] dvb_usb_cxusb: Unknown symbol dvb_usb_device_init (err -22)
[    8.089090] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_generic_write
[    8.089091] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_write (err -22)

A manual modprobe gives this:

# modprobe -v dvb_usb_cxusb
insmod /lib/modules/4.4.0-59-generic/kernel/drivers/media/usb/dvb-usb/dvb-usb-cxusb.ko
modprobe: ERROR: could not insert 'dvb_usb_cxusb': Invalid argument
# dmesg
....
[  547.365417] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_generic_rw
[  547.365422] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_rw (err -22)
[  547.365461] dvb_usb_cxusb: disagrees about version of symbol rc_keydown
[  547.365463] dvb_usb_cxusb: Unknown symbol rc_keydown (err -22)
[  547.365475] dvb_usb_cxusb: disagrees about version of symbol
dib0070_wbd_offset
[  547.365477] dvb_usb_cxusb: Unknown symbol dib0070_wbd_offset (err -22)
[  547.365484] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_device_init
[  547.365486] dvb_usb_cxusb: Unknown symbol dvb_usb_device_init (err -22)
[  547.365493] dvb_usb_cxusb: disagrees about version of symbol
dvb_usb_generic_write
[  547.365495] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_write (err -22)

I was able to modprobe the rc-dvico-mce module, there was nothing in
dmesg afterward though.

Cheers
Vince
