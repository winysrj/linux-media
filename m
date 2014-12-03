Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33904 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLCPSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 10:18:42 -0500
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 438C0200E1
	for <linux-media@vger.kernel.org>; Wed,  3 Dec 2014 16:15:44 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.19] videobuf2 race condition fixes
Date: Wed, 03 Dec 2014 17:19:18 +0200
Message-ID: <1466206.MyET2Q2jVX@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Would it still be possible to get those two race condition fixes in v3.19 ?

The following changes since commit e8bd888a148cb55a5ba27070fdfeb62386c89577:

  [media] omap_vout: fix compile warnings (2014-12-02 11:35:05 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to b8e73cc952d29020370c8f005d242c178463f4ec:

  v4l: vb2: Fix race condition in _vb2_fop_release (2014-12-03 17:15:55 +0200)

----------------------------------------------------------------
Laurent Pinchart (2):
      v4l: vb2: Fix race condition in vb2_fop_poll
      v4l: vb2: Fix race condition in _vb2_fop_release

 drivers/media/v4l2-core/videobuf2-core.c | 35 +++++++++++--------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

-- 
Regards,

Laurent Pinchart

