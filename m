Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48685 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614AbaCBPk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Mar 2014 10:40:27 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5CEC36008E
	for <linux-media@vger.kernel.org>; Sun,  2 Mar 2014 17:40:25 +0200 (EET)
Date: Sun, 2 Mar 2014 17:40:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] DocBook build fix
Message-ID: <20140302154024.GM15635@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a trivial fix for the DocBook build. Please pull.

The following changes since commit a06b429df49bb50ec1e671123a45147a1d1a6186:

  [media] au0828: rework GPIO management for HVR-950q (2014-02-28 15:21:31 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-doc-fix

for you to fetch changes up to 8a7beb0cc41415f50c13bedc4dc13a4a49895839:

  v4l: Trivial documentation fix (2014-03-02 17:23:36 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      v4l: Trivial documentation fix

 Documentation/DocBook/media/v4l/controls.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
