Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60408 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0ICAzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 20:55:46 -0400
Received: by qyk33 with SMTP id 33so1277148qyk.19
        for <linux-media@vger.kernel.org>; Thu, 02 Sep 2010 17:55:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Sep 2010 00:55:43 +0000
Message-ID: <AANLkTi=SY9xWCjp_0q6US7XN6XYoTWnGHA2=6EfjuWK-@mail.gmail.com>
Subject: Gigabyte 8300
From: Dagur Ammendrup <dagurp@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I bought a Gigabyte U8300 today which is a hybrid USB tuner. These are
the specifications according to the manufacturer:

Analog: TVPAL / SECAM / NTSC
Decoder chip: Conexant CX23102
Digital TV: DVB-T
Interface: USB 2.0
Others Support: Microsoft® Windows 2000, XP, MCE and Windows Vista MCE
/ Win 7 32/ 64bits
Remote sensor Interface: IR
Tuner: NXP TDA18271

Now I know that the decoder chip is supported in other USB sticks but
mine is not recognised. Here is my lsusb output:

Bus 001 Device 004: ID 1b80:d416 Afatech

And here is the dmesg info I get when I plug it in:

[ 2981.693805] usb 1-2: USB disconnect, address 2
[ 2991.760091] usb 1-2: new high speed USB device using ehci_hcd and address 4
[ 2991.916044] usb 1-2: configuration #1 chosen from 1 choice


Is there anyone out there who might be interested in adding support
for this (or guide me through it)?


thanks,
Dagur
