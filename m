Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47523 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1AQUKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 15:10:46 -0500
Date: Mon, 17 Jan 2011 21:07:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-media@vger.kernel.org
Subject: [PATCH incremental update] firedtv: fix remote control - addendum
Message-ID: <20110117210756.510d4135@stein>
In-Reply-To: <20110117170015.GA15404@core.coreip.homeip.net>
References: <20110116093921.6275ac89@stein>
	<20110117081703.GA22802@core.coreip.homeip.net>
	<20110117141758.56af41f5@stein>
	<20110117170015.GA15404@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dimitry notes that EV_SYN is also necessary between down and up,
otherwise userspace could combine their state.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Hi Mauro,
since you already pushed out the first version of "firedtv: fix remote
control with newer Xorg evdev", here is the differential patch to the
updated version.  It's surely not super urgent though.

 drivers/media/dvb/firewire/firedtv-rc.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/media/dvb/firewire/firedtv-rc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-rc.c
+++ b/drivers/media/dvb/firewire/firedtv-rc.c
@@ -190,6 +190,7 @@ void fdtv_handle_rc(struct firedtv *fdtv
 	}
 
 	input_report_key(idev, code, 1);
+	input_sync(idev);
 	input_report_key(idev, code, 0);
 	input_sync(idev);
 }


-- 
Stefan Richter
-=====-==-== ---= =---=
http://arcgraph.de/sr/
