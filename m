Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758457Ab0HDHhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 03:37:08 -0400
Received: by bwz1 with SMTP id 1so2240769bwz.19
        for <linux-media@vger.kernel.org>; Wed, 04 Aug 2010 00:37:06 -0700 (PDT)
Date: Wed, 4 Aug 2010 09:30:19 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, udia@siano-ms.com,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 3/6] V4L/DVB: smsusb: enable IR port for Hauppauge
	WinTV MiniStick
Message-ID: <20100804073019.GA5692@linux-m68k.org>
References: <cover.1280693675.git.mchehab@redhat.com> <20100801171718.5ad62978@pedra> <20100802072711.GA5852@linux-m68k.org> <4C577888.30408@redhat.com> <20100803130552.GA9954@linux-m68k.org> <4C581A5F.5020403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C581A5F.5020403@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

not much success.. no key events appear in userspace, not sure if the hardware receives
anything. Tried both 4 and 9 ports which does not seem to make any difference. 
lshal does list the IR port, as it did with the siano specific code.

Could be my fault, I have cherrypicked patches and applied them on top of Linus 2.6.35.
Is there an easy way to get a diff from your version against Linus 2.6.35? I would
rather not fetch the whole repo over my mobile connection;)

Aug  4 09:04:50 localhost kernel: [  260.142019] usb 5-5: new high speed USB device using ehci_hcd and address 3
Aug  4 09:04:50 localhost kernel: [  260.256894] usb 5-5: New USB device found, idVendor=2040, idProduct=5500
Aug  4 09:04:50 localhost kernel: [  260.256896] usb 5-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 09:04:50 localhost kernel: [  260.256899] usb 5-5: Product: WinTV MiniStick
Aug  4 09:04:50 localhost kernel: [  260.256901] usb 5-5: Manufacturer: Hauppauge Computer Works
Aug  4 09:04:50 localhost kernel: [  260.256903] usb 5-5: SerialNumber: f069684c
Aug  4 09:04:50 localhost kernel: [  260.308378] IR NEC protocol handler initialized
Aug  4 09:04:50 localhost kernel: [  260.322270] IR RC5(x) protocol handler initialized
Aug  4 09:04:50 localhost kernel: [  260.332901] IR RC6 protocol handler initialized
Aug  4 09:04:50 localhost kernel: [  260.363497] IR JVC protocol handler initialized
Aug  4 09:04:50 localhost kernel: [  260.407230] IR Sony protocol handler initialized
Aug  4 09:04:51 localhost kernel: [  260.958061] smscore_set_device_mode: firmware download success: sms1xxx-hcw-55xxx-dvbt-02.fw
Aug  4 09:04:51 localhost kernel: [  260.958400] sms_ir_init: Allocating input device
Aug  4 09:04:51 localhost kernel: [  260.958416] sms_ir_init: IR port 0, timeout 100 ms
Aug  4 09:04:51 localhost kernel: [  260.958419] sms_ir_init: Input device (IR) SMS IR (Hauppauge WinTV MiniStick) is set for key 
events
Aug  4 09:04:51 localhost kernel: [  261.010020] Registered IR keymap rc-rc5-hauppauge-new
Aug  4 09:04:51 localhost kernel: [  261.010571] input: SMS IR (Hauppauge WinTV MiniStick) as /devices/pci0000:00/0000:00:1d.7/usb
5/5-5/rc/rc0/input5
Aug  4 09:04:51 localhost kernel: [  261.010797] rc0: SMS IR (Hauppauge WinTV MiniStick) as /devices/pci0000:00/0000:00:1d.7/usb5/
5-5/rc/rc0
Aug  4 09:04:51 localhost kernel: [  261.037230] DVB: registering new adapter (Hauppauge WinTV MiniStick)
Aug  4 09:04:51 localhost kernel: [  261.039296] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
Aug  4 09:04:51 localhost kernel: [  261.044846] usbcore: registered new interface driver smsusb


Richard
