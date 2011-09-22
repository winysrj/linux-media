Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46630 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1IVGya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 02:54:30 -0400
Date: Thu, 22 Sep 2011 09:54:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [GIT FIXES FOR v3.2] Adp1653 fix
Message-ID: <20110922065425.GR1845@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 699cc1962c85351689c27dd46e598e4204fdd105:

  [media] TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder (2011-09-21 17:06:56 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.2-adp1653-1

Andy Shevchenko (1):
      adp1653: set media entity type

 drivers/media/video/adp1653.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
