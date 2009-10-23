Return-path: <linux-media-owner@vger.kernel.org>
Received: from 60-241-246-14.static.tpgi.com.au ([60.241.246.14]:35488 "EHLO
	fw.iplatinum.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbZJWGIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 02:08:42 -0400
Received: from egroups.iplatinum.com.au (fs.iplatinum.com.au [192.168.226.1])
	by fw.iplatinum.com.au (8.14.3/8.14.3) with ESMTP id n9N5uI49008708
	for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 16:56:18 +1100
From: "Andrew Congdon" <andrew.congdon@iplatinum.com.au>
To: linux-media@vger.kernel.org
Subject: cx22702_readreg errors
Date: Fri, 23 Oct 2009 16:56:18 +1100
Message-ID: <20091023.Zxn.10620600@egroups.iplatinum.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm getting these errors:

cx22702_writereg: error (reg == 0x0c, val == 0x40, ret == -6)
cx22702_writereg: error (reg == 0x00, val == 0x01, ret == -6)
cx22702_writereg: error (reg == 0x0d, val == 0x00, ret == -6)
cx22702_writereg: error (reg == 0x0d, val == 0x01, ret == -6)
cx22702_readreg: readreg error (ret == -6)

after which the DVB-T card is unusable until the system is rebooted.
It happens with Fedora 10 and 11 (11 is worse).
The systems involved use ASUS M4N78-PRO boards with 5050e and 4850e
CPUs. I've tried a number of different DVB-T cards, the cx88 module
reports the card ids as 14, 19, 35 and 43. All produce the same
problem sooner or later.

The problem occurs soon after cpuspeed is started in Fedora 11.
In Fedora 10 the problem mightn't occur for several days.
On the Fedora 11 machine it appears the PCI bus is corrupt
because all devices are reported like this:

# lspci -v
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller (rev ff) (prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: r8169
        Kernel modules: r8169

I can't reproduce this behaviour unless a DVB card is installed.

I've seen this problem reported elsewhere.

Another system, only difference is the CPU is a 6000+ with card=14
doesn't exhibit the problem (yet?).

I've tried using the Mercurial code and the problem is the same.

Anyone have any ideas?

thanks
--
Andrew

