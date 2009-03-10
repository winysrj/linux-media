Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:49506 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZCJQzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 12:55:22 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: Patrick Boettcher <pb@linuxtv.org>
Subject: [PATCH] flexcop-pci: Print a message in case the new stream watchdog detects a problem
Date: Tue, 10 Mar 2009 17:55:14 +0100
Cc: Uwe Bugla <uwe.bugla@gmx.de>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0tptJXEOp84Q18f"
Message-Id: <200903101755.16111.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_0tptJXEOp84Q18f
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Patrick!

I am happy using the new software watchdog added to flexcop-pci driver, but I 
do not get any log message. So I added one. The message now uses deb_info, I 
hope this is appropriate.

Regards
Matthias

--Boundary-00=_0tptJXEOp84Q18f
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="flexcop-reset-msg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="flexcop-reset-msg.diff"

flexcop-pci: Print a message in case the new stream watchdog detects a problem

Print a message in case the new software IRQ watchdog detects a problem.
I choose the info message category, this can be changed if not appropriate.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-pci.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/b2c2/flexcop-pci.c
+++ v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -133,6 +133,7 @@ static void flexcop_pci_irq_check_work(s
 			deb_chk("no IRQ since the last check\n");
 			if (fc_pci->stream_problem++ == 3) {
 				struct dvb_demux_feed *feed;
+				deb_info("flexcop-pci: stream problem, resetting pid filter\n");
 
 				spin_lock_irq(&fc->demux.lock);
 				list_for_each_entry(feed, &fc->demux.feed_list,

--Boundary-00=_0tptJXEOp84Q18f--
