Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36286 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZKHV15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 16:27:57 -0500
Date: Sun, 8 Nov 2009 22:27:36 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] DVB: firedtv: port to new firewire driver stack
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch series adapts the firedtv driver for
FireWire-attached DVB boxes and cards to the newer firewire-core kernel
API.  The driver will continue to work with the older ieee1394 kernel
API as well.  Which of the two IEEE 1394 stacks will be used depends on
which one was configured at build time.  If both were built, firedtv
transparently uses the stack which is bound to the FireWire controller.

This patch series depends on changes to firewire-core which were merged
into Linux 2.6.31.

There is some non-essential functionality yet to implement:
  - Finish FCP support in firewire-core so that more than one AV/C
    device can be used on the same FireWire bus at the same time.
  - Enhance firedtv to use firewire-core's channel and bandwidth
    allocation function for proper cooperation with non-FireDTV AV/C
    devices on the same bus.

Following as reply:
[PATCH 1/4] firedtv: move remote control workqueue handling into rc source file
[PATCH 2/4] firedtv: reform lock transaction backend call
[PATCH 3/4] firedtv: add missing include, rename a constant
[PATCH 4/4] firedtv: port to new firewire core

 drivers/media/dvb/firewire/Kconfig        |    7
 drivers/media/dvb/firewire/Makefile       |    1
 drivers/media/dvb/firewire/firedtv-1394.c |   37 +-
 drivers/media/dvb/firewire/firedtv-avc.c  |   50 +-
 drivers/media/dvb/firewire/firedtv-dvb.c  |   15
 drivers/media/dvb/firewire/firedtv-fw.c   |  385 ++++++++++++++++++++++
 drivers/media/dvb/firewire/firedtv-rc.c   |    2
 drivers/media/dvb/firewire/firedtv.h      |   17
 8 files changed, 471 insertions(+), 43 deletions(-)
-- 
Stefan Richter
-=====-==--= =-== -=---
http://arcgraph.de/sr/

