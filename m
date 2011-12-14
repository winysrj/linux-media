Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57495 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab1LNVVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 16:21:07 -0500
Received: by faar15 with SMTP id r15so1700698faa.19
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2011 13:21:05 -0800 (PST)
Message-ID: <1323897656.3085.12.camel@tvbox>
Subject: Re: [PATCH] it913x add support for IT9135 9006 devices
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Adeq <adexmail@tlen.pl>
Cc: linux-media@vger.kernel.org
Date: Wed, 14 Dec 2011 21:20:56 +0000
In-Reply-To: <loom.20111214T071004-336@post.gmane.org>
References: <1323719580.2235.3.camel@tvbox>
	 <loom.20111214T071004-336@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-12-14 at 06:13 +0000, Adeq wrote:
> Malcolm Priestley <tvboxspy <at> gmail.com> writes:
> 
> > 
> > Support for IT1935 9006 devices.
> > 
> > 9006 have version 2 type chip.
> > 
> > 9006 devices should use dvb-usb-it9135-02.fw firmware.
> > 
> > On the device tested the tuner id was set to 0 which meant
> > the driver used tuner id 0x38. The device functioned normally.
> > 
> 
> Hello,
> 
> my device (048d:9006) isn't fully working, here is dmesg log:
> 
> [code]
> [  281.724044] usb 1-3: new high-speed USB device number 10 using ehci_hcd
> [  281.860585] usb 1-3: New USB device found, idVendor=048d, idProduct=9006
> [  281.860594] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  281.860601] usb 1-3: Product: DVB-T TV Stick
> [  281.860607] usb 1-3: Manufacturer: ITE Technologies, Inc.
> [  281.861694] it913x: Chip Version=02 Chip Type=9135
> [  281.863193] it913x: Dual mode=0 Remote=1 Tuner Type=0
> [  281.864444] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, will try
> to load a firmware
> [  281.870053] dvb-usb: downloading firmware from file 'dvb-usb-it9135-02.fw'
> [  281.870438] it913x: FRM Starting Firmware Download
> [  282.388032] it913x: FRM Firmware Download Failed (ffffffff)
> [  282.588116] it913x: Chip Version=79 Chip Type=4af3
> [  283.224203] it913x: DEV it913x Error
> [  283.227753] input: ITE Technologies, Inc. DVB-T TV Stick as

Try using the following for firmware.

dd if=dvb-usb-it9135.fw ibs=1 skip=64 count=8128 of=dvb-usb-it9135-01.fw
dd if=dvb-usb-it9135.fw ibs=1 skip=12866 count=5731 of=dvb-usb-it9135-02.fw

I have got length of dvb-usb-it9135-02.fw wrong it was changed to 5731.

However, 5817 should be correct in emulation, but fails with device.

The firmware version should say it913x: Firmware Version 50594048

I will have to check the firmware loader again.

Regards


Malcolm





