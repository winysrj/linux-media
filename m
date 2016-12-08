Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52858 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751839AbcLHIVY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 03:21:24 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id D471860098
        for <linux-media@vger.kernel.org>; Thu,  8 Dec 2016 10:21:20 +0200 (EET)
Date: Thu, 8 Dec 2016 10:20:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] Smiapp runtime PM fixes
Message-ID: <20161208082050.GC16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches fix a compiler warning for the smiapp driver and also make
power management work again without runtime PM.

Please pull.


The following changes since commit 365fe4e0ce218dc5ad10df17b150a366b6015499:

  [media] mn88472: fix chip id check on probe (2016-12-01 12:47:22 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-pm

for you to fetch changes up to c29df33f9ec94226eab8ee92d8c66ab83c76659a:

  smiapp: Make suspend and resume functions __maybe_unused (2016-12-08 10:01:57 +0200)

----------------------------------------------------------------
Sakari Ailus (2):
      smiapp: Implement power-on and power-off sequences without runtime PM
      smiapp: Make suspend and resume functions __maybe_unused

 drivers/media/i2c/smiapp/smiapp-core.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
