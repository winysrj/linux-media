Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58196 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755175Ab3LIAWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 19:22:42 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 55755600A5
	for <linux-media@vger.kernel.org>; Mon,  9 Dec 2013 02:22:39 +0200 (EET)
Date: Mon, 9 Dec 2013 02:22:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.14] smiapp and lm3560 fixes
Message-ID: <20131209002238.GL30652@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3f823e094b935c1882605f8720336ee23433a16d:

  [media] exynos4-is: Simplify fimc-is hardware polling helpers (2013-12-04 15:54:19 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git upstream

for you to fetch changes up to 1af0a5b798934777abba890abde5a3c5ef334277:

  media: i2c: lm3560: fix missing unlock on error, fault handling (2013-12-09 01:41:23 +0200)

----------------------------------------------------------------
Daniel Jeong (1):
      media: i2c: lm3560: fix missing unlock on error, fault handling

Ricardo Ribalda Delgado (1):
      smiapp: Fix BUG_ON() on an impossible condition

 drivers/media/i2c/lm3560.c             |   14 +++++++-------
 drivers/media/i2c/smiapp/smiapp-core.c |    1 -
 2 files changed, 7 insertions(+), 8 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
