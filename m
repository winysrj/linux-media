Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46633 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3KZQMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 11:12:25 -0500
Received: from avalon.localnet (unknown [109.134.93.159])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8DABA35A49
	for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 17:11:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] Sensor fix
Date: Tue, 26 Nov 2013 17:12:28 +0100
Message-ID: <5566635.cI06f1RQGF@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 258d2fbf874c87830664cb7ef41f9741c1abffac:

  Merge tag 'v3.13-rc1' into patchwork (2013-11-25 05:57:23 -0200)

are available in the git repository at:


  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to 2b9d9a26cb65d536bd609f5b59520f8727686158:

  mt9p031: Include linux/of.h header (2013-11-26 17:11:26 +0100)

----------------------------------------------------------------
Sachin Kamat (1):
      mt9p031: Include linux/of.h header

 drivers/media/i2c/mt9p031.c | 1 +
 1 file changed, 1 insertion(+)

-- 
Regards,

Laurent Pinchart

