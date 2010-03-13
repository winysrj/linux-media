Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50242 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab0CMQ54 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 11:57:56 -0500
Subject: Re: Analog (PAL) PCI or PCIe with MPEG HW encoder
From: Andy Walls <awalls@radix.net>
To: RoboSK <ucet.na.diskusie@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B9A8093.9020902@gmail.com>
References: <4B9A8093.9020902@gmail.com>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 11:58:10 -0500
Message-Id: <1268499490.3084.27.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-03-12 at 18:57 +0100, RoboSK wrote:
> Hi, exist Analog (PAL) PCI or PCIe with MPEG HW encoder card that is 
> supported into linux and is still possible purchase this card into shop 
> (as new)?

Hans already mentioned the PVR-150 as a CX23416 PCI based card supported
by ivtv.

For CX23418 PCI based cards, you may want to check if the 

1. Hauppauge HVR-1600
2. LeadTek WinFast DVR3100 H
3. LeadTek WinFast PVR2100
4. Compro VideoMate H900
5. Yuan MPC-718 (mini-PCI)
6. Yuan PG-718 (this may need some tweaks in the linux driver)

are available and meet your needs.


For PCIe based cards, there are a few cards with an CX23417 MPEG encoder
connected to a CX2388[578] bridge, supported by the cx23885 driver.
However, as I understand it, analog TV support in the cx23885 driver is
minimal and works only for a few cards.

Regards,
Andy

> thanks
> 
> Robo


