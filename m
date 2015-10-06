Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55653 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752847AbbJFWbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Oct 2015 18:31:12 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1EA9F60096
	for <linux-media@vger.kernel.org>; Wed,  7 Oct 2015 01:31:09 +0300 (EEST)
Date: Wed, 7 Oct 2015 01:30:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PULL FOR v4.4] smiapp module device of table
Message-ID: <20151006223038.GI26916@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains a single patch to add a module device of table to
the smiapp driver. Please pull.


The following changes since commit efe98010b80ec4516b2779e1b4e4a8ce16bf89fe:

  [media] DocBook: Fix remaining issues with VB2 core documentation (2015-10-05 09:12:56 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/smiapp-for-v4.4

for you to fetch changes up to 7eed8629b33e6ba8434d5698393241d5fe188a8a:

  smiapp: Export OF module alias information (2015-10-06 12:48:15 +0300)

----------------------------------------------------------------
Javier Martinez Canillas (1):
      smiapp: Export OF module alias information

 drivers/media/i2c/smiapp/smiapp-core.c | 1 +
 1 file changed, 1 insertion(+)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
