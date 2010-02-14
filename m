Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41149 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab0BNRDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 12:03:42 -0500
Message-ID: <4B782CCA.3010903@s5r6.in-berlin.de>
Date: Sun, 14 Feb 2010 18:03:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>,
	Beat Michel Liechti <bml303@gmail.com>
Subject: How to add DVB-S2 support to firedtv?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

what steps need to be taken to get DVB-S2 support into the firedtv
driver?  (The status is, as far as I understood:  FireDTV S2 and Floppy
DTV S2 devices recognize HD channels during channel scan but cannot tune
to them.  FireDTV C/CI DVB-C boxes however tune and play back HD
channels just fine.)

I suppose the frontend needs to be extended for s2api.  Was there a
respective conversion in another DVB driver that can serve as a good
coding example?

Is documentation from Digital Everywhere required regarding the
vendor-specific AV/C requests (LNB_CONTROL? TUNE_QPSK2?) or is the
current driver code enough to connect the dots?

Is the transport stream different from DVB-C HD streams so that changes
to the isochronous I/O part would be required?
-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/
