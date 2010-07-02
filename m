Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58086 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752548Ab0GBIFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 04:05:03 -0400
Content-Type: text/plain; charset="utf-8"
Date: Fri, 02 Jul 2010 10:05:01 +0200
From: "Dirk Langner" <dirkolus@gmx.de>
Message-ID: <20100702080501.188310@gmx.net>
MIME-Version: 1.0
Subject: TerraTec Cinergy Hybrid Stick [0ccd:00a5] - worth trying?
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

I'm really pissed that whenever I try to find a TV-USB-stick (analog in my case), it's not in the shops any longer or it's not listed on the linuxtv validated sticks. The names of the USB sticks are only slightly changed, which may mean, this is only a rebranding or a completely new hardware (even without name change). Therefore is the support for these sticks kind of a lottery and one first have to buy them, check the USB id and whether it's supported or not. Seems, that the product cycles are too short for us linux-users :(

Ok, genug gekotzt, now to the facts: I've purchased the USB-stick TerraTec Cinergy Hybrid Stick, although it's a little older (1/2 year) it is still in the shops.

Vendor: TerraTec
Model: Cinergy Hybrid Stick
Vendor/Product ID: 0ccd:00a5
Supports DVB-T and Analog Cable (tested already successful on Windows)

I'm using the latest snapshot of v4l-dvb (incl. experimental driver) on Ubuntu 10.04

Tests made: 
- plug in and out into USB 2.0 slot
Only the message appears in dmesg, that an USB device is connected or disconnected when pluggin in or out. When loading the driver by hand (i've tried em28xx) there is nothing which relates to this stick: The driver will not unload when unplugging the stick, nor loaded when the stick is plugged in.

To be honest I have no clue, what kind of chips are used in there and which one to load - that does not happen automatically.

My question now is: is it worth trying to have a look at this hardware since there already seem to be some in the field? Or is it working and I don't know? Or has everybody already given up?

Thanks for help. I'm also open for providing some information and tests with this stick if anybody is interested in it.

Thanks, 
    Dirk

-- 
GMX DSL: Internet-, Telefon- und Handy-Flat ab 19,99 EUR/mtl.  
Bis zu 150 EUR Startguthaben inklusive! http://portal.gmx.net/de/go/dsl
