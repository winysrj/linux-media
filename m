Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47256 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbbCRQQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 12:16:22 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 1B06C2000D
	for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 17:15:06 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.1] OMAP4 ISS fixes
Date: Wed, 18 Mar 2015 18:16:30 +0200
Message-ID: <3019513.5S5mYyb0zW@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 
13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 4a54ad9a8419edde1ac99c196a3b927f076612e7:

  staging: media: omap4iss: video: Don't WARN() on unknown pixel formats 
(2015-03-18 16:41:23 +0200)

----------------------------------------------------------------
Laurent Pinchart (2):
      staging: media: omap4iss: Cleanup media entities after unregistration
      staging: media: omap4iss: video: Don't WARN() on unknown pixel formats

 drivers/staging/media/omap4iss/iss_ipipe.c   | 6 +++---
 drivers/staging/media/omap4iss/iss_ipipeif.c | 6 +++---
 drivers/staging/media/omap4iss/iss_resizer.c | 6 +++---
 drivers/staging/media/omap4iss/iss_video.c   | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

-- 
Regards,

Laurent Pinchart

