Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound03.telus.net ([199.185.220.222]:51227 "EHLO
	outbound03.telus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbZLFEU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 23:20:59 -0500
Received: from edtnaa03.telusplanet.net ([207.216.216.254])
          by priv-edtnes29.telusplanet.net
          (InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP
          id <20091206030029.FZNG20472.priv-edtnes29.telusplanet.net@edtnaa03.telusplanet.net>
          for <linux-media@vger.kernel.org>; Sat, 5 Dec 2009 20:00:29 -0700
Received: from [10.1.1.10] (d207-216-216-254.bchsia.telus.net [207.216.216.254])
	by edtnaa03.telusplanet.net (BorderWare Security Platform) with ESMTP id D9FFA3E32FF1A8EE
	for <linux-media@vger.kernel.org>; Sat,  5 Dec 2009 20:00:29 -0700 (MST)
Subject: Sky2PC Rev. 3.1
From: Sandy macDonald <sandy@voytech.biz>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Dec 2009 19:00:30 -0800
Message-ID: <1260068430.5339.22.camel@bubbles.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello:

I've had a Sky2PC (ver 3.1) DVB-S card kicking around for a while and
I'd like to get it operational.

According to the v4l-dvb wiki, this card requires a definition, and to
post the details to the linuxtv mailing list, so here goes..

Thank you.
Sandy MacDonald

On the back of the card:

Model: SKY2PC
P/N: 92105-20101
Rev: 3.1
Serial no. and MAC address

The front of the card:

DBC1201 (on the metal shielding), nothing else.
Main chip: B2C2 Flexcop III
        M3B9E-001 0215

lspci -v

01:0e.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopIII
DVB chip / Technisat SkyStar2 DVB card (rev 01)
        Subsystem: Techsan Electronics Co Ltd Device 2104
        Flags: bus master, slow devsel, latency 64, IRQ 10
        Memory at f4100000 (32-bit, non-prefetchable) [size=64K]
        I/O ports at 3400 [size=32]

lspci -vn

01:0e.0 0280: 13d0:2200 (rev 01)
        Subsystem: 13d0:2104
        Flags: bus master, slow devsel, latency 64, IRQ 10
        Memory at f4100000 (32-bit, non-prefetchable) [size=64K]
        I/O ports at 3400 [size=32]




