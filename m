Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gnuher.de ([78.47.12.54]:44812 "EHLO mail.gnuher.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab1LIKeR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 05:34:17 -0500
Received: from ultimate100.geggus.net ([2a01:198:297:1::1])
	by mail.gnuher.de (envelope-from
	<lists@fuchsschwanzdomain.de>)
	with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	id 1RYxF5-0005wi-BL
	for linux-media@vger.kernel.org; Fri, 09 Dec 2011 10:59:47 +0100
Received: from sven  by ultimate100.geggus.net (envelope-from
	<lists@fuchsschwanzdomain.de>)
	with local (Exim 4.72)
	id 1RYxF3-0000fZ-Pl
	for linux-media@vger.kernel.org; Fri, 09 Dec 2011 10:59:45 +0100
Date: Fri, 9 Dec 2011 10:59:45 +0100
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: linux-media@vger.kernel.org
Subject: Hauppauge ImpactVCB-e (cx23885)
Message-ID: <20111209095945.GA2225@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

we have been using bttv based framegrabber cards for years now, but
slowly computers featuring PCI-slots are starting to extinct now.

For this reason we got an ImpactVCB-e card to check if this one could be a
future option for our analog capture needs.

Unfortunately this cards do not seem to be supported by the cx23885 driver
yet (at least by the driver in the mainline kernel).

Looking at the sources (cx23885-cards.c) I found that some minor adjustments
seem to be needed and just adding the new subvendor ID will probably not be
enough.

Any suggestion for a patch that I could try my luck with?

Would it be a good Idea to add something like this to struct cx23885_subid?

              .subvendor = 0x0070,
              .subdevice = 0x7133,
              .card      = CX23885_BOARD_UNKNOWN,

BTW, here is what lsusb looks like:

05:00.0 0400: 14f1:8852 (rev 04)
        Subsystem: 0070:7133
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at d2200000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express Endpoint, MSI 00
        Capabilities: [80] Power Management version 2
        Capabilities: [90] Vital Product Data
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [200] Virtual Channel


Regards

Sven

-- 
Unix is simple and coherent, but it takes a genius – or at any rate a
programmer – to understand and appreciate the simplicity
(Dennis M. Ritchie)
/me is giggls@ircnet, http://sven.gegg.us/ on the Web
