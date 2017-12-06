Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:44446 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbdLFR7T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 12:59:19 -0500
Received: by mail-wm0-f66.google.com with SMTP id t8so8730690wmc.3
        for <linux-media@vger.kernel.org>; Wed, 06 Dec 2017 09:59:18 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 0/2] ddbridge: error handling improvements
Date: Wed,  6 Dec 2017 18:59:13 +0100
Message-Id: <20171206175915.20669-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Two commits which will improve the error handling when attaching of
(tuner) frontends fail, which complements the recent fixes in the
DVB core (esp. dvb_frontend.c), making sure that on failure there
won't be any frontend drivers left with a usecount > 0 and thus can
be unloaded without -f on rmmod.

Also, don't miserably fail and stop hard when a single frontend failed
to attach as other frontends connected to the current (or even other)
bridge(s) can still work perfectly fine, so rather initialise as much
as possible. (If a single PCI device fails to init, the kernel doesn't
stop probing everything else on the bus)

This goes ontop of the ddbridge-0.9.32 bump (see [1]) which should
have been merged for kernel 4.15rc1 originally, but unfortunately
wasn't. No idea (didn't test) if this applies without the 0.9.32
changes (and please don't try to find out to avoid any merge errors/
conflicts - thanks.).

[1] http://www.spinics.net/lists/linux-media/msg123707.html

Daniel Scheller (2):
  [media] ddbridge: improve error handling logic on fe attach failures
  [media] ddbridge: don't break on single/last port attach failure

 drivers/media/pci/ddbridge/ddbridge-core.c | 51 ++++++++++++++----------------
 1 file changed, 23 insertions(+), 28 deletions(-)

-- 
2.13.6
