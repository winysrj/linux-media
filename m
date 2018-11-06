Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52612 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729272AbeKFUOr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 15:14:47 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C46A6634C83
        for <linux-media@vger.kernel.org>; Tue,  6 Nov 2018 12:50:09 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gJyvx-0002Jc-J3
        for linux-media@vger.kernel.org; Tue, 06 Nov 2018 12:50:09 +0200
Date: Tue, 6 Nov 2018 12:50:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 4.20] Fix first event delivery
Message-ID: <20181106105009.iq3r3cv7fraks75t@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There turns out to have been an issue in the event subscription fix; in
particular the first control event is missed due to a subtle bug in the
patch.

This patch fixes it. Once it's in, I'll submit the corresponding patches to
the stable kernels.

Please pull.


The following changes since commit dafb7f9aef2fd44991ff1691721ff765a23be27b:

  v4l2-controls: add a missing include (2018-11-02 06:36:32 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/event-sub-fix-sign

for you to fetch changes up to cbafeff167c91243f336e1703d7f86aa019b973e:

  v4l: event: Add subscription to list before calling "add" operation (2018-11-06 10:57:34 +0200)

----------------------------------------------------------------
fix event subscription

----------------------------------------------------------------
Sakari Ailus (1):
      v4l: event: Add subscription to list before calling "add" operation

 drivers/media/v4l2-core/v4l2-event.c | 43 ++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 19 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
