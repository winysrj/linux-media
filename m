Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39534 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751667AbbJHIQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Oct 2015 04:16:50 -0400
Date: Thu, 8 Oct 2015 11:16:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com
Subject: [GIT PULL for v4.4] vb2 dma-contig and dma-sg cache sync fix
Message-ID: <20151008081647.GJ26916@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the two vb2 fixes from Tiffany Lin. I've split them into two and
added cc stable since these should be applied to kernels since v3.8 and
v3.19 respectively.

Please pull.

The following changes since commit f4f24d1fd0803e8b5de5da373276f5046bef7463:

  [media] drxd: use kzalloc in drxd_attach() (2015-10-03 11:44:32 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/vb2-nents-media-master

for you to fetch changes up to 7883759183985e8a94e237ed6f49ae3581a8e499:

  media: vb2 dma-sg: Fully cache synchronise buffers in prepare and finish (2015-10-07 14:14:26 +0300)

----------------------------------------------------------------
Tiffany Lin (2):
      media: vb2 dma-contig: Fully cache synchronise buffers in prepare and finish
      media: vb2 dma-sg: Fully cache synchronise buffers in prepare and finish

 drivers/media/v4l2-core/videobuf2-dma-contig.c | 5 +++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)


-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
