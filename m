Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42787 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IVWNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 18:13:46 -0400
Received: by pbbrr4 with SMTP id rr4so4941738pbb.19
        for <linux-media@vger.kernel.org>; Sat, 22 Sep 2012 15:13:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACxi0jMFigNEkot3wvY5YncMokkLuUWjfKD6tkxbJQVKZssjkA@mail.gmail.com>
References: <CACxi0jMFigNEkot3wvY5YncMokkLuUWjfKD6tkxbJQVKZssjkA@mail.gmail.com>
Date: Sun, 23 Sep 2012 00:13:45 +0200
Message-ID: <CACxi0jOAq_shW1arcGNMsNh5M1g5_Gr_f9GmPRRXVaeng1rsaw@mail.gmail.com>
Subject: MyGica T119 (siano sms) ir sensor is not recognized
From: Pablo Sanzo Perez <sanzoperez@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have an usb MyGica T119 using the firmware dvb_nova_12mhz_b0.inp and
modules smsdvb and smsmdtv from Siano.
The IR is not being detected.

I have googled and looked in this email, I have only found some old
patches but I could not find a solution.

Is there any way to make it recognized?

dmesg shows this when the device is plugged:

[18359.699863] sms_ir_exit:
[18373.290788] usb 2-2: new high-speed USB device number 4 using ehci_hcd
[18373.986598] smscore_set_device_mode: firmware download success:
dvb_nova_12mhz_b0.inp
[18373.989903] DVB: registering new adapter (Siano Nova B Digital Receiver)
[18373.990269] DVB: registering adapter 0 frontend 0 (Siano Mobile
Digital MDTV Receiver)...

lsmod | grep sms
smsusb                 13808  0
smsdvb                 18536  0
dvb_core              110619  1 smsdvb
smsmdtv                37242  2 smsusb,smsdvb
rc_core                26412  8
ir_lirc_codec,ir_mce_kbd_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,smsmdtv

lsmod | grep irda
irda                  201324  0
crc_ccitt              12667  1 irda

grep FIR /sys/bus/acpi/devices/*/path
No result

lsusb
Bus 002 Device 004: ID 187f:0201 Siano Mobile Silicon Nova B

Any help would be much appreciated.
Thanks in advance.
