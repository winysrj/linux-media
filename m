Return-path: <linux-media-owner@vger.kernel.org>
Received: from mi0.bluebottle.com ([206.188.25.15]:35971 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZBONkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 08:40:32 -0500
Received: from fe1.bluebottle.com (internal.bluebottle.com [206.188.24.43])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id n1FCokwN004581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 15 Feb 2009 12:50:46 GMT
Received: from localhost (internal.bluebottle.com [206.188.24.43])
	(authenticated bits=0)
	by fe1.bluebottle.com (8.13.1/8.13.1) with ESMTP id n1FCohYH031901
	for <linux-media@vger.kernel.org>; Sun, 15 Feb 2009 12:50:46 GMT
To: linux-media@vger.kernel.org
Message-ID: <1234702242.49980fa2ead62@mail.bluebottle.com>
Date: Sun, 15 Feb 2009 12:50:42 +0000
From: Kevin <vallhaus71@bluebottle.com>
Subject: Philips saa7131e chip on Asus Supported?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, is there anyone who can please give me a hand, after months reading and trying things out, I still cannot make this work.
I have an Asus Wifi tv card which came with my P5WD2 board. This card is shown as 'Asus Tiger Analog Tv Card' in xp and works well in that os.  Looking at the physical card I can see these writings on the chips and tuners (looks like it has 2)
Philips saa7131E
D33005   CE4403
TN05211   SB0780 (don't know if these might help)
I am trying to make it work on Ubuntu 8.10 (32 bit) (also tried on 64 bit---nothing)
After  a brand new installation and updates to the kernel source and headers, my Kernel is 2.6.27.
I also installed the latest Mercurial and also copied firmware drivers (tda10046)  to the /lib/firmware folder. 

lspci shows this;
01:01.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d0)

sudo lspci -v shows this
01:01.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d0)
	Subsystem: ASUSTeK Computer Inc. Device 818c
	Flags: bus master, medium devsel, latency 64, IRQ 22
	Memory at e7edb800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [40] Power Management version 2
	Kernel driver in use: saa7134
	Kernel modules: saa7134

The device being shown as 818c is not like any other Asus dual card I have read about.
Looks like the card is being found but it is not being autodetected, dmesg is showing it as card=0.  I am manually forcing card numbers in /etc/modprobe.d/options file.  I have tried all the Asus card numbers there are in the cardlist but still did not manage to scan any channel.
I have only one connection to the card and it;s from cable tv.

Sorry if I took too long, tried to give as much info as possible, and please excuse me if this is the wrong place were to put this request, if it is can you kindly guide me where I may ask for help.  TIA



