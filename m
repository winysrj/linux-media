Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33691 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdFAHUU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 03:20:20 -0400
Date: Thu, 1 Jun 2017 09:20:23 +0200
From: Johan Hovold <johan@kernel.org>
To: Sebastian <sebastian@iseclab.org>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: Null Pointer Dereference in mceusb
Message-ID: <20170601072023.GM6735@localhost>
References: <CAL8_TH8JTPd5ki-v-+T-Z+VGRg-vfsx=rYMjKq_vbUfTBPff3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8_TH8JTPd5ki-v-+T-Z+VGRg-vfsx=rYMjKq_vbUfTBPff3w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ +CC: media list ]

On Wed, May 31, 2017 at 08:25:42PM +0200, Sebastian wrote:
> Hi list,
> 
> as kindly suggested by gregkh
> (https://bugzilla.kernel.org/show_bug.cgi?id=195943), I am now sending
> the mail to this mailing list.
> I have set up the latest Ubuntu 17.04 server within a qemu/kvm virtual
> machine and experienced the following bug in the mce_usb driver:

What is the lsusb -v output for your device? And have you successfully
used this device with this driver before?
 
> [ 2873.734554] usb usb1-port1: unable to enumerate USB device
> [ 2906.929123] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000003
> [ 2906.931178] IP: mce_request_packet+0x66/0x210 [mceusb]
> [ 2906.932512] PGD 0
> [ 2906.932514]
> [ 2906.933561] Oops: 0000 [#1] SMP
> [ 2906.934382] Modules linked in: kaweth zd1211rw ir_rc6_decoder
> ir_lirc_codec lirc_dev rc_rc6_mce mceusb rc_core ftdi_sio usbserial
> usb_storage usbhid hid at
> 76c50x_usb mac80211 cfg80211 ppdev joydev input_leds i2c_piix4
> parport_pc parport pvpanic mac_hid serio_raw ib_iser rdma_cm iw_cm
> ib_cm ib_core configfs iscsi
> _tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables x_tables
> autofs4 btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq
> async_xor async_tx xor
>  raid6_pq libcrc32c raid1 raid0 multipath linear cirrus ttm
> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops psmouse
> drm e1000 floppy pata_acpi
> [ 2906.950961] CPU: 0 PID: 3 Comm: kworker/0:0 Not tainted
> 4.10.0-19-generic #21-Ubuntu

Can you reproduce this with a more recent mainline kernel (e.g.
4.11.3)?

This looks like something which could happen if the device is lacking an
OUT endpoint, and a sanity check to catch that recently went in (and was
backported to the non-EOL stable trees).

Thanks,
Johan
