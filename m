Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3LKP4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 10:56:32 -0500
Received: from avalon.localnet (unknown [91.178.175.146])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id F305035A6A
	for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 16:55:43 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] V4L2 OF fixes
Date: Wed, 11 Dec 2013 16:56:45 +0100
Message-ID: <3622703.qMZfg9Weee@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 989af88339db26345e23271dae1089d949c4a0f1:

  [media] v4l: vsp1: Add LUT support (2013-12-11 09:25:20 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to 4b3ee9dbee6e2b806ce0bc041066d8c73c0e850c:

  v4l: of: Drop endpoint node reference in v4l2_of_get_remote_port() 
(2013-12-11 16:55:37 +0100)

----------------------------------------------------------------
Laurent Pinchart (3):
      v4l: of: Return an int in v4l2_of_parse_endpoint()
      v4l: of: Remove struct v4l2_of_endpoint remote field
      v4l: of: Drop endpoint node reference in v4l2_of_get_remote_port()

 drivers/media/v4l2-core/v4l2-of.c | 10 +++++++---
 include/media/v4l2-of.h           |  6 ++----
 2 files changed, 9 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

