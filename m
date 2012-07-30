Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54304 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751929Ab2G3JT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 05:19:58 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B6A0B60099
	for <linux-media@vger.kernel.org>; Mon, 30 Jul 2012 12:19:55 +0300 (EEST)
Date: Mon, 30 Jul 2012 12:19:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.6] Selection API compatibility fix, small SMIA++
 correction
Message-ID: <20120730091953.GD26642@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains an important for for the compatibility
definitions of the bounds rectangles. They were missing from the original
patches changing the selection rectangles.

There's an one-liner to fix double include in the SMIA++ driver, too.

Please pull:

The following changes since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:
  
  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 -0300)

are available in the git repository at:
  
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6

Duan Jiong (1):
      smiapp: remove duplicated include

Sakari Ailus (1):
      v4l: Add missing compatibility definitions for bounds rectangles
 
 drivers/media/video/smiapp/smiapp-core.c |    1 -
 include/linux/v4l2-common.h              |    8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
