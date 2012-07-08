Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:26623 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2GHU5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jul 2012 16:57:30 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [media] lirc_sir: make device registration work
Date: Sun, 8 Jul 2012 22:46:09 +0200
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	680762@bugs.debian.org
References: <1338829524-29623-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1338829524-29623-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207082246.16413.s.L-H@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Monday 04 June 2012, Jarod Wilson wrote:
> For one, the driver device pointer needs to be filled in, or the lirc core
> will refuse to load the driver. And we really need to wire up all the
> platform_device bits. This has been tested via the lirc sourceforge tree
> and verified to work, been sitting there for months, finally getting
> around to sending it. :\

Please consider pushing this[1] patch to 3.5 and -stable (at least 3.0+
is affected, most likely everything >= 2.6.37[2]). I can confirm 
bug - and this patch fixing it on 3.4.4:

serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
smsc_superio_flat(): fir: 0x230, sir: 0x2f8, dma: 03, irq: 3, mode: 0x0e
smsc_ircc_present: can't get sir_base of 0x2f8
[…]
lirc_dev: IR Remote Control driver registered, major 251
lirc_sir: module is from the staging directory, the quality is unknown, you have been warned.
lirc_register_driver: dev pointer not filled in!
lirc_sir: init_chrdev() failed.

After applying this patch lirc_sir loads find and is usable with 
irrecord and lirc.

serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
smsc_superio_flat(): fir: 0x230, sir: 0x2f8, dma: 03, irq: 3, mode: 0x0e
smsc_ircc_present: can't get sir_base of 0x2f8
[…]
lirc_dev: IR Remote Control driver registered, major 251 
lirc_sir: module is from the staging directory, the quality is unknown, you have been warned.
platform lirc_dev.0: lirc_dev: driver lirc_sir registered at minor = 0
lirc_sir: I/O port 0x02f8, IRQ 3.
lirc_sir: Installed

Without this patch lirc_sir can't even get loaded, the alternative 
would be to mark it as BROKEN for <<3.6.

Regards
	Stefan Lippers-Hollmann

[1]	http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=4b71ca6bce8fab3d08c61bf330e781f957934ae1
	http://patchwork.linuxtv.org/patch/11579/
[2]	RedHat bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=557210 [2.6.31.9-174.fc12.i686.PAE]
	Ubuntu launchpad: https://bugs.launchpad.net/ubuntu/+source/lirc/+bug/912251 [3.0.0-12-generic]
	Debian BTS: http://bugs.debian.org/680762 [3.2+]
