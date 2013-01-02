Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42721 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3ABLGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 06:06:52 -0500
Received: from avalon.localnet (unknown [91.178.66.146])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6EFB535A69
	for <linux-media@vger.kernel.org>; Wed,  2 Jan 2013 12:06:51 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] Subdev registration fix
Date: Wed, 02 Jan 2013 12:08:20 +0100
Message-ID: <5657247.oav9LVKzGh@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 8cd7085ff460ead3aba6174052a408f4ad52ac36:

  [media] get_dvb_firmware: Fix the location of firmware for Terratec HTC 
(2013-01-01 11:18:26 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git v4l2/core

Laurent Pinchart (1):
      v4l: Reset subdev v4l2_dev field to NULL if registration fails

 drivers/media/v4l2-core/v4l2-device.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

-- 
Regards,

Laurent Pinchart

