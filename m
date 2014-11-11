Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42961 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753179AbaKKKgj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 05:36:39 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 6F16A60097
	for <linux-media@vger.kernel.org>; Tue, 11 Nov 2014 12:36:36 +0200 (EET)
Date: Tue, 11 Nov 2014 12:36:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for v3.18] Fix unintended BUG() in smiapp driver
Message-ID: <20141111103604.GB8214@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This simple patch fixes an unintended BUG() in the smiapp driver. This
should go to stable as well.

The patch in the tree is the same than sent to the list, except it cc's
stable@vger.kernel.org. This issue has existed since the very beginning so
the patch should be applied to the stable series as well.

The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:

  [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-fix-v3.18

for you to fetch changes up to b88104c04eb9611a34a6e6ab3fead33d0e93a19c:

  smiapp: Only some selection targets are settable (2014-11-09 01:57:49 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      smiapp: Only some selection targets are settable

 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
