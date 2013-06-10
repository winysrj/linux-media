Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3FJKHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 06:07:39 -0400
Received: from avalon.localnet (unknown [91.178.194.8])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6F46235A4D
	for <linux-media@vger.kernel.org>; Mon, 10 Jun 2013 12:07:33 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] media core fix
Date: Mon, 10 Jun 2013 12:07:44 +0200
Message-ID: <2151129.VEqcNxVQZE@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a small fix for the media controller core, targetted at v3.11.

The following changes since commit ab5060cdb8829c0503b7be2b239b52e9a25063b4:

  [media] drxk_hard: Remove most 80-cols checkpatch warnings (2013-06-08 
22:11:39 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/media

for you to fetch changes up to 64efe52d0a6df07867109c868dc51ba081ab5fed:

  media: info leak in __media_device_enum_links() (2013-06-10 12:05:07 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      media: info leak in __media_device_enum_links()

 drivers/media/media-device.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
Regards,

Laurent Pinchart

