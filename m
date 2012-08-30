Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:36351 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2H3JqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 05:46:17 -0400
From: =?UTF-8?q?R=C3=A9mi=20Cardona?= <remi.cardona@smartjog.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RFC 0/2] ds3000 firmware loading improvements
Date: Thu, 30 Aug 2012 11:36:29 +0200
Message-Id: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Please consider these 2 patches as an RFC, especially the first one.

The first patch is something I've found while trying to wrap my head
around the driver and I could find no legitimate reason to keep this
lock since commit b9bf2ea, as dvb_frontend_init() is now only called in
a single thread within dvb_frontend_thread().

Here's a little context for the second patch: we (SmartJog) have found
a few TeVii S470/471 cards where the ds3000 front-end *sometimes*
reports that it already has a loaded firmware (the 0xb2 register) yet
the card does not really work. That's why I've added the printk() in
the second patch to display when such a case happens.

We thus have an extra patch that adds a module parameter to force the
firmware loading, regardless of the 0xb2 register's state. This patch
allows us to use cards that would otherwise fail. Would such a patch be
of interest?

Would a patch that completely removes the register check (and thus
always loads the firmware at init time) be a preferred alternative?

Thanks for any pointers/reviews.

Rémi Cardona

-- 
SmartJog | T: +33 1 5868 6229
27 Blvd Hippolyte Marquès, 94200 Ivry-sur-Seine, France
www.smartjog.com | a TDF Group company

