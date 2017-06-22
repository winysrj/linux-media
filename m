Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38204 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750847AbdFVUxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 16:53:34 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 997BE600BE
        for <linux-media@vger.kernel.org>; Thu, 22 Jun 2017 23:53:26 +0300 (EEST)
Date: Thu, 22 Jun 2017 23:52:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.13] Media pipeline stop error handling fix
Message-ID: <20170622205255.GL12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

One more patch --- fixing media pipeline stopping sanity checks.

Please pull.


The following changes since commit 76724b30f222067faf00874dc277f6c99d03d800:

  [media] media: venus: enable building with COMPILE_TEST (2017-06-20 10:57:08 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.13-3

for you to fetch changes up to 47dbdecd391f58dee3c282f60c066743613378ce:

  media: entity: Catch unbalanced media_pipeline_stop calls (2017-06-22 17:35:31 +0300)

----------------------------------------------------------------
Kieran Bingham (1):
      media: entity: Catch unbalanced media_pipeline_stop calls

 drivers/media/media-entity.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
