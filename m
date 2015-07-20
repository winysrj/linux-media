Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58815 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbbGTNKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:10:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 0/6] fsl-viu: convert to the control framework
Date: Mon, 20 Jul 2015 15:09:27 +0200
Message-Id: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert this driver to the control framework and do a few more fixes to
make v4l2-compliance happy.

Most of these patches have been posted before over two years ago but I never
made a pull request for it.

This is the original patch series:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/60922

This patch series is basically the same, except rebased and patch 6 was added.

Regards,

	Hans

Hans Verkuil (6):
  fsl-viu: convert to the control framework.
  fsl-viu: fill in bus_info in vidioc_querycap.
  fsl-viu: fill in colorspace, always set field to interlaced.
  fsl-viu: add control event support.
  fsl-viu: small fixes.
  fsl-viu: drop format names

 drivers/media/platform/fsl-viu.c | 160 ++++++++++-----------------------------
 1 file changed, 41 insertions(+), 119 deletions(-)

-- 
2.1.4

