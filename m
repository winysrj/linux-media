Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53582 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0JMVh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 17:37:57 -0400
Date: Wed, 13 Oct 2010 23:37:39 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] dvb/firewire update
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.bc9b826db6ce1b36@s5r6.in-berlin.de>
Message-ID: <tkrat.272a442f2d4a2708@s5r6.in-berlin.de>
References: <AANLkTin53SY_xaed_tRfWRPOFmc65GmGzXrEt15ZyriW@mail.gmail.com>
 <4C90B4FB.2050401@s5r6.in-berlin.de>
 <AANLkTikQLd1_thyADU8AMjOATFQoZaJfko3Sn-qtNgQR@mail.gmail.com>
 <tkrat.85246f2f7084d010@s5r6.in-berlin.de>
 <tkrat.bc9b826db6ce1b36@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

please pull from the firedtv branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv

to receive the following update --- if you don't have it already in your
patch queue.  It adds a long asked for feature to FireWire sat
receivers.  Thanks.

Tommy Jonsson (1):
      V4L/DVB: firedtv: support for PSK8 for S2 devices. To watch HD.

 drivers/media/dvb/firewire/firedtv-avc.c |   30 +++++++++++++++++++++---
 drivers/media/dvb/firewire/firedtv-fe.c  |   36 ++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 6 deletions(-)
-- 
Stefan Richter
-=====-==-=- =-=- -==-=
http://arcgraph.de/sr/

