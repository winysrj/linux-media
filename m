Return-path: <linux-media-owner@vger.kernel.org>
Received: from pelian.caiw.net ([62.45.45.126]:62475 "EHLO pelian.caiw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1HNPNw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 11:13:52 -0400
Received: from barracuda-new-out-1.caiw.net (barracuda-new-out-1.caiw.net [62.45.59.17])
	by pelian.caiw.net (Postfix) with ESMTP id B0667B242A
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 17:04:51 +0200 (CEST)
Received: from cardassian.caiw.net (cardassian.caiw.net [62.45.45.125]) by barracuda-test-600.caiw.net with ESMTP id YtGA1HWNPokkXeJ8 for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 17:04:51 +0200 (CEST)
Received: from dingweb.nl (024-146-045-062.dynamic.caiway.nl [62.45.146.24])
	by cardassian.caiw.net (Postfix) with ESMTP id 20AB9228001
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 17:04:51 +0200 (CEST)
Received: from [192.168.11.16] (pluk.dingweb.nl [192.168.11.16])
	by dingweb.nl (Postfix) with ESMTP id E3BA2180037
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 17:04:50 +0200 (CEST)
Subject: Differend Technisat CableStar HD2 card
From: Rene Dingemanse <rene@dingweb.nl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 14 Aug 2011 17:04:51 +0200
Message-ID: <1313334291.18458.16.camel@pluk.dingweb.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have a card Technisat CableStar HD2

lspci -s 04:00.0 -v 
04:00.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
	Subsystem: Device ffbf:02e4
	Flags: bus master, medium devsel, latency 32, IRQ 21
	Memory at 88100000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis

It looks like a supported card but the Subsystem id's are wrong. On the
wiki site the id's are 1ae4:0002.

Using kernel 2.6.39-gentoo-r3, form the gentoo distribution.

But when i replace the id's in the source code from the driver 
mantis_common.h
#define TECHNISAT 0x1ae4
into
#define TECHNISAT 0xffbf

and file
mantis_vp2040.h
#define CABLESTAR_HD2 0x0002
into
#define CABLESTAR_HD2 0x02e4

Then the driver loads just fine, and 1 get 4 devices
in /dev/dvb/adapter0/ demux0  dvr0  frontend0  net0

And wen installing tvheadend the card seams to work just fine. I
recorded several shows without any problem.

Is there a way to test if the driver is working good, and why am i
missing the ca0 device?

Thanks,

Rene



