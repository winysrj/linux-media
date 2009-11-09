Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZKIQrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 11:47:22 -0500
Date: Mon, 9 Nov 2009 14:46:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
Message-ID: <20091109144647.2f876934@pedra.chehab.org>
In-Reply-To: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 Nov 2009 12:13:22 +0100
Valerio Bontempi <valerio.bontempi@gmail.com> escreveu:

> Hi all,
> 
> I have a problem trying to user Terratec Cinergy T XS (usb dvb only
> adapter) with XC3028 tuner:
> v4l dvb driver installed in last kernel versions (actually I am using
> 2.6.31 from ubuntu 9.10) detects this device but then looks for the
> wrong firmware xc3028-v27.fw, and, moreover, seems to not contain
> correct device firmware at all.
> This makes the device to be detected but dvb device /dev/dvb is not
> created by the kernel.
> 
> Is there a way to make this device to work with last kernel versions
> and last v4l-dvb driver versions?

Earlier versions of Ubuntu used to contain an out-of-tree driver for xc3028,
that used a different firmware format.

Due to license issues, distros can't package the firmware files (since the vendor
didn't give any redistribution rights for the firmwares up to now).

So, you'll need to download a driver with the firmware inside and run a script to
create the firmware.

For more info and instructions on how to get the firmware, please see:
	http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware

Cheers,
Mauro
