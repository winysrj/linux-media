Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:40604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752999Ab0JGJEr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 05:04:47 -0400
Content-Type: text/plain; charset="utf-8"
Date: Thu, 07 Oct 2010 11:04:43 +0200
From: "Matthias Weber" <matthiaz.weber@gmx.de>
Message-ID: <20101007090443.54550@gmx.net>
MIME-Version: 1.0
Subject: Re: [v4l/dvb] identification/ fixed registration order of DVB cards
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>Can't this be forced using udev rules?

udev seems to be a good way. I tried several different configurations.. my last one (file called '50-dvb_cards.rules'):

# Create a symlink /dev/dvb/adapter104 pointing to dvb card with PCI bus id 04:00.0
SUBSYSTEM=="dvb", KERNEL=="0000:04:00.0", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter104/%%s $${K#*.}'", SYMLINK+="%c"

# Create a symlink /dev/dvb/adapter106 pointing to dvb card with PCI bus id 04:02.0
SUBSYSTEM=="dvb", KERNEL=="0000:04:02.0", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter106/%%s $${K#*.}'", SYMLINK+="%c"

BUS and ID combinations I saw on different other webpages seem to be out of date. Not sure what I am doing wrong as there still is only /dev/dvb/adapter0 and /dev/dvb/adapter1.

I also tried to get my usbstick running with
BUS=="usb", SYSFS{idVendor}=="058f", SYMLINK=+"usbstick"
but this didn't work also.

Any help appreciated. Thanks!

Cheers
Matthias
-- 
GMX DSL Doppel-Flat ab 19,99 &euro;/mtl.! Jetzt auch mit 
gratis Notebook-Flat! http://portal.gmx.net/de/go/dsl
