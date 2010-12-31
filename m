Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:64143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0LaLTb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 06:19:31 -0500
Message-ID: <4D1DBC22.1030404@redhat.com>
Date: Fri, 31 Dec 2010 09:18:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Kriwanek <mail@stefankriwanek.de>
CC: linux-media@vger.kernel.org, Douglas Landgraf <dougsland@gmail.com>
Subject: Re: support for IR remote TerraTec Cinergy T USB XXS
References: <4D1B4A7E.20503@stefankriwanek.de>
In-Reply-To: <4D1B4A7E.20503@stefankriwanek.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 29-12-2010 12:49, Stefan Kriwanek escreveu:
> Dear linux-media developers,
> 
> I think I found a bug in the support of the  TerraTec Cinergy T USB XXS
> remote control, or maybe just a new hardware revision appeared.
> 
> When I recently bought such a USB-stick I found the remote not working,
> instead 'dib0700: Unknown remote controller key' lines appearing in
> syslog on each keypress. The dvb_usb_dib0700 kernel module got
> autoloaded by my Ubuntu 10.10. I am using current hg revision of v4l-dvb
> and load the kernel module using the 'dvb_usb_dib0700_ir_proto=0'
> option. Simply adding the keycodes to the driver file
> (linux/drivers/media/dvb/dvb-usb/dib0700_devices.c,
> patch appended) made things work.

Don't use a legacy, obsoleted, discontinued tree when writing patches. The
mercurial tree is obsolete, and it is there just to preserve the tree history.

Instead, you should use the git tree. The media_build tree[1] provides a
feature similar to the old hg tree.

[1] http://git.linuxtv.org/media_build.git

The IR code has changed _a_lot_ since the last update in -hg. Basically, the
entire support were rewritten, and now the protocol is (or should) be
auto-detected.

Douglas,

It would be a good idea to write a patch for the legacy mercurial tree warning
people about that.

> 
> However, by incident I found those very keycodes are already defined in
> the linux/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c file, so
> maybe the issue is just about loading it?
> 
> 'lsusb' lists my device as
> Bus 001 Device 006: ID 0ccd:00ab TerraTec Electronic GmbH
> despite I do not own the 'HD' version of the device, your wiki
> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_XXS
> says that ID corresponds to. The output of 'lsusb -v' is appended to
> this mail.
> 
> 'cat /proc/bus/input/devices' lists the input device as
> I: Bus=0003 Vendor=0ccd Product=00ab Version=0100
> N: Name="IR-receiver inside an USB DVB receiver"
> P: Phys=usb-0000:00:12.2-2/ir0
> S: Sysfs=/devices/pci0000:00/0000:00:12.2/usb1/1-2/input/input13
> U: Uniq=
> H: Handlers=kbd event8
> B: EV=3
> B: KEY=14afc336 2b4285f00000000 0 480158000 219040000801 9e96c000000000
> 90024010004ffc
> 
> I hope you could add support for my stick; I'd be happy to provide
> further information if necessary.
> 
> Best regards
> Stefan

